# ⚙️ Yapılandırma Rehberi

Bu rehber, uygulamanın tüm yapılandırma noktalarını ve nasıl özelleştirileceğini açıklar.

---

## 🔥 Firebase Yapılandırması

### Dosya Konumları
| Dosya | Konum | Açıklama |
|-------|-------|----------|
| Web Config | `capacitor-app/www/app.html` (satır ~25) | Firebase web SDK config |
| Android Config | `capacitor-app/android/app/google-services.json` | Firebase Android config |
| Service Account | `.json` dosyası | Push bildirimler için (Vercel'e yüklenir) |

### Web Config Örneği
```javascript
const firebaseConfig = {
    apiKey: "AIzaSyXXXXXXXXXXXXXXXXXXXXXXXXX",
    authDomain: "your-project.firebaseapp.com",
    projectId: "your-project",
    storageBucket: "your-project.firebasestorage.app",
    messagingSenderId: "123456789012",
    appId: "1:123456789012:web:abcdef123456"
};
```

### Değiştirilecek Yerler
1. `capacitor-app/www/app.html` - Ana uygulama
2. `github-updates/app.html` - OTA güncelleme versiyonu

**ÖNEMLİ:** Her iki dosyada da aynı Firebase config olmalı!

---

## 🐙 GitHub Yapılandırması

### OTA Güncelleme Sistemi

#### Gerekli Dosyalar
```
github-updates/
├── app.html        # Güncel uygulama kodu
├── config.json     # Activation key ve ayarlar
├── manifest.json   # Versiyon bilgisi
└── README.md       # Repo açıklaması
```

#### manifest.json Yapısı
```json
{
    "version": "3.14.58",
    "buildNumber": 229,
    "minBuildNumber": 150,
    "releaseDate": "2025-12-24",
    "changelog": [
        "🔒 Şifre değiştirme özelliği eklendi",
        "✨ Yeni özellik açıklaması"
    ],
    "required": false
}
```

| Alan | Açıklama |
|------|----------|
| `version` | Görünen versiyon numarası |
| `buildNumber` | Dahili build numarası (karşılaştırma için) |
| `minBuildNumber` | Minimum desteklenen build |
| `releaseDate` | Yayın tarihi |
| `changelog` | Değişiklik listesi |
| `required` | Zorunlu güncelleme mi? |

#### config.json Yapısı
```json
{
    "key": "ACTIVATION_KEY_2024",
    "apkUrl": "https://github.com/USER/REPO/releases/download/vX.X.X/app.apk",
    "playStoreUrl": "https://play.google.com/store/apps/details?id=com.yourapp",
    "announcement": "Duyuru metni (boş bırakılabilir)",
    "maintenanceMode": false
}
```

### GitHub Token Yapılandırması
`app.html` içinde (~3200. satır):

```javascript
const GITHUB_TOKEN = 'ghp_XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
const GITHUB_REPO = 'USERNAME/REPO_NAME';
const GITHUB_BRANCH = 'main';
```

**Token İzinleri:**
- `repo` - Full control of private repositories
- `read:packages` (isteğe bağlı)

---

## ☁️ Push Notification Server (Vercel)

### API Endpoint
```
POST https://your-app.vercel.app/api/send-notification
```

### Headers
```
Content-Type: application/json
x-api-key: YOUR_API_KEY
```

### Environment Variables (Vercel)
| Değişken | Değer |
|----------|-------|
| `FIREBASE_SERVICE_ACCOUNT` | Service account JSON (tek satır) |
| `API_KEY` | Güçlü bir API key |

### Request Body Örnekleri

**Tek kullanıcıya:**
```json
{
    "token": "fcm_device_token",
    "title": "Bildirim Başlığı",
    "body": "Bildirim içeriği",
    "data": { "type": "order" }
}
```

**Tüm kullanıcılara (topic):**
```json
{
    "topic": "all_users",
    "title": "Duyuru",
    "body": "Tüm kullanıcılara gönderilen mesaj"
}
```

---

## 📱 Android Yapılandırması

### Paket Adı (Application ID)
Değiştirilecek yerler:

1. **capacitor.config.json:**
```json
{
    "appId": "com.yourapp.store",
    "appName": "Your App Name"
}
```

2. **android/app/build.gradle:**
```gradle
namespace = "com.yourapp.store"
applicationId "com.yourapp.store"
```

3. **Firebase Console:** Aynı paket adıyla Android uygulaması ekleyin

### Uygulama Adı
1. `capacitor.config.json` → `appName`
2. `android/app/src/main/res/values/strings.xml`

### Uygulama İkonu
```
android/app/src/main/res/
├── mipmap-hdpi/ic_launcher.png (72x72)
├── mipmap-mdpi/ic_launcher.png (48x48)
├── mipmap-xhdpi/ic_launcher.png (96x96)
├── mipmap-xxhdpi/ic_launcher.png (144x144)
└── mipmap-xxxhdpi/ic_launcher.png (192x192)
```

### APK İmzalama
`android/app/build.gradle`:

```gradle
signingConfigs {
    release {
        storeFile file('../keystore/release.keystore')
        storePassword 'YOUR_STORE_PASSWORD'
        keyAlias 'your_key_alias'
        keyPassword 'YOUR_KEY_PASSWORD'
    }
}
```

---

## 🎨 UI Özelleştirme

### Tema Renkleri
`app.html` CSS bölümü (~50. satır):

```css
:root {
    --primary-color: #4CAF50;
    --secondary-color: #2196F3;
    --background: #1a1a2e;
    --card-bg: #252540;
    --text-color: #ffffff;
    --accent: #FF9800;
}
```

### Logo Değiştirme
Header bölümünde logo URL'ini değiştirin:

```html
<img src="YOUR_LOGO_URL" class="header-logo">
```

### Uygulama Başlığı
```html
<title>Your App Name</title>
```

---

## 👤 Admin Ayarları

### Owner Email
`app.html` içinde:

```javascript
const OWNER_EMAIL = 'admin@yourdomain.com';
```

Bu e-posta ile giriş yapan kullanıcı otomatik olarak admin yetkilerine sahip olur.

### Admin Yetkileri (Firestore)
Diğer kullanıcıları admin yapmak için Firestore'da:

```javascript
// users/{userId}
{
    "email": "user@example.com",
    "isAdmin": true,  // Bu alanı ekleyin
    "adminLevel": 3   // Yetki seviyesi (1-3)
}
```

---

## 🔑 Key Sistemi

### Key Yapılandırması
`config.json` içinde:

```json
{
    "key": "YOUR_ACTIVATION_KEY"
}
```

### Key Kontrolü
Uygulama açılışında ve belirli işlemlerde key kontrolü yapılır.

---

## 📂 Dosya Referansları

### Ana Yapılandırma Dosyaları
| Dosya | İçerik |
|-------|--------|
| `capacitor-app/www/app.html` | Ana uygulama kodu |
| `capacitor-app/capacitor.config.json` | Capacitor ayarları |
| `capacitor-app/android/app/build.gradle` | Android build ayarları |
| `github-updates/config.json` | Uzak yapılandırma |
| `github-updates/manifest.json` | Versiyon bilgisi |
| `push-server/api/send-notification.js` | Push API |

### Değiştirmeniz Gereken Değerler Özeti
1. ✅ Firebase Config (2 yerde)
2. ✅ GitHub Token ve Repo
3. ✅ Push Server URL ve API Key
4. ✅ Owner Email
5. ✅ Activation Key
6. ✅ Paket adı (Application ID)
7. ✅ Uygulama adı
8. ✅ Keystore bilgileri
