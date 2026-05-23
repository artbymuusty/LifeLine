# 🔌 LifeLine API Documentation

The LifeLine REST API manages standard citizen authentication, personal profiles, and emergency help requests. All requests and responses exchange structured JSON payloads.

---

## 1. API Endpoint Overview

| Method | Endpoint | Authenticated | Access Level | Description |
| :--- | :--- | :---: | :--- | :--- |
| `POST` | `/login` | ❌ No | Public | Authenticates citizen and issues JWT token |
| `GET` | `/user/profile` | 🔑 Yes | Citizen | Fetches active authenticated user profile |
| `PUT` | `/user/profile` | 🔑 Yes | Citizen | Updates profile properties |
| `POST` | `/help_requests` | 🔑 Yes | Citizen | Creates a new emergency call |
| `GET` | `/help_requests` | 🔑 Yes | Admin/Responder | Retrieves list of all emergency calls |

---

## 2. Request / Response Contracts

### A. Public Authentication
- **Endpoint:** `POST /login`
- **Request Body Schema:**
  ```json
  {
    "tc": "12345678901",
    "password": "user_password"
  }
  ```
- **Success Response (200 OK):**
  ```json
  {
    "success": true,
    "message": "Giriş işlemi başarılı.",
    "data": {
      "token": "eyJhbGciOi...",
      "user": {
        "id": 1,
        "name": "Furkan",
        "surname": "Özcan",
        "age": 24,
        "gender": "Erkek"
      }
    }
  }
  ```

---

### B. User Profiles (Protected)
- **Endpoint:** `GET /user/profile`
- **Request Headers:**
  ```http
  Authorization: Bearer <token>
  ```
- **Success Response (200 OK):**
  ```json
  {
    "success": true,
    "message": "Profil bilgileri başarıyla getirildi.",
    "data": {
      "userId": 1,
      "name": "Mustafa Furkan Özcan",
      "phone": "05321234567",
      "email": "user@example.com"
    }
  }
  ```

- **Endpoint:** `PUT /user/profile`
- **Request Headers:**
  ```http
  Authorization: Bearer <token>
  Content-Type: application/json
  ```
- **Request Body Schema:**
  ```json
  {
    "name": "Mustafa Furkan Özcan",
    "phone": "05321234567",
    "email": "user@example.com"
  }
  ```
- **Success Response (200 OK):**
  ```json
  {
    "success": true,
    "message": "Profil başarıyla güncellendi."
  }
  ```

---

### C. Help Requests (Protected)
- **Endpoint:** `POST /help_requests`
- **Request Headers:**
  ```http
  Authorization: Bearer <token>
  Content-Type: application/json
  ```
- **Request Body Schema:**
  ```json
  {
    "kitType": "deprem",
    "lat": 41.0082,
    "lng": 28.9784,
    "timestamp": "2026-05-24T00:09:47Z",
    "selectedItems": ["El Feneri", "Sargı Bezi"]
  }
  ```
- **Success Response (201 Created):**
  ```json
  {
    "success": true,
    "message": "Yardım talebi başarıyla oluşturuldu ve ekiplere iletildi.",
    "data": {
      "callId": 42,
      "kitType": "deprem",
      "lat": 41.0082,
      "lng": 28.9784,
      "timestamp": "2026-05-24T00:09:47Z"
    }
  }
  ```

- **Endpoint:** `GET /help_requests`
- **Request Headers:**
  ```http
  Authorization: Bearer <token>
  ```
- **Access Control:** Restricted to `admin` / `responder` roles.
- **Success Response (200 OK):**
  ```json
  {
    "success": true,
    "message": "Yardım çağrıları başarıyla getirildi.",
    "data": [
      {
        "id": 42,
        "kitId": 1,
        "userId": 1,
        "lat": 41.0082,
        "lng": 28.9784,
        "timestamp": "2026-05-24T00:09:47.000Z",
        "conditions": "[\"Astım\"]",
        "allergies": "[\"Penisilin\"]"
      }
    ]
  }
  ```
