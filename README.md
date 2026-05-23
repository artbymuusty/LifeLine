# 🚨 LifeLine - Acil Yardım Sistemi

**LifeLine**, doğal afetler (deprem, sel vb.) ve diğer acil durumlarda hayati önem taşıyan bilgileri (konum, kronik rahatsızlıklar, alerjiler ve ihtiyaç duyulan acil durum malzemeleri) yetkililere hızlıca iletmek amacıyla geliştirilmiş kapsamlı bir **Mobil Acil Yardım Uygulaması** ve **Yönetim Servisi** projesidir.

Proje, kullanıcıların acil durumlarda panik anında bile saniyeler içinde yardım talebi oluşturabilmesini sağlayan modern bir mobil uygulama ile arka planda verileri güvenli şekilde işleyen ve depolayan bir sunucudan oluşur.

---

## 🏗️ Proje Mimarisi

Proje iki ana bileşenden oluşmaktadır:

```
life_line/
├── acil_yardim_app/      # 📱 Flutter Mobil Uygulaması
└── server.js             # ⚙️ Node.js / Express Backend Servisi
```

---

## 📱 1. Mobil Uygulama (Flutter)

Modern, hızlı ve kullanıcı dostu bir arayüze sahip olan mobil uygulama, **Flutter** ve **Dart** diliyle geliştirilmiştir.

### ✨ Temel Özellikler
- 🔑 **Kullanıcı Girişi & Güvenlik:** TC Kimlik No ve şifre ile güvenli giriş. JWT tabanlı oturum yönetimi.
- 🗺️ **Akıllı Ana Ekran:**
  - Tek dokunuşla otomatik GPS konumu tespiti.
  - Hazır acil durum kiti şablonları (Deprem, Sel vb.).
  - Kişiselleştirilmiş özel kit oluşturabilme (`CustomKitCreateScreen`).
  - Dinamik acil durum çağrısı gönderme.
- 🩺 **Sağlık Profili Bilgileri:** Acil müdahale ekiplerine iletilmek üzere kronik hastalıklar ve alerji bilgilerinin önceden tanımlanabilmesi.
- 📊 **Geçmiş Çağrılar:** Kullanıcının daha önce yaptığı çağrıların geçmişini listeleme (`CallHistoryScreen`).
- 🎨 **Karanlık/Aydınlık Tema:** Göz yormayan, acil durumlara uygun dinamik tema desteği (`ThemeProvider`).
- ℹ️ **Bilgilendirme Ekranları:** Acil durumlarda yapılması gerekenler ve SSS (Sıkça Sorulan Sorular) ekranları.

### 🛠️ Teknolojiler & Kütüphaneler
- **State Management:** `Provider` (AuthProvider, HelpRequestProvider, ThemeProvider)
- **Veri Depolama:** `sqflite` (Yerel veritabanı) & `shared_preferences`
- **Tasarım:** Vanilla Flutter Widgets & HSL Uyumlu Özel Temalar
- **Platform Bilgisi:** `package_info_plus`

---

## ⚙️ 2. Backend Servisi (Node.js & Express)

Mobil uygulamadan gelen talepleri güvenli bir şekilde işleyen ve **Microsoft SQL Server (MSSQL)** üzerinde depolayan arka plan servisidir.

### ✨ API Rotaları
- `POST /login`: Kullanıcı kimlik doğrulama, bcrypt ile şifre kontrolü ve JWT üretimi.
- `GET /help_requests`: Gönderilmiş olan tüm yardım taleplerini kronolojik sırayla listeler (Yetkili panelleri için).
- `POST /help_requests`: Konum, zaman damgası, kullanıcı sağlık bilgileri ve talep edilen acil kit malzemelerini veritabanına kaydeder.
- `GET /user/profile`: Kullanıcının profil bilgilerini getirir.
- `PUT /user/profile`: Kullanıcı adını, telefonunu veya e-posta adresini günceller.

### 🛠️ Teknolojiler
- **Node.js** & **Express.js**
- **Veritabanı Sürücüsü:** `mssql`
- **Şifreleme:** `bcrypt`
- **Oturum Yönetimi:** `jsonwebtoken` (JWT)
- **Çevre Değişkenleri:** `dotenv`

---

## 🚀 Kurulum ve Çalıştırma

### 1. Sunucu (Backend) Kurulumu

1. `life_line` kök dizinine gidin.
2. Bağımlılıkları yükleyin:
   ```bash
   npm install
   ```
3. Kök dizinde `.env` adında bir dosya oluşturun ve veritabanı bağlantı bilgilerinizi girin:
   ```env
   DB_HOST=localhost
   DB_NAME=acil_yardim_uygulamasi
   DB_USER=api_user
   DB_PASS=veritabani_sifreniz
   JWT_SECRET=guvenli_jwt_anahtariniz
   PORT=3000
   ```
4. Sunucuyu başlatın:
   ```bash
   node server.js
   ```

### 2. Mobil Uygulama (Flutter) Kurulumu

1. `acil_yardim_app` dizinine geçiş yapın:
   ```bash
   cd acil_yardim_app
   ```
2. Flutter paketlerini çekin:
   ```bash
   flutter pub get
   ```
3. Gerekli durumlarda `lib/utils/constants.dart` veya API servis dosyasındaki baz URL bilgisini kendi sunucu IP adresinize göre güncelleyin.
4. Uygulamayı çalıştırın:
   ```bash
   flutter run
   ```

---

## 🛡️ Lisans ve Katkıda Bulunma

Bu proje acil durumlarda hayat kurtarmak ve koordinasyonu artırmak amacıyla geliştirilmiştir. Katkıda bulunmak isterseniz lütfen bir Pull Request (PR) açın veya sorunları issues sekmesinden bildirin. 