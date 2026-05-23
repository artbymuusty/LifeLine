# ⚙️ LifeLine - Backend Server

This directory contains the **LifeLine** REST API backend server powered by **Node.js** and **Express.js**.

It utilizes **Microsoft SQL Server (MSSQL)** as the primary database engine to securely log citizen emergency alerts, health profiles, and credentials.

---

## 🏗️ Architecture

The backend follows a clean, modular **Controller-Route-Middleware** structure:

```
src/
├── config/           # Database connection and pooling settings (db.js)
├── controllers/      # Route request handler logic (Auth, User, HelpRequest controllers)
├── middleware/       # JWT auth authorization and global error controllers
├── routes/           # REST router mappings
├── utils/            # Helper validation utils (validators.js)
├── app.js            # Express application configurations and CORS setup
└── server.js         # Entrypoint initiating database and starting HTTP listener
```

---

## 🔌 API Summary

### Authentication (Public)
- `POST /login` -> Authenticates citizens with TC Identity and password, delivering signed JWT keys.

### Citizen Profiles (Protected)
- `GET /user/profile` -> Fetches the active citizen's demographic details.
- `PUT /user/profile` -> Updates citizen details (email, phone, name).

### Emergency Calls (Protected)
- `POST /help_requests` -> Publishes a new emergency call (GPS coordinates, health metrics).
- `GET /help_requests` -> Lists all active emergency calls chronologically. *(Restricted: Responders/Admins only)*

---

## 🚀 Setup & Startup

### 1. Install dependencies
```bash
npm install
```

### 2. Configure variables
Create a `.env` file (copied from `.env.example`):
```env
PORT=3000
DB_HOST=localhost
DB_PORT=1433
DB_NAME=acil_yardim_uygulamasi
DB_USER=api_user
DB_PASS=db_user_password
JWT_SECRET=super_secret_jwt_sign_key_123
NODE_ENV=development
CORS_ORIGIN=*
```

### 3. Start development server
```bash
npm run dev
```

---

## 🛡️ Security Implementations
- **Stateless Authorization:** Token checks signed with high-entropy JWT secrets.
- **BOLA Protection:** Automatic retrieval of citizen IDs from cryptographically checked tokens instead of payloads.
- **CORS Safeguard:** Customizable origins managed strictly from `.env` policies.
- **Log Sanitization:** Secure terminal logging omitting PII parameters.
