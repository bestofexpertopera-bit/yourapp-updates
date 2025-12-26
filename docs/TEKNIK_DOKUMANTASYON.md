# 🔧 Teknik Dokümantasyon

Bu dokümanda uygulamanın teknik detayları açıklanmaktadır.

---

## 📁 Proje Yapısı

```
Mobil Uygulama/
├── capacitor-app/                 # Ana uygulama
│   ├── www/                       # Web kaynak dosyaları
│   │   ├── app.html              # ⭐ Ana uygulama (12.800+ satır)
│   │   └── index.html            # Redirect sayfası
│   ├── android/                   # Android projesi
│   │   ├── app/
│   │   │   ├── src/main/
│   │   │   │   ├── AndroidManifest.xml
│   │   │   │   ├── res/          # Kaynaklar (ikonlar vb.)
│   │   │   │   └── java/         # Native kod
│   │   │   ├── build.gradle      # App build config
│   │   │   └── google-services.json
│   │   ├── keystore/             # APK imzalama
│   │   └── build.gradle          # Project build config
│   ├── capacitor.config.json     # Capacitor ayarları
│   └── package.json              # NPM bağımlılıkları
│
├── github-updates/                # OTA güncelleme repo'su
│   ├── app.html                  # Güncel uygulama kodu
│   ├── config.json               # Uzak yapılandırma
│   ├── manifest.json             # Versiyon bilgisi
│   └── README.md
│
├── push-server/                   # Vercel Push API
│   ├── api/
│   │   └── send-notification.js  # Serverless function
│   ├── vercel.json               # Vercel config
│   └── package.json
│
├── scripts/                       # Yardımcı scriptler
│   ├── Guncelleme-Yayinla.ps1   # OTA yayınlama
│   └── Key-Degistir.ps1         # Key değiştirme
│
├── docs/                          # Dokümantasyon
└── assets/                        # Görseller
```

---

## 🔥 Firebase Yapısı

### Authentication
```
Firebase Auth
├── Email/Password Provider (etkin)
├── Password Reset (etkin)
└── Session Management (token-based)
```

### Firestore Collections

#### `users` Collection
```javascript
users/{userId} = {
    email: "user@example.com",
    username: "username",
    createdAt: Timestamp,
    profilePhoto: "https://...",  // İsteğe bağlı
    isAdmin: false,               // Admin mi?
    adminLevel: 0,                // 0-3 arası
    fcmToken: "token...",         // Push token
    keyActivated: true,           // Key durumu
    keyCode: "THEBEST2024",       // Kullanılan key
    lastPasswordChange: Timestamp // Son şifre değişikliği
}
```

#### `games` Collection
```javascript
games/{gameId} = {
    title: "Game Name",
    description: "Açıklama...",
    price: 99.99,
    category: "action",
    imageUrl: "https://...",
    features: ["Feature 1", "Feature 2"],
    isActive: true,
    createdAt: Timestamp,
    order: 1  // Sıralama
}
```

#### `orders` Collection
```javascript
orders/{orderId} = {
    userId: "uid...",
    userEmail: "user@example.com",
    gameId: "gameId...",
    gameTitle: "Game Name",
    status: "pending",  // pending, approved, rejected
    notes: "Kullanıcı notu",
    createdAt: Timestamp,
    processedAt: Timestamp,
    processedBy: "admin@example.com"
}
```

#### `chats` Collection
```javascript
chats/{chatId} = {
    participants: ["userId", "adminId"],
    lastMessage: "Son mesaj...",
    lastMessageAt: Timestamp,
    unreadCount: {
        [userId]: 2,
        [adminId]: 0
    }
}

chats/{chatId}/messages/{messageId} = {
    senderId: "userId",
    text: "Mesaj içeriği",
    timestamp: Timestamp,
    read: false
}
```

#### `settings` Collection
```javascript
settings/appConfig = {
    popupEnabled: false,
    popupTitle: "Başlık",
    popupDescription: "Açıklama",
    popupImage: "https://...",
    popupButton: "Buton Text",
    popupLink: "https://...",
    announcement: "",
    maintenanceMode: false,
    maintenanceMessage: "Bakım mesajı"
}
```

