import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import { getPool, sql } from '../config/db.js';

export async function login(req, res, next) {
  const { tc, password } = req.body;

  if (!tc || !password) {
    return res.status(400).json({
      success: false,
      message: 'TC Kimlik numarası ve şifre gereklidir.'
    });
  }

  try {
    const pool = getPool();
    const result = await pool
      .request()
      .input('tc', sql.NVarChar(20), tc)
      .query(`
        SELECT ID, Name, Surname, Age, Gender, Password_hash
        FROM [User]
        WHERE TC = @tc
      `);

    if (result.recordset.length === 0) {
      return res.status(401).json({
        success: false,
        message: 'Geçersiz TC Kimlik numarası veya şifre.'
      });
    }

    const u = result.recordset[0];
    const match = await bcrypt.compare(password, u.Password_hash);
    if (!match) {
      return res.status(401).json({
        success: false,
        message: 'Geçersiz TC Kimlik numarası veya şifre.'
      });
    }

    const secret = process.env.JWT_SECRET;
    if (!secret) {
      throw new Error('JWT_SECRET is not configured on the backend server.');
    }

    // Include userId and a default role of 'user' (unless we find admin conditions)
    // We safely default to 'user' or 'admin' depending on an ID list if wanted, 
    // but default role is 'user'.
    const token = jwt.sign(
      { userId: u.ID, role: 'user' },
      secret,
      { expiresIn: '24h' }
    );

    return res.status(200).json({
      success: true,
      message: 'Giriş işlemi başarılı.',
      data: {
        token,
        user: {
          id:      u.ID,
          name:    u.Name,
          surname: u.Surname,
          age:     u.Age,
          gender:  (u.Gender || '').trim()
        }
      }
    });
  } catch (err) {
    next(err);
  }
}
