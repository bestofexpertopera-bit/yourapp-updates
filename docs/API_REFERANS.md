# 🌐 API Referansı

Bu dokümanda tüm API endpoint'leri ve kullanımları açıklanmaktadır.

---

## 📲 Push Notification API

### Base URL
```
https://thebestml-push-server.vercel.app/api/send-notification
```

### Authentication
| Header | Değer |
|--------|-------|
| `Content-Type` | `application/json` |
| `x-api-key` | `YOUR_API_KEY` |

---

### POST /api/send-notification

Bildirim gönderir.

#### Tek Kullanıcıya Bildirim
```json
POST /api/send-notification
{
    "token": "fcm_device_token_here",
    "title": "📦 Siparişiniz Onaylandı",
    "body": "GTA V siparişiniz hazırlandı!",
    "data": {
        "type": "order",
        "orderId": "abc123"
    }
}
```

#### Birden Fazla Kullanıcıya
```json
POST /api/send-notification
{
    "tokens": [
        "token1",
        "token2",
        "token3"
    ],
    "title": "🎮 Yeni Oyun Eklendi",
    "body": "Mağazamızda yeni oyunlar!",
    "data": {
        "type": "promo"
    }
}
```

#### Topic'e (Tüm Kullanıcılara)
```json
POST /api/send-notification
{
    "topic": "all_users",
    "title": "📢 Duyuru",
    "body": "Önemli duyuru içeriği",
    "data": {
        "type": "announcement"
    }
}
```

#### Response (Başarılı)
```json
{
    "success": true,
    "message": "Bildirim gönderildi",
    "response": "projects/xxx/messages/yyy"
}
```

#### Response (Hata)
```json
{
    "error": "Hata mesajı"
}
```

#### HTTP Status Kodları
| Kod | Açıklama |
|-----|----------|
| 200 | Başarılı |
| 400 | Geçersiz istek (title/body eksik) |
| 401 | Yetkisiz (API key hatalı) |
| 405 | Method not allowed |
| 500 | Sunucu hatası |

---

## 🐙 GitHub API (OTA Updates)

### Base URL
```
https://api.github.com
https://raw.githubusercontent.com
```

### Authentication
```
Authorization: token ghp_xxxxxxxxxxxxxxxxxxxxx
```

---

### Raw Content Alma

#### manifest.json
```
GET https://raw.githubusercontent.com/{owner}/{repo}/{branch}/manifest.json
Headers:
    Authorization: token {GITHUB_TOKEN}
    Accept: application/vnd.github.v3.raw
```

#### config.json
```
GET https://raw.githubusercontent.com/{owner}/{repo}/{branch}/config.json
```

#### app.html
```
GET https://raw.githubusercontent.com/{owner}/{repo}/{branch}/app.html
```

---

### Commits API

#### Son Commit Bilgisi
```
GET https://api.github.com/repos/{owner}/{repo}/commits/{branch}
Headers:
    Authorization: token {GITHUB_TOKEN}
    Accept: application/vnd.github.v3+json

Response:
{
    "sha": "abc123...",
    "commit": {
        "message": "v3.14.58: Şifre değiştirme",
        "author": {
            "date": "2025-12-24T10:00:00Z"
        }
    }
}
```

---

### File Update API

#### Dosya Güncelleme (manifest.json, config.json, app.html)
```
PUT https://api.github.com/repos/{owner}/{repo}/contents/{path}
Headers:
    Authorization: token {GITHUB_TOKEN}
    Accept: application/vnd.github.v3+json

Body:
{
    "message": "Update {filename}",
    "content": "{base64_encoded_content}",
    "sha": "{current_file_sha}"
}
```

---

## 🔥 Firebase API (Client SDK)

### Authentication

#### Kayıt
```javascript
const userCredential = await firebase.auth()
    .createUserWithEmailAndPassword(email, password);
const user = userCredential.user;
```

#### Giriş
```javascript
const userCredential = await firebase.auth()
    .signInWithEmailAndPassword(email, password);
```

#### Şifre Sıfırlama
```javascript
await firebase.auth().sendPasswordResetEmail(email);
```

#### Şifre Değiştirme
```javascript
const credential = firebase.auth.EmailAuthProvider
    .credential(user.email, currentPassword);
await user.reauthenticateWithCredential(credential);
await user.updatePassword(newPassword);
```

#### Çıkış
```javascript
await firebase.auth().signOut();
```

---

### Firestore

#### Doküman Okuma
```javascript
const doc = await db.collection('users').doc(userId).get();
if (doc.exists) {
    const data = doc.data();
}
```

#### Koleksiyon Okuma
```javascript
const snapshot = await db.collection('games')
    .where('isActive', '==', true)
    .orderBy('order')
    .get();

snapshot.forEach(doc => {
    console.log(doc.id, doc.data());
});
```

#### Doküman Ekleme
```javascript
const docRef = await db.collection('orders').add({
    userId: currentUser.uid,
    gameId: gameId,
    status: 'pending',
    createdAt: firebase.firestore.FieldValue.serverTimestamp()
});
```

#### Doküman Güncelleme
```javascript
await db.collection('users').doc(userId).update({
    fcmToken: token,
    lastLogin: firebase.firestore.FieldValue.serverTimestamp()
});
```

#### Doküman Silme
```javascript
await db.collection('games').doc(gameId).delete();
```

#### Realtime Listener
```javascript
const unsubscribe = db.collection('orders')
    .where('userId', '==', currentUser.uid)
    .onSnapshot(snapshot => {
        snapshot.docChanges().forEach(change => {
            if (change.type === 'added') {
                // Yeni sipariş
            }
        });
    });
```

---

## 📱 Capacitor Native API

### App Plugin
```javascript
import { App } from '@capacitor/app';

// Arka plana geçme
App.addListener('appStateChange', ({ isActive }) => {
    console.log('App active:', isActive);
});

// Geri tuşu
App.addListener('backButton', ({ canGoBack }) => {
    if (!canGoBack) {
        App.exitApp();
    }
});

// Uygulama bilgisi
const info = await App.getInfo();
console.log(info.version, info.build);
```

### Push Notifications
```javascript
import { PushNotifications } from '@capacitor/push-notifications';

// İzin iste
await PushNotifications.requestPermissions();

// Kaydol
await PushNotifications.register();

// Token al
PushNotifications.addListener('registration', (token) => {
    console.log('FCM Token:', token.value);
});

// Bildirim al
PushNotifications.addListener('pushNotificationReceived', (notification) => {
    console.log('Notification:', notification);
});

// Bildirime tıklama
PushNotifications.addListener('pushNotificationActionPerformed', (action) => {
    console.log('Action:', action);
});
```

### Local Notifications
```javascript
import { LocalNotifications } from '@capacitor/local-notifications';

await LocalNotifications.schedule({
    notifications: [{
        id: 1,
        title: 'Hatırlatma',
        body: 'Siparişinizi kontrol edin',
        schedule: { at: new Date(Date.now() + 1000 * 60) }
    }]
});
```

---

## 🔐 Güvenlik Notları

### API Key Güvenliği
- Push API key'i sadece sunucu tarafında kullanın
- GitHub token'ı client'ta kullanılıyor (public repo için)
- Firebase config public olabilir (Security Rules önemli)

### Rate Limiting
- GitHub API: 5000 istek/saat (authenticated)
- Firebase: Quota bazlı
- Push API: Vercel free tier limitleri

### CORS
Push API tüm origin'lere açık (`*`). Production'da kısıtlayın:
```javascript
res.setHeader('Access-Control-Allow-Origin', 'https://yourdomain.com');
```