#### `notifications` Collection
```javascript
notifications/{notificationId} = {
    userId: "uid...",
    title: "Bildirim başlığı",
    body: "Bildirim içeriği",
    type: "order",  // order, system, promo
    read: false,
    createdAt: Timestamp,
    data: { ... }  // Ek veri
}
```

### Firestore Security Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Kullanıcılar - sadece kendi verisini okuyabilir
    match /users/{userId} {
      allow read: if request.auth != null && request.auth.uid == userId;
      allow write: if request.auth != null && request.auth.uid == userId;
      // Admin tüm kullanıcıları okuyabilir
      allow read: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin == true;
    }
    
    // Oyunlar - herkes okuyabilir, admin yazabilir
    match /games/{gameId} {
      allow read: if true;
      allow write: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin == true;
    }
    
    // Siparişler - kendi siparişini okuyabilir
    match /orders/{orderId} {
      allow read: if request.auth != null && 
        (resource.data.userId == request.auth.uid || 
         get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin == true);
      allow create: if request.auth != null;
      allow update: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin == true;
    }
    
    // Ayarlar - herkes okuyabilir, admin yazabilir
    match /settings/{docId} {
      allow read: if true;
      allow write: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin == true;
    }
    
    // Sohbetler
    match /chats/{chatId} {
      allow read, write: if request.auth != null && 
        request.auth.uid in resource.data.participants;
      match /messages/{messageId} {
        allow read, write: if request.auth != null;
      }
    }
    
    // Bildirimler
    match /notifications/{notificationId} {
      allow read: if request.auth != null && 
        resource.data.userId == request.auth.uid;
      allow write: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin == true;
    }
  }
}
```

---

## 🐙 GitHub OTA Sistemi

### Çalışma Prensibi
```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  Uygulama   │────▶│  GitHub API │────▶│  manifest   │
│  Başlatma   │     │  (Raw File) │     │   .json     │
└─────────────┘     └─────────────┘     └─────────────┘
       │                                       │
       │                                       ▼
       │                              ┌─────────────┐
       │                              │  Versiyon   │
       │                              │  Karşılaş.  │
       │                              └─────────────┘
       │                                       │
       │                    Güncelleme var mı? │
       │                    ┌──────────────────┴──────────┐
       │                    │                             │
       │                   Evet                         Hayır
       │                    │                             │
       │                    ▼                             ▼
       │           ┌─────────────┐              ┌─────────────┐
       │           │  app.html   │              │   Devam     │
       │           │   İndir     │              │   (normal)  │
       │           └─────────────┘              └─────────────┘
       │                    │
       │                    ▼
       │           ┌─────────────┐
       └──────────▶│  WebView    │
                   │  Güncelle   │
                   └─────────────┘
```

### API Çağrıları
```javascript
// manifest.json çekme
const manifestUrl = `https://raw.githubusercontent.com/${GITHUB_REPO}/${GITHUB_BRANCH}/manifest.json`;
const response = await fetch(manifestUrl, {
    headers: {
        'Authorization': `token ${GITHUB_TOKEN}`,
        'Accept': 'application/vnd.github.v3.raw'
    }
});

// config.json çekme
const configUrl = `https://raw.githubusercontent.com/${GITHUB_REPO}/${GITHUB_BRANCH}/config.json`;

// app.html çekme (güncelleme için)
const appUrl = `https://raw.githubusercontent.com/${GITHUB_REPO}/${GITHUB_BRANCH}/app.html`;
```

### Versiyon Karşılaştırma
```javascript
function compareVersions(v1, v2) {
    const parts1 = v1.split('.').map(Number);
    const parts2 = v2.split('.').map(Number);
    
    for (let i = 0; i < Math.max(parts1.length, parts2.length); i++) {
        const p1 = parts1[i] || 0;
        const p2 = parts2[i] || 0;
        if (p1 > p2) return 1;
        if (p1 < p2) return -1;
    }
    return 0;
}
```

---

## 📲 Push Notification Sistemi

### Akış Diyagramı
```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Admin     │────▶│  Vercel     │────▶│   Firebase  │
│  Paneli     │     │    API      │     │     FCM     │
└─────────────┘     └─────────────┘     └─────────────┘
                                               │
                                               ▼
                                        ┌─────────────┐
                                        │   Cihaz     │
                                        │  (Client)   │
                                        └─────────────┘
