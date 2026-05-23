// server.js

import dotenv from 'dotenv';
dotenv.config();

import express from 'express';
import cors from 'cors';
import sql from 'mssql';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';

const app = express();
app.use(cors());
app.use(express.json());

const dbConfig = {
  user:     process.env.DB_USER,
  password: process.env.DB_PASS,
  server:   process.env.DB_HOST,
  port:     Number(process.env.DB_PORT) || 1433,
  database: process.env.DB_NAME,
  options:  { trustServerCertificate: true }
};

async function startServer() {
  let pool;
  try {
    pool = await sql.connect(dbConfig);
    console.log('✅ DB bağlantısı başarılı');
  } catch (err) {
    console.error('❌ DB bağlantı hatası:', err);
    process.exit(1);
  }

  // Kullanıcı girişi
  app.post('/login', async (req, res) => {
    const { tc, password } = req.body;
    if (!tc || !password) {
      return res.status(400).json({ error: 'TC ve şifre gerekli.' });
    }
    try {
      const result = await pool
        .request()
        .input('tc', sql.NVarChar(20), tc)
        .query(`
          SELECT ID, Name, Surname, Age, Gender, Password_hash
          FROM [User]
          WHERE TC = @tc
        `);

      if (result.recordset.length === 0) {
        return res.status(401).json({ error: 'Geçersiz TC veya şifre.' });
      }

      const u = result.recordset[0];
      const match = await bcrypt.compare(password, u.Password_hash);
      if (!match) {
        return res.status(401).json({ error: 'Geçersiz TC veya şifre.' });
      }

      const secret = process.env.JWT_SECRET;
      if (!secret) {
        console.error('❌ JWT_SECRET tanımlı değil!');
        process.exit(1);
      }

      const token = jwt.sign({ userId: u.ID }, secret, { expiresIn: '2h' });
      return res.json({
        token,
        user: {
          id:      u.ID,
          name:    u.Name,
          surname: u.Surname,
          age:     u.Age,
          gender:  (u.Gender || '').trim()
        }
      });
    } catch (err) {
      console.error('Login error:', err);
      return res.status(500).json({ error: 'Sunucu hatası.' });
    }
  });

  // Yardım taleplerini listele
  app.get('/help_requests', async (req, res) => {
    try {
      const result = await pool
        .request()
        .query(`
          SELECT
            Call_id           AS id,
            Kit_id            AS kitId,
            User_id           AS userId,
            [latitude-x]      AS lat,
            [longitude-y]     AS lng,
            [timestamp]       AS timestamp,
            user_conditions   AS conditions,
            user_allergies    AS allergies
          FROM EmergencyCalls
          ORDER BY [timestamp] DESC
        `);
      return res.json(result.recordset);
    } catch (err) {
      console.error('Fetch help_requests error:', err);
      return res.status(500).json({ error: 'Sunucu hatası.' });
    }
  });

  const KIT_MAP = { deprem: 1, sel: 2, ozel: 3 };

  // Yeni yardım talebi ekle
  app.post('/help_requests', async (req, res) => {
    console.log('▶ Incoming /help_requests payload:', req.body);
    const {
      kitType,
      userId,
      lat,
      lng,
      timestamp,
      conditions = [],
      allergies  = [],
      selectedItems = []
    } = req.body;

    const missing = [];
    if (!kitType)      missing.push('kitType');
    if (userId == null) missing.push('userId');
    if (lat == null)    missing.push('lat');
    if (lng == null)    missing.push('lng');
    if (!timestamp)     missing.push('timestamp');
    if (missing.length) {
      return res.status(400).json({
        error: `Eksik alanlar: ${missing.join(', ')}`,
        missingFields: missing
      });
    }

    const kitId = KIT_MAP[kitType];
    if (!kitId) {
      return res.status(400).json({ error: 'Geçersiz kitType değeri.' });
    }

    try {
      const r = pool.request()
        .input('Kit_id',          sql.Int,       kitId)
        .input('User_id',         sql.Int,       userId)
        .input('latitude_x',      sql.Float,     lat)
        .input('longitude_y',     sql.Float,     lng)
        .input('timestamp',       sql.DateTime2, new Date(timestamp))
        .input('user_conditions', sql.NVarChar(sql.MAX), JSON.stringify(conditions))
        .input('user_allergies',  sql.NVarChar(sql.MAX), JSON.stringify(allergies));

      const insertResult = await r.query(`
        INSERT INTO EmergencyCalls
          (Kit_id, User_id, [latitude-x], [longitude-y], [timestamp], user_conditions, user_allergies)
        OUTPUT INSERTED.Call_id
        VALUES
          (@Kit_id, @User_id, @latitude_x, @longitude_y, @timestamp, @user_conditions, @user_allergies)
      `);

      const callId = insertResult.recordset[0].Call_id;

      if (Array.isArray(selectedItems) && selectedItems.length) {
        for (const item of selectedItems) {
          await pool.request()
            .input('request_id', sql.Int,       callId)
            .input('item_name',  sql.NVarChar(255), item)
            .query(`
              INSERT INTO help_request_items (request_id, item_name)
              VALUES (@request_id, @item_name)
            `);
        }
      }

      return res.status(201).json({ message: 'Yardım kaydı eklendi.' });
    } catch (err) {
      console.error('Insert help_request error:', err);
      return res.status(500).json({ error: err.message });
    }
  });

  // Profil getir (GET)
  app.get('/user/profile', async (req, res) => {
    const userId = parseInt(req.query.userId, 10);
    if (!userId) {
      return res.status(400).json({ error: 'userId query parametre olarak gerekli.' });
    }
    try {
      const result = await pool.request()
        .input('Id', sql.Int, userId)
        .query(`
          SELECT
            ID    AS userId,
            Name  AS name,
            Phone AS phone,
            Email AS email
          FROM [User]
          WHERE ID = @Id
        `);
      if (!result.recordset.length) {
        return res.status(404).json({ error: 'Kullanıcı bulunamadı.' });
      }
      return res.json(result.recordset[0]);
    } catch (err) {
      console.error('Fetch profile error:', err);
      return res.status(500).json({ error: 'Sunucu hatası.' });
    }
  });

  // Profil güncelle (PUT)
  app.put('/user/profile', async (req, res) => {
    const { userId, name, phone, email } = req.body;
    const missing = [];
    if (userId == null) missing.push('userId');
    if (!name)          missing.push('name');
    if (!phone)         missing.push('phone');
    if (!email)         missing.push('email');
    if (missing.length) {
      return res.status(400).json({
        error: `Eksik alanlar: ${missing.join(', ')}`,
        missingFields: missing
      });
    }
    try {
      await pool.request()
        .input('Id',    sql.Int,      userId)
        .input('Name',  sql.NVarChar(50), name)
        .input('Phone', sql.NVarChar(20), phone)
        .input('Email', sql.NVarChar(50), email)
        .query(`
          UPDATE [User]
             SET Name  = @Name,
                 Phone = @Phone,
                 Email = @Email
           WHERE ID = @Id
        `);
      return res.json({ message: 'Profil başarıyla güncellendi.' });
    } catch (err) {
      console.error('Profile update error:', err);
      return res.status(500).json({ error: 'Sunucu hatası.' });
    }
  });

  // Tüm rotalar tanımlandıktan sonra dinlemeye başla
  const PORT = Number(process.env.PORT) || 3000;
  app.listen(PORT, '0.0.0.0', () => {
    console.log(`🚀 Server tüm arayüzlerde ${PORT} portunda çalışıyor...`);
  });

} // end startServer

startServer();
