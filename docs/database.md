# 🗄️ LifeLine Database Architecture

This document describes the database design, entity relationships, and schemas implemented in **LifeLine** across both the backend (MS SQL Server) and frontend (SQLite/Mobile Local DB).

---

## 1. MS SQL Server (Backend Database)

The backend utilizes **Microsoft SQL Server** for persistent, centralized storage of citizen information and emergency aid calls.

### Entity Relationship Diagram (Conceptual):
```
  ┌──────────────┐             ┌────────────────┐
  │    [User]    │ 1         * │ EmergencyCalls │
  ├──────────────┤─────────────├────────────────┤
  │ ID (PK)      │             │ Call_id (PK)   │
  │ TC (Unique)  │             │ Kit_id         │
  │ Name         │             │ User_id (FK)   │
  │ Surname      │             │ latitude-x     │
  │ Phone        │             │ longitude-y    │
  │ Email        │             │ timestamp      │
  └──────────────┘             └────────────────┘
                                        │ 1
                                        │
                                        │ *
                               ┌─────────────────┐
                               │help_request_items│
                               ├─────────────────┤
                               │ item_id (PK)    │
                               │ request_id (FK) │
                               │ item_name       │
                               └─────────────────┘
```

---

## 2. Table Definitions

### A. `[User]` Table
Stores citizen demographic information and security credentials.
- **`ID`** (`INT`, PK, Auto-Increment): Unique user identifier.
- **`TC`** (`NVARCHAR(20)`, Unique, Not Null): Citizen identity number.
- **`Password_hash`** (`NVARCHAR(255)`, Not Null): bcrypt hashed password.
- **`Name` / `Surname`** (`NVARCHAR(50)`, Not Null): Name details.
- **`Age`** (`INT`): Citizen age.
- **`Gender`** (`NCHAR(10)`): Citizen gender.
- **`Phone`** (`NVARCHAR(20)`): Contact phone number.
- **`Email`** (`NVARCHAR(50)`): Email address.

### B. `EmergencyCalls` Table
Tracks sent emergency help alerts.
- **`Call_id`** (`INT`, PK, Auto-Increment): Unique call identifier.
- **`Kit_id`** (`INT`, Not Null): Mapped kit type (1: Deprem, 2: Sel, 3: Özel).
- **`User_id`** (`INT`, FK, Not Null): Cascaded reference to user.
- **`latitude-x` / `longitude-y`** (`FLOAT`, Not Null): High precision GPS coordinates.
- **`timestamp`** (`DATETIME2`, Not Null): UTCTime of call creation.
- **`user_conditions`** (`NVARCHAR(MAX)`): Array of chronic conditions stored as JSON String.
- **`user_allergies`** (`NVARCHAR(MAX)`): Array of allergens stored as JSON String.

### C. `help_request_items` Table
Specifies individual custom items that a citizen requires inside their custom kit during an emergency.
- **`item_id`** (`INT`, PK, Auto-Increment): Unique item entry.
- **`request_id`** (`INT`, FK, Not Null): Cascaded reference to the associated `EmergencyCalls` entry.
- **`item_name`** (`NVARCHAR(255)`): Selected kit item name.

---

## 3. SQLite Database (Flutter Mobile Local DB)

For creating and storing **Custom Emergency Kits** on the user's mobile device, the Flutter app utilizes a lightweight local **SQLite** database (`sqflite`).

### Table Schema: `kits`
- **`id`** (`TEXT`, PK): Unique custom kit identifier (generated as `ozel_${millisecondsSinceEpoch}`).
- **`name`** (`TEXT`): User's custom nickname for their kit.
- **`items`** (`TEXT`): List of selected materials stored as a comma-separated String value.

### Data Model Serialization Flow:
- When a user adds items to their custom kit in `CustomKitCreateScreen`, the items are packaged as a `List<String>`.
- The `DatabaseService` encodes the list by joining elements with a comma (`items.join(',')`) before inserting them into SQLite.
- Upon retrieval, the String is decoded using `.split(',')` to reconstruct the `List<String>`.
