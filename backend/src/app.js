import express from 'express';
import cors from 'cors';
import authRoutes from './routes/authRoutes.js';
import userRoutes from './routes/userRoutes.js';
import helpRequestRoutes from './routes/helpRequestRoutes.js';
import { errorHandler } from './middleware/errorHandler.js';

const app = express();

// Middleware config
app.use(cors());
app.use(express.json());

// Routes mapping
app.use('/', authRoutes); // Includes /login
app.use('/user', userRoutes); // Includes /user/profile
app.use('/help_requests', helpRequestRoutes); // Includes /help_requests POST/GET

// Wildcard 404 Route
app.use((req, res, next) => {
  res.status(404).json({
    success: false,
    message: `Aradığınız adres bulunamadı: ${req.originalUrl}`
  });
});

// Global Error Handler
app.use(errorHandler);

export default app;
