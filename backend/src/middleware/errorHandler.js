export function errorHandler(err, req, res, next) {
  console.error('❌ Express Error Handler caught an error:', err.stack || err.message || err);
  
  const statusCode = err.statusCode || 500;
  const message = err.message || 'Dahili sunucu hatası.';
  
  res.status(statusCode).json({
    success: false,
    message,
    error: process.env.NODE_ENV === 'development' ? err.stack : undefined
  });
}
