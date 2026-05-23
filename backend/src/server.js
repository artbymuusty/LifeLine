import app from './app.js';
import { connectDB } from './config/db.js';
import dotenv from 'dotenv';

dotenv.config();

const PORT = Number(process.env.PORT) || 3000;

async function startServer() {
  try {
    // 1. Establish MS SQL Connection Pool
    await connectDB();

    // 2. Start Listening on HTTP Interfaces
    app.listen(PORT, '0.0.0.0', () => {
      console.log(`🚀 LifeLine Server running on port ${PORT}...`);
    });
  } catch (err) {
    console.error('❌ Server failed to start:', err.message || err);
    process.exit(1);
  }
}

startServer();
