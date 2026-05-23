/**
 * Input validation utilities for LifeLine Backend
 */

/**
 * Validates a Turkish National Identity Number (TC Kimlik No).
 * Must be exactly 11 digits.
 */
export function isValidTC(tc) {
  if (!tc || typeof tc !== 'string') return false;
  return /^\d{11}$/.test(tc);
}

/**
 * Validates a standard email address using regular expression.
 */
export function isValidEmail(email) {
  if (!email || typeof email !== 'string') return false;
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
}

/**
 * Validates phone numbers (must be digits and between 10 to 11 characters).
 */
export function isValidPhone(phone) {
  if (!phone || typeof phone !== 'string') return false;
  return /^\d{10,11}$/.test(phone);
}

/**
 * Validates passwords (must be at least 4 characters long).
 */
export function isValidPassword(password) {
  if (!password || typeof password !== 'string') return false;
  return password.length >= 4;
}