```

### Vercel Serverless Function
```javascript
// api/send-notification.js
module.exports = async (req, res) => {
    // CORS headers
    res.setHeader('Access-Control-Allow-Origin', '*');
    
    // API Key doğrulama
    if (req.headers['x-api-key'] !== process.env.API_KEY) {
        return res.status(401).json({ error: 'Unauthorized' });
    }
    
    // Firebase Admin ile gönderim
    const message = {
        notification: { title, body },
        token: deviceToken  // veya topic: 'all_users'
    };
    
    await admin.messaging().send(message);
};
```

### Client Tarafı (Capacitor)
```javascript
import { PushNotifications } from '@capacitor/push-notifications';

// Token alma
PushNotifications.addListener('registration', (token) => {
    // Token'ı Firestore'a kaydet
    db.collection('users').doc(userId).update({
        fcmToken: token.value
    });
});

// Bildirim alma
PushNotifications.addListener('pushNotificationReceived', (notification) => {
    showNotificationToast(notification);
});
```

---

## 📱 Capacitor Yapılandırması

### capacitor.config.json
```json
{
    "appId": "com.thebestml.installer",
    "appName": "Game Store",
    "webDir": "www",
    "bundledWebRuntime": false,
    "android": {
        "allowMixedContent": true,
        "backgroundColor": "#1a1a2e",
        "webContentsDebuggingEnabled": true
    },
    "server": {
        "androidScheme": "https",
        "allowNavigation": ["*"],
        "cleartext": true
    }
}
```

### Kullanılan Capacitor Pluginleri
| Plugin | Versiyon | Kullanım |
|--------|----------|----------|
| @capacitor/core | 8.0.0 | Core functionality |
| @capacitor/android | 8.0.0 | Android platform |
| @capacitor/app | 8.0.0 | App lifecycle |
| @capacitor/push-notifications | 8.0.0 | FCM entegrasyonu |
| @capacitor/local-notifications | 8.0.0 | Yerel bildirimler |

---

## 🔄 Build Süreci

### Debug Build
```bash
cd capacitor-app
npm install
npx cap sync android
cd android
./gradlew assembleDebug
# APK: app/build/outputs/apk/debug/app-debug.apk
```

### Release Build
```bash
cd android
./gradlew assembleRelease
# APK: app/build/outputs/apk/release/app-release.apk
```

### APK İmzalama (Manual)
```bash
# Keystore oluştur
keytool -genkey -v -keystore release.keystore \
    -alias myapp -keyalg RSA -keysize 2048 -validity 10000

# APK imzala
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 \
    -keystore release.keystore app-release-unsigned.apk myapp

# Zipalign
zipalign -v 4 app-release-unsigned.apk app-release.apk
```

---

## 🔐 Güvenlik Mimarisi

### Kimlik Doğrulama Akışı
```
┌─────────┐     ┌─────────┐     ┌─────────┐
│  Login  │────▶│ Firebase│────▶│  Token  │
│  Form   │     │   Auth  │     │  Döner  │
└─────────┘     └─────────┘     └─────────┘
                                     │
                                     ▼
                              ┌─────────────┐
                              │ LocalStorage│
                              │   (Cache)   │
                              └─────────────┘
```

### Hassas İşlemler
Şifre değiştirme gibi hassas işlemler için re-authentication gerekir:

```javascript
const credential = firebase.auth.EmailAuthProvider.credential(
    user.email, 
    currentPassword
);
await user.reauthenticateWithCredential(credential);
await user.updatePassword(newPassword);
```

### API Güvenliği
- Push API: `x-api-key` header ile korumalı
- GitHub API: Personal Access Token
- Firebase: Security Rules ile korumalı

---

## 📊 Performans Optimizasyonları

### Lazy Loading
- Oyunlar sayfa sayfa yüklenir
- Görseller lazy load edilir

### Caching
- Config verileri LocalStorage'da cache'lenir
- Firebase offline persistence aktif

### Bundle Optimizasyonu
- Tek HTML dosyası (tüm CSS/JS inline)
- Firebase SDK'ları CDN'den
- Minify edilmemiş (okunabilirlik için)
