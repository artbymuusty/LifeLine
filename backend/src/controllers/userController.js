import { getPool, sql } from '../config/db.js';
import { isValidEmail, isValidPhone } from '../utils/validators.js';

export async function getProfile(req, res, next) {
  const userId = req.user.userId; // Secure: get authenticated user id from JWT

  try {
    const pool = getPool();
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
      return res.status(404).json({
        success: false,
        message: 'Kullanıcı profili bulunamadı.'
      });
    }

    return res.status(200).json({
      success: true,
      message: 'Profil bilgileri başarıyla getirildi.',
      data: result.recordset[0]
    });
  } catch (err) {
    next(err);
  }
}

export async function updateProfile(req, res, next) {
  const userId = req.user.userId; // Secure: fetch directly from token
  const { name, phone, email } = req.body;

  const missing = [];
  if (!name) missing.push('name');
  if (!phone) missing.push('phone');
  if (!email) missing.push('email');

  if (missing.length) {
    return res.status(422).json({
      success: false,
      message: `Eksik alanlar mevcut: ${missing.join(', ')}`,
      missingFields: missing
    });
  }

  if (!isValidPhone(phone)) {
    return res.status(422).json({
      success: false,
      message: 'Geçersiz telefon numarası biçimi. Telefon numarası 10-11 haneli rakam olmalıdır.'
    });
  }

  if (!isValidEmail(email)) {
    return res.status(422).json({
      success: false,
      message: 'Geçersiz e-posta adresi biçimi.'
    });
  }

  try {
    const pool = getPool();
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

    return res.status(200).json({
      success: true,
      message: 'Profil başarıyla güncellendi.'
    });
  } catch (err) {
    next(err);
  }
}
