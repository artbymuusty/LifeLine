# 🚨 LifeLine - Emergency Help Request System

**LifeLine** is a robust, production-grade **Emergency Help Request System** designed to streamline critical aid dispatching during natural disasters (earthquakes, floods, etc.) and medical emergencies.

It empowers citizens to transmit high-precision GPS coordinates, health profiles (chronic illnesses, allergies), and material demands (emergency kits) to responders in seconds, even under high-stress conditions.

---

## ⚡ Problem & Solution

### ⚠️ The Problem
During disasters, panic, network congestion, or communication barriers can delay rescue operations. Citizens struggle to explain their exact coordinates or communicate critical personal health profiles (such as asthma, diabetes, or drug allergies) that rescue teams must know *before* administering aid.

### 💡 The Solution
**LifeLine** resolves this by automating the location discovery and consolidating personal health attributes into a single-button emergency payload. Standardized data models are transmitted over secure, authenticated HTTP channels to centralized responder portals, eliminating coordination overhead and saving lives.

---

## ✨ Key Features
- 🗺️ **High-Precision GPS Capture:** Automated coordinate resolution (`geolocator`) via the mobile app.
- 🩺 **User Health Profiles:** Local and remote management of chronic conditions and life-threatening allergies.
- 🎒 **SQLite Emergency Bags:** Lightweight local database (`sqflite`) for citizens to assemble personalized custom kit items.
- 🔑 **JWT Stateless Authorization:** Cryptographically signed session tokens (`jsonwebtoken`) for protected resource security.
- 🛡️ **BOLA / IDOR Protection:** User identifiers (userId) are extracted exclusively from secure JWT signatures instead of query fields.
- 👮 **Role-Based Access Control:** Rote restrictions mapping responders/admins for help history lookups.
- 🎨 **Adaptive UI & Themes:** Sleek light/dark visuals persisted locally via `shared_preferences`.
- 📊 **Structured API Contracts:** Standardized response models (`success`, `message`, `data`) and correct HTTP status codes.

---

## 🏗️ Architecture

```
  ┌─────────────────────────────────────────────────────────┐
  │                 📱 Flutter Mobile App                   │
  │  (Screens Widget ──> Provider State ──> ApiService)     │
  └─────────────────────────────────────────────────────────┘
                               │
                               │ HTTPS (Bearer Token)
                               ▼
  ┌─────────────────────────────────────────────────────────┐
  │              ⚙️ Node.js / Express Backend               │
  │  (app.js ──> authMiddleware ──> Routes ──> Controller)  │
  └─────────────────────────────────────────────────────────┘
                               │
                               │ Connection Pooling (mssql)
                               ▼
  ┌─────────────────────────────────────────────────────────┐
  │                 🗄️ MS SQL Server Database               │
  └─────────────────────────────────────────────────────────┘
```

---

## 📂 Folder Structure

```
life_line/
├── acil_yardim_app/          # 📱 Flutter Mobile Application
│   ├── lib/
│   │   ├── core/             # Themes, custom layout tokens
│   │   ├── models/           # Serializable entities (User, HelpRequest)
│   │   ├── providers/        # State controls (Auth, HelpRequest, Theme)
│   │   ├── services/         # Encapsulated networking & database
│   │   ├── screens/          # Pure presentation screen widgets
│   │   └── widgets/          # Reusable UI component elements
│   └── README.md             # Client-specific manual
│
├── backend/                  # ⚙️ Modular Node.js / Express Server
│   ├── src/
│   │   ├── config/           # SQL connection pool manager
│   │   ├── controllers/      # Route handler controllers
│   │   ├── middleware/       # JWT check & unified error middlewares
│   │   ├── routes/           # Mapped REST route controllers
│   │   ├── app.js            # Express app assembly
│   │   └── server.js         # HTTP server entrypoint
│   ├── .env.example          # Environment template
│   └── package.json          # Dependency mappings
│
├── database/                 # 🗄️ SQL schema definitions
│   └── schema.sql            
└── docs/                     # 📖 Deep technical architecture documents
    ├── api.md
    ├── database.md
    └── security.md
```

---

## 🔌 API Endpoints

| Method | Endpoint | Authenticated | Role Required | Description |
| :--- | :--- | :---: | :---: | :--- |
| `POST` | `/login` | ❌ No | Public | Authenticates citizen and issues JWT token |
| `GET` | `/user/profile` | 🔑 Yes | Standard User | Fetches active authenticated user profile |
| `PUT` | `/user/profile` | 🔑 Yes | Standard User | Updates citizen's profile details |
| `POST` | `/help_requests` | 🔑 Yes | Standard User | Inserts a new emergency alert to the DB |
| `GET` | `/help_requests` | 🔑 Yes | Admin/Responder | Retrieves list of all active emergency calls |

---

## 🛡️ Security Improvements
1. **JWT Verification:** Introduced stateless auth tokens signed with high-entropy keys on the backend.
2. **Broken Object Authorization Prevention:** Completely eliminated spoofing attacks by extracting user IDs from cryptographically verified token headers instead of payloads.
3. **Password Security:** Salt-hashed password encryption using **bcrypt** (10 salt rounds).
4. **Administrative Access Control:** Route-level checking verifying standard users cannot query emergency dispatch history logs.
5. **Log Cleansing:** Sanitized all backend log prints, preventing leakages of PII (national IDs, coordinates, personal health data).

---

## 🚀 Setup & Execution

### 1. Server (Backend) Startup
```bash
# Navigate to backend folder
cd backend

# Install production and development dependencies
npm install

# Run backend server in development mode (auto reload on save)
npm run dev
```

### 2. Client (Flutter Mobile) Startup
```bash
# Navigate to Flutter folder
cd acil_yardim_app

# Install flutter packages
flutter pub get

# Run on emulator/device passing the backend base URL dynamically
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000
```

---

## 💡 Environment Variables
Configure your backend parameters inside `backend/.env`:
```env
PORT=3000
DB_HOST=localhost
DB_PORT=1433
DB_NAME=acil_yardim_uygulamasi
DB_USER=api_user
DB_PASS=db_user_password
JWT_SECRET=super_secret_jwt_sign_key_123
NODE_ENV=development
```

---

## 🗺️ Roadmap
- 📶 **Offline Emergency Queue:** Storing help requests locally inside SQLite when offline and syncing automatically upon network restoration.
- 🔔 **Push Notifications:** Integrating Firebase Cloud Messaging (FCM) to push disaster response alerts.
- 📍 **Interactive Maps Panel:** Adding Google Maps clusters in administrative dashboards for rescue teams.
- 📦 **Supabase Migration:** Optional transition path for instant real-time sync capabilities.

---

## ✍️ Author
Developed by **Mustafa Özcan** (artbymuusty)
Licensed under the [MIT License](LICENSE).