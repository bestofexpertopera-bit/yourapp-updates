# 📖 Sıfırdan Kurulum Rehberi

Bu rehber, TheBestML uygulamasını sıfırdan kurmanız için gereken tüm adımları içerir.

---

## 📋 Gereksinimler

### Yazılım Gereksinimleri
- **Node.js** v18+ (https://nodejs.org)
- **Android Studio** (https://developer.android.com/studio)
- **JDK 17+** (Eclipse Adoptium önerilir)
- **Git** (https://git-scm.com)
- **VS Code** (önerilir)

### Hesap Gereksinimleri
- **Firebase Hesabı** (https://firebase.google.com)
- **GitHub Hesabı** (https://github.com)
- **Vercel Hesabı** (https://vercel.com) - Push bildirimler için

---

## 🔥 Adım 1: Firebase Projesi Oluşturma

### 1.1 Yeni Proje Oluştur
1. https://console.firebase.google.com adresine gidin
2. "Proje ekle" butonuna tıklayın
3. Proje adını girin (örn: "myapp-store")
4. Google Analytics'i etkinleştirin (isteğe bağlı)
5. "Proje oluştur" butonuna tıklayın

### 1.2 Authentication Ayarları
1. Sol menüden "Authentication" seçin
2. "Sign-in method" sekmesine gidin
3. "E-posta/Şifre" sağlayıcısını etkinleştirin
4. Kaydedin

### 1.3 Firestore Database
1. Sol menüden "Firestore Database" seçin
2. "Veritabanı oluştur" butonuna tıklayın
3. "Üretim modunda başlat" seçin
4. Konum seçin (europe-west1 önerilir)
5. Güvenlik kurallarını ayarlayın (docs/FIRESTORE_YAPISI.md bakın)

### 1.4 Web Uygulaması Ekleme
1. Proje ayarlarına gidin (dişli ikonu)
2. "Genel" sekmesinde aşağı kaydırın
3. "</>" (Web) simgesine tıklayın
4. Uygulama adı girin
5. Firebase SDK yapılandırmasını kopyalayın

```javascript
const firebaseConfig = {
    apiKey: "YOUR_API_KEY",
    authDomain: "YOUR_PROJECT.firebaseapp.com",
    projectId: "YOUR_PROJECT_ID",
    storageBucket: "YOUR_PROJECT.firebasestorage.app",
    messagingSenderId: "YOUR_SENDER_ID",
    appId: "YOUR_APP_ID"
};
```

### 1.5 Cloud Messaging (FCM) Ayarları
1. Proje ayarlarına gidin
2. "Cloud Messaging" sekmesine gidin
3. "Web push sertifikaları" bölümünde "Anahtar çifti oluştur" tıklayın
4. VAPID key'i not alın

### 1.6 Android Uygulaması Ekleme
1. Proje ayarlarından "Android" simgesine tıklayın
2. Paket adı: `com.thebestml.installer` (veya kendi paket adınız)
3. SHA-1 sertifika parmak izi ekleyin (APK imzalama için)
4. `google-services.json` dosyasını indirin

### 1.7 Service Account Key (Push Bildirimler için)
1. Proje ayarları → "Hizmet hesapları"
2. "Yeni özel anahtar oluştur" tıklayın
3. JSON dosyasını indirin ve güvenli saklayın

---

## 🐙 Adım 2: GitHub Repository Kurulumu

### 2.1 OTA Güncellemeler Repo'su
1. GitHub'da yeni repository oluşturun: `yourapp-updates`
2. Public yapın (önemli - OTA için)
3. Aşağıdaki dosyaları ekleyin:

**manifest.json:**
```json
{
    "version": "1.0.0",
    "buildNumber": 1,
    "minBuildNumber": 1,
    "releaseDate": "2025-01-01",
    "changelog": [
        "İlk sürüm"
    ],
    "required": false
}
```

**config.json:**
```json
{
    "key": "YOUR_ACTIVATION_KEY",
    "apkUrl": "https://github.com/YOUR_USER/yourapp-updates/releases/download/v1.0.0/app.apk",
    "playStoreUrl": "https://play.google.com/store/apps/details?id=com.yourapp",
    "announcement": "",
    "maintenanceMode": false
}
```

**app.html:** (capacitor-app/www/app.html kopyası)

### 2.2 Personal Access Token Oluşturma
1. GitHub → Settings → Developer settings → Personal access tokens
2. "Generate new token (classic)" tıklayın
3. Not ekleyin: "YourApp OTA Updates"
4. Süre: "No expiration" (veya istediğiniz süre)
5. İzinler: `repo` (tüm repo izinleri)
6. Token'ı kopyalayın ve saklayın

---

## ☁️ Adım 3: Vercel Push Server Kurulumu

### 3.1 Vercel Hesabı
1. https://vercel.com adresinden hesap oluşturun
2. GitHub hesabınızla bağlayın

### 3.2 Push Server Deploy
1. `push-server` klasörünü yeni bir GitHub repo'suna yükleyin
2. Vercel'de "New Project" tıklayın
3. GitHub repo'sunu seçin
4. Framework: "Other"
5. Deploy edin

### 3.3 Environment Variables Ayarlama
Vercel proje ayarlarından şunları ekleyin:

| Değişken | Değer |
|----------|-------|
| `FIREBASE_SERVICE_ACCOUNT` | Service account JSON (tek satır) |
| `API_KEY` | Güçlü bir API key (kendiniz oluşturun) |

**Service Account JSON'u tek satıra çevirme:**
```bash
cat service-account.json | tr -d '\n'
```

---

## 📱 Adım 4: Android Projesi Yapılandırma

### 4.1 Dosyaları Kopyalama
```bash
# Ana klasöre gidin
cd capacitor-app

# Bağımlılıkları yükleyin
npm install

# Android projesini sync edin
npx cap sync android
```

### 4.2 google-services.json Yerleştirme
Firebase'den indirdiğiniz `google-services.json` dosyasını şuraya kopyalayın:
```
capacitor-app/android/app/google-services.json
```

### 4.3 Paket Adını Değiştirme (İsteğe bağlı)
1. `capacitor.config.json` → `appId` değiştirin
2. `android/app/build.gradle` → `applicationId` değiştirin
3. `android/app/build.gradle` → `namespace` değiştirin

### 4.4 Keystore Oluşturma (APK İmzalama)
```bash
keytool -genkey -v -keystore release.keystore -alias myapp -keyalg RSA -keysize 2048 -validity 10000
```

Oluşturulan dosyayı şuraya kopyalayın:
```
capacitor-app/android/keystore/release.keystore
```

`android/app/build.gradle` dosyasında:
```gradle
signingConfigs {
    release {
        storeFile file('../keystore/release.keystore')
        storePassword 'YOUR_PASSWORD'
        keyAlias 'myapp'
        keyPassword 'YOUR_PASSWORD'
    }
}
```

---

## ⚙️ Adım 5: Uygulama Yapılandırması

### 5.1 Firebase Config (app.html)
`capacitor-app/www/app.html` dosyasında (~25. satır):

```javascript
const firebaseConfig = {
    apiKey: "YOUR_API_KEY",
    authDomain: "YOUR_PROJECT.firebaseapp.com",
    projectId: "YOUR_PROJECT_ID",
    storageBucket: "YOUR_PROJECT.firebasestorage.app",
    messagingSenderId: "YOUR_SENDER_ID",
    appId: "YOUR_APP_ID"
};
```

### 5.2 GitHub Token ve Repo Ayarları
Aynı dosyada (~3200. satır civarı):

```javascript
const GITHUB_TOKEN = 'ghp_YOUR_TOKEN_HERE';
const GITHUB_REPO = 'YOUR_USERNAME/yourapp-updates';
```

### 5.3 Push Server URL
Aynı dosyada push notification fonksiyonlarında:

```javascript
const PUSH_SERVER_URL = 'https://your-push-server.vercel.app/api/send-notification';
const PUSH_API_KEY = 'YOUR_API_KEY';
```

### 5.4 Admin E-posta
```javascript
const OWNER_EMAIL = 'admin@yourdomain.com';
```

---

## 🔨 Adım 6: APK Derleme

### 6.1 Web Dosyalarını Sync Et
```bash
cd capacitor-app
npx cap sync android
```

### 6.2 Debug APK Derleme
```bash
cd android
./gradlew assembleDebug
```

APK konumu: `android/app/build/outputs/apk/debug/app-debug.apk`

### 6.3 Release APK Derleme
```bash
./gradlew assembleRelease
```

APK konumu: `android/app/build/outputs/apk/release/app-release.apk`

---

## ✅ Adım 7: Test Etme

### Kontrol Listesi
- [ ] Firebase Auth çalışıyor (kayıt/giriş)
- [ ] Firestore verileri yükleniyor
- [ ] GitHub'dan config.json çekiliyor
- [ ] OTA güncelleme kontrolü çalışıyor
- [ ] Push bildirimler alınıyor
- [ ] Admin paneli erişilebilir

---

## 🆘 Sorun Giderme

### Firebase Bağlantı Hatası
- `google-services.json` doğru konumda mı?
- Firebase config değerleri doğru mu?
- Internet izni AndroidManifest'te var mı?

### Push Bildirim Çalışmıyor
- FCM token kaydediliyor mu?
- Vercel env variables doğru mu?
- Service account yetkili mi?

### OTA Güncelleme Çalışmıyor
- GitHub repo public mı?
- Token yetkisi var mı?
- manifest.json formatı doğru mu?

---

## 📞 Destek

Kurulum sırasında sorun yaşarsanız dokümantasyonu kontrol edin veya destek için iletişime geçin.
