import jwt from 'jsonwebtoken';

export function authMiddleware(req, res, next) {
  const authHeader = req.headers['authorization'];
  if (!authHeader) {
    return res.status(401).json({
      success: false,
      message: 'Yetkilendirme başlığı bulunamadı. Lütfen giriş yapın.'
    });
  }

  const parts = authHeader.split(' ');
  if (parts.length !== 2 || parts[0] !== 'Bearer') {
    return res.status(401).json({
      success: false,
      message: 'Geçersiz yetkilendirme biçimi. Bearer token gereklidir.'
    });
  }

  const token = parts[1];
  const secret = process.env.JWT_SECRET;
  if (!secret) {
    console.error('❌ JWT_SECRET is not defined in the environment variables!');
    return res.status(500).json({
      success: false,
      message: 'Sunucu hatası: JWT yapılandırması eksik.'
    });
  }

  try {
    const decoded = jwt.verify(token, secret);
    // Attach user properties from decoded token
    req.user = {
      userId: decoded.userId,
      role: decoded.role || 'user' // Default safely to 'user'
    };
    next();
  } catch (err) {
    console.error('JWT Verification Error:', err.message);
    return res.status(401).json({
      success: false,
      message: 'Geçersiz veya süresi dolmuş oturum anahtarı.'
    });
  }
}

export function requireRole(allowedRoles) {
  return (req, res, next) => {
    if (!req.user || !allowedRoles.includes(req.user.role)) {
      return res.status(403).json({
        success: false,
        message: 'Bu işlem için yetkiniz yetersizdir.'
      });
    }
    next();
  };
}
