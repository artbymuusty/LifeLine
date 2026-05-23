import sql from 'mssql';
import dotenv from 'dotenv';

dotenv.config();

const dbConfig = {
  user:     process.env.DB_USER,
  password: process.env.DB_PASS,
  server:   process.env.DB_HOST,
  port:     Number(process.env.DB_PORT) || 1433,
  database: process.env.DB_NAME,
  options:  { 
    trustServerCertificate: true,
    encrypt: false // change to true if using Azure/cloud SQL
  }
};

let pool;

export async function connectDB() {
  if (pool) return pool;
  try {
    pool = await sql.connect(dbConfig);
    console.log('✅ MS SQL Database connected successfully.');
    return pool;
  } catch (err) {
    console.error('❌ MS SQL Database connection error:', err);
    throw err;
  }
}

export function getPool() {
  if (!pool) {
    throw new Error('Database pool not initialized. Call connectDB() first.');
  }
  return pool;
}

export { sql };
