import { getPool, sql } from '../config/db.js';

const KIT_MAP = { deprem: 1, sel: 2, ozel: 3 };

export async function createHelpRequest(req, res, next) {
  const userId = req.user.userId; // Secure: get from verified JWT token
  const {
    kitType,
    lat,
    lng,
    timestamp,
    conditions = [],
    allergies  = [],
    selectedItems = []
  } = req.body;

  const missing = [];
  if (!kitType)      missing.push('kitType');
  if (lat == null)    missing.push('lat');
  if (lng == null)    missing.push('lng');
  if (!timestamp)     missing.push('timestamp');

  if (missing.length) {
    return res.status(422).json({
      success: false,
      message: `Eksik alanlar mevcut: ${missing.join(', ')}`,
      missingFields: missing
    });
  }

  const kitId = KIT_MAP[kitType];
  if (!kitId) {
    return res.status(400).json({
      success: false,
      message: 'Geçersiz acil durum kitType değeri.'
    });
  }

  try {
    const pool = getPool();
    
    // We'll perform the operations using a safe database request
    const insertResult = await pool.request()
      .input('Kit_id',          sql.Int,       kitId)
      .input('User_id',         sql.Int,       userId)
      .input('latitude_x',      sql.Float,     lat)
      .input('longitude_y',     sql.Float,     lng)
      .input('timestamp',       sql.DateTime2, new Date(timestamp))
      .input('user_conditions', sql.NVarChar(sql.MAX), JSON.stringify(conditions))
      .input('user_allergies',  sql.NVarChar(sql.MAX), JSON.stringify(allergies))
      .query(`
        INSERT INTO EmergencyCalls
          (Kit_id, User_id, [latitude-x], [longitude-y], [timestamp], user_conditions, user_allergies)
        OUTPUT INSERTED.Call_id
        VALUES
          (@Kit_id, @User_id, @latitude_x, @longitude_y, @timestamp, @user_conditions, @user_allergies)
      `);

    const callId = insertResult.recordset[0].Call_id;

    if (Array.isArray(selectedItems) && selectedItems.length) {
      for (const item of selectedItems) {
        if (!item) continue;
        await pool.request()
          .input('request_id', sql.Int,       callId)
          .input('item_name',  sql.NVarChar(255), item)
          .query(`
            INSERT INTO help_request_items (request_id, item_name)
            VALUES (@request_id, @item_name)
          `);
      }
    }

    return res.status(201).json({
      success: true,
      message: 'Yardım talebi başarıyla oluşturuldu ve ekiplere iletildi.',
      data: {
        callId,
        kitType,
        lat,
        lng,
        timestamp
      }
    });
  } catch (err) {
    next(err);
  }
}

export async function getHelpRequests(req, res, next) {
  try {
    const pool = getPool();
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

    return res.status(200).json({
      success: true,
      message: 'Yardım çağrıları başarıyla getirildi.',
      data: result.recordset
    });
  } catch (err) {
    next(err);
  }
}
