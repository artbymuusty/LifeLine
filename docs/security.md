# 🛡️ LifeLine Security Architecture

This document describes the security controls, authentication mechanisms, and best practices implemented in the **LifeLine** Emergency Help Request System.

---

## 1. Authentication & JWT Authorization

LifeLine utilizes **JSON Web Tokens (JWT)** for robust stateless authentication and session management.

### The Authentication Flow:
1. **Login Request:** The client sends the user's Turkish National ID (`TC`) and password over HTTPS (`POST /login`).
2. **Credential Verification:** The server compares the provided credentials with the stored record. Passwords are encrypted using **bcrypt** (salt round: 10), ensuring that raw passwords are never stored.
3. **Token Issuance:** If verified, the server signs a JWT containing the user ID (`userId`) and the user's role (`role`). The token is signed with a high-entropy secret (`JWT_SECRET`) and configured with a 24-hour expiration duration.
4. **Subsequent Calls:** For every protected route, the client attaches the token in the headers as:
   ```http
   Authorization: Bearer <token>
   ```

---

## 2. Secure Route Protection

All endpoints—except the public `/login`—are protected by the `authMiddleware.js` layer.

### Endpoint Security Mapping:

| Method | Endpoint | Auth Required | Access Level | Protection Mechanism |
| :--- | :--- | :---: | :--- | :--- |
| `POST` | `/login` | ❌ No | Public | Open access |
| `GET` | `/user/profile` | 🔑 Yes | Authorized User | JWT Signature Verification |
| `PUT` | `/user/profile` | 🔑 Yes | Authorized User | JWT Signature Verification |
| `POST` | `/help_requests` | 🔑 Yes | Authorized User | JWT Signature Verification |
| `GET` | `/help_requests` | 🔑 Yes | Admin / Responder | Role-based verification |

---

## 3. Prevention of Broken Object Level Authorization (BOLA/IDOR)

In legacy iterations, endpoints accepted a raw `userId` in either the query parameter or request body:
```http
GET /user/profile?userId=5
```
This was a significant security flaw since anyone could change `userId` to query or modify other users' sensitive personal records.

### The Solution:
In our refactored architecture, **the backend completely ignores any userId sent in the payload**. Instead, it extracts the `userId` directly from the secure, cryptographically verified JWT payload (`req.user.userId`). This ensures that:
- Users **can only** view and modify their own health profiles.
- Users **cannot** spoof or submit help requests on behalf of other users.

---

## 4. Role-Based Access Control (RBAC)

We implemented an RBAC middleware (`requireRole`) to secure administrative actions:
```javascript
router.get('/', requireRole(['admin', 'responder']), getHelpRequests);
```

### Roles Defined:
- **`user`:** Default role assigned to standard citizens. Allows creating help requests and managing personal profiles.
- **`responder` / `admin`:** Administrative roles. Allows fetching the history of emergency help requests to dispatch aid.

*Note: In the event of a missing `role` column in the database, the server defaults to standard user permissions (`user`), ensuring maximum security by default.*

---

## 5. Sensitive Data & Log Sanitization

To comply with privacy laws (such as KVKK and GDPR), all logs have been sanitized to remove sensitive personal data:
- Raw password strings, hashed outputs, Turkish ID numbers (TC), location coordinate arrays, and health data are **never** logged to the server terminal or persistent log files.
- Terminal outputs are limited to system event states (e.g., successful DB connection, routing errors, server port bindings).
