# 📱 LifeLine - Flutter Mobile Client

This subdirectory contains the **LifeLine** mobile application client built using **Flutter** and **Dart**.

The application is designed for speed, reliability, and security during emergency scenarios.

---

## ✨ Features Implemented
- 🔑 **Secure Authentication:** TC Identity verification with local JWT lifecycle persistence (`shared_preferences`).
- 🗺️ **GPS Location Dispatch:** Automated high-precision coordinate capturing (`geolocator`).
- 🩺 **User Health Profile:** Stores chronic conditions and allergens locally/remotely to aid emergency responders.
- 🎒 **SQLite Emergency Kits:** Custom local database implementation (`sqflite`) for personalized emergency bags.
- 🎨 **Adaptive Themes:** Light & Dark modes persisted across sessions.

---

## 🏗️ Architecture Reorganization

We adhere to a strict clean layer separation to prevent coupling UI logic with networking or storage details:

```
lib/
├── core/             # Base styling, static themes, helper assets
├── models/           # Typed serializable entity structures (User, HelpRequest)
├── providers/        # State Management (AuthProvider, HelpRequestProvider, ThemeProvider)
├── services/         # Encapsulated network (ApiService) and database (DatabaseService) calls
├── screens/          # Pure UI screen widgets (LoginScreen, HomeScreen, ProfileScreen)
└── widgets/          # Small, modular, reusable layout widgets
```

### Clean Architecture Rule:
- Screen widgets **never** make direct HTTP/Database calls. They delegate calls entirely through providers or database managers.
- Unused variables, logs, and imports have been eliminated to pass all `flutter analyze` static type checks.

---

## 🚀 Getting Started

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Configure environment variables
The app loads the Backend Base URL dynamically from the compilation arguments. Make sure to define `API_BASE_URL` when compiling or launching:

- **Launch on Android Emulator / Physical device:**
  ```bash
  flutter run --dart-define=API_BASE_URL=http://<YOUR_IP_OR_EMULATOR_ADDRESS>:3000
  ```
- *Example (Android Emulator Localhost):*
  ```bash
  flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000
  ```

---

## 🛡️ Static Verification
To verify code formatting and static type constraints:
```bash
flutter analyze
```
Our configuration guarantees clean static checks with zero compilation warnings!
