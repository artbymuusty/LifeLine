# 📱 LifeLine - Static PWA Demo Portal

This folder contains a 100% isolated, high-fidelity **Progressive Web App (PWA) Demo** for the **LifeLine** Emergency Help Request System. 

It is designed to run completely inside the client-side browser using HTML, CSS, and Javascript. **No backend servers, API keys, MS SQL databases, or Flutter compilation tools are required.** 

This makes it incredibly easy to host statically on services like **Vercel** or **Netlify** and instantly open it on any mobile device to take stunning app screenshots or demo recordings.

---

## ✨ Features Included
- 📱 **Sleek Device Emulator:** Centers the application inside a modern smartphone bezel on desktop screens, while displaying in native full-screen mode on actual mobile phones.
- ⚡ **Demo Auto-Login:** Pre-populated TC/Password inputs and a **Demo Hesabı Kullan** one-tap sign-in.
- 🩺 **Medikal Sağlık Özeti:** High-fidelity profile view displaying Mustafa Özcan's registered health record (A+ blood, Penicillin allergy, Asthma, and emergency contact detail).
- 🎒 **Acil Yardım Çantaları:** Fully interactive inventory checklists for Deprem, Sel, and Custom bags (with ability to append custom items).
- 🚨 **Pulse Emergency CTA:** A visually animated emergency help request button that glows and pulses.
- 🎛️ **Simüle Backend Terminal:** An integrated, simulated real-time terminal panel that logs colored mock API calls (`POST /auth/login`, `GET /user/profile`, `POST /help_requests`) as you click buttons in the app. Perfect for showing backend logic in your product screenshots!

---

## 🚀 How to Run Locally

To spin up the PWA locally, navigate to this folder and use any static server:

```bash
# 1. Navigate to this directory
cd test_pwa_demo

# 2. Run a lightweight Python server
python -m http.server 8080
```

Now open your browser and navigate to:
👉 **[http://localhost:8080](http://localhost:8080)**

*Alternative:* You can right-click `index.html` and select **"Open with Live Server"** inside VS Code.

---

## ☁️ How to Deploy on Vercel

Since this directory is a clean, static asset bundle, you can publish it to **Vercel** in seconds:

1. Import your repository into Vercel.
2. In the project setup, configure these exact **Project Settings**:
   - 📂 **Root Directory:** `test_pwa_demo`
   - ⚙️ **Framework Preset:** `Other` (or static)
   - 🛠️ **Build Command:** *(Leave blank)*
   - 📤 **Output Directory:** `.`
   - 📦 **Install Command:** *(Leave blank)*
3. Click **Deploy**. Vercel will instantly publish the PWA and give you a public URL (e.g., `https://lifeline-demo.vercel.app`).

---

## 📸 Step-by-Step Screenshot Workflow

To take high-fidelity, premium app screenshots on your mobile phone or browser emulator:

1. Open your Vercel URL or local address on your smartphone (or toggle Device Toolbar in Chrome DevTools).
2. **Screen 1 (Login Panel):** Take a screenshot of the Login view showing the auto-filled credentials and the glowing **"Demo Hesabı Kullan (Oto Giriş)"** button.
3. Tap **Demo Hesabı Kullan**. The screen will transition instantly, printing a mock request log in the background.
4. **Screen 2 (Home Hub):** Capture the dashboard showing the active GPS chip, the loaded health profile chip, and the massive glowing **"Acil Yardım Gönder"** button.
5. Tap **Profil** in the bottom navigation.
6. **Screen 3 (Profile Settings):** Screenshot the medical card showing **Mustafa Özcan**, A+ blood type, asthma chronic condition, Penicillin allergies, and emergency contact details. Update a field to trigger a profile update.
7. Tap **Çanta** in the bottom navigation.
8. **Screen 4 (Emergency Kit):** Toggle between **Deprem** and **Sel** tabs to showcase the built-in disaster checklists. Switch to **Özel Çantam**, type `El Radyosu` in the box, and tap `+` to add it. Screenshot the list!
9. Tap **Ana Sayfa**, and press the giant **Acil Yardım Gönder** button. A realistic loading animation will spinner for `1.2 seconds`.
10. **Screen 5 (Help Dispatch Success):** Capture the gorgeous confirmation modal showing **Çağrı İletildi!**, Request ID `LL-1001`, status `Received (Ekipler Yolda)`, and coordinates.
11. Tap **Ana Sayfa'ya Dön**, then tap **Loglar** in the bottom bar.
12. **Screen 6 (Simulated Backend Log):** Capture the beautiful terminal panel showing all visual color-coded logs (like `[DEMO] POST /auth/login - demo login successful`, `[DEMO] POST /help_requests - help request received`, etc.) showing your full simulated developer ecosystem.
13. *Optional PWA install:* Open in Safari (iOS) or Chrome (Android), tap "Add to Home Screen" to install it as a standalone native app!
