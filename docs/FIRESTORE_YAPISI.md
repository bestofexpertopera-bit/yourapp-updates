# 🗄️ Firestore Veritabanı Yapısı

Bu dokümanda Firestore veritabanı şeması ve koleksiyonlar detaylı olarak açıklanmaktadır.

---

## 📊 Koleksiyon Şeması

```
Firestore Database
├── users/                    # Kullanıcılar
├── games/                    # Oyunlar
├── orders/                   # Siparişler
├── chats/                    # Sohbetler
│   └── {chatId}/messages/   # Mesajlar (subcollection)
├── notifications/            # Bildirimler
├── settings/                 # Ayarlar
└── setupModals/             # Kurulum modalları
```

---

## 👥 users Collection

Tüm kullanıcı verilerini içerir.

### Doküman Yapısı
```javascript
users/{userId} = {
    // Temel bilgiler
    email: string,              // "user@example.com"
    username: string,           // "username123"
    createdAt: Timestamp,       // Kayıt tarihi
    
    // Profil
    profilePhoto: string | null, // Profil fotoğrafı URL
    
    // Yetki
    isAdmin: boolean,           // Admin mi? (default: false)
    adminLevel: number,         // 0-3 arası yetki seviyesi
    
    // Push bildirimleri
    fcmToken: string | null,    // Firebase Cloud Messaging token
    
    // Key sistemi
    keyActivated: boolean,      // Key aktif mi?
    keyCode: string | null,     // Kullanılan key kodu
    keyActivatedAt: Timestamp,  // Key aktivasyon tarihi
    
    // Güvenlik
    lastPasswordChange: Timestamp, // Son şifre değişikliği
    lastLogin: Timestamp,          // Son giriş
    
    // Tercihler
    notificationsEnabled: boolean  // Bildirim tercihi
}
```

### İndeksler
```
- email (ascending)
- isAdmin (ascending)
- createdAt (descending)
```

### Örnek Doküman
```json
{
    "email": "onurtenk0@gmail.com",
    "username": "onurtenk0",
    "createdAt": "2025-01-01T00:00:00Z",
    "profilePhoto": null,
    "isAdmin": true,
    "adminLevel": 3,
    "fcmToken": "fLm...abc123",
    "keyActivated": true,
    "keyCode": "THEBEST2024",
    "keyActivatedAt": "2025-01-01T00:00:00Z",
    "lastPasswordChange": "2025-12-24T10:00:00Z",
    "lastLogin": "2025-12-24T12:00:00Z",
    "notificationsEnabled": true
}
```

---

## 🎮 games Collection

Mağazadaki oyunları içerir.

### Doküman Yapısı
```javascript
games/{gameId} = {
    // Temel bilgiler
    title: string,              // "GTA V"
    description: string,        // Uzun açıklama
    shortDescription: string,   // Kısa açıklama
    
    // Fiyat
    price: number,              // 149.99
    originalPrice: number,      // İndirimli ise orijinal fiyat
    discount: number,           // İndirim yüzdesi (0-100)
    
    // Kategori
    category: string,           // "action", "sports", "racing"
    tags: string[],             // ["multiplayer", "open-world"]
    
    // Görseller
    imageUrl: string,           // Ana görsel
    screenshots: string[],      // Ekran görüntüleri
    videoUrl: string | null,    // Tanıtım videosu
    
    // Özellikler
    features: string[],         // Özellik listesi
    requirements: {             // Sistem gereksinimleri
        minimum: string,
        recommended: string
    },
    
    // Durum
    isActive: boolean,          // Aktif mi?
    isFeatured: boolean,        // Öne çıkan mı?
    order: number,              // Sıralama (1, 2, 3...)
    
    // Meta
    createdAt: Timestamp,
    updatedAt: Timestamp,
    createdBy: string           // Admin userId
}
```

### İndeksler
```
- isActive (ascending) + order (ascending)
- category (ascending) + isActive (ascending)
- isFeatured (ascending) + order (ascending)
```

### Örnek Doküman
```json
{
    "title": "GTA V Premium",
    "description": "Los Santos ve Blaine County'nin geniş açık dünyasını keşfedin...",
    "shortDescription": "Açık dünya aksiyon oyunu",
    "price": 149.99,
    "originalPrice": 299.99,
    "discount": 50,
    "category": "action",
    "tags": ["open-world", "multiplayer", "action"],
    "imageUrl": "https://example.com/gtav.jpg",
    "screenshots": [
        "https://example.com/ss1.jpg",
        "https://example.com/ss2.jpg"
    ],
    "videoUrl": "https://youtube.com/watch?v=xxx",
    "features": [
        "Online multiplayer",
        "Geniş açık dünya",
        "300+ araç"
    ],
    "requirements": {
        "minimum": "Android 7.0+",
        "recommended": "Android 10+"
    },
    "isActive": true,
    "isFeatured": true,
    "order": 1,
    "createdAt": "2025-01-01T00:00:00Z",
    "updatedAt": "2025-12-24T00:00:00Z",
    "createdBy": "adminUserId"
}
```

---

## 📦 orders Collection

Kullanıcı siparişlerini içerir.

### Doküman Yapısı
```javascript
orders/{orderId} = {
    // Kullanıcı bilgileri
    userId: string,
    userEmail: string,
    
    // Oyun bilgileri
    gameId: string,
    gameTitle: string,
    gamePrice: number,
    
    // Sipariş durumu
    status: string,             // "pending", "approved", "rejected", "completed"
    
    // Notlar
    notes: string | null,       // Kullanıcı notu
    adminNotes: string | null,  // Admin notu
    rejectReason: string | null, // Red sebebi
    
    // Zaman bilgileri
    createdAt: Timestamp,
    processedAt: Timestamp | null,
    completedAt: Timestamp | null,
    
    // İşlem yapan admin
    processedBy: string | null,  // Admin email
    
    // Key bilgisi (onaylandığında)
    deliveredKey: string | null  // Teslim edilen key
}
```

### Sipariş Durumları
| Durum | Açıklama |
|-------|----------|
| `pending` | Onay bekliyor |
| `approved` | Onaylandı, key teslim edilecek |
| `rejected` | Reddedildi |
| `completed` | Tamamlandı, key teslim edildi |

### İndeksler
```
- userId (ascending) + createdAt (descending)
- status (ascending) + createdAt (descending)
```

---

## 💬 chats Collection

Kullanıcı-admin sohbetlerini içerir.

### Doküman Yapısı
```javascript
chats/{chatId} = {
    participants: string[],      // [userId, adminId]
    lastMessage: string,         // Son mesaj önizleme
    lastMessageAt: Timestamp,
    lastMessageBy: string,       // Son mesajı gönderen
    unreadCount: {
        [userId]: number,        // Kullanıcının okumadığı
        [adminId]: number        // Adminin okumadığı
    },
    createdAt: Timestamp,
    status: string              // "open", "closed"
}
```

### messages Subcollection
```javascript
chats/{chatId}/messages/{messageId} = {
    senderId: string,
    senderEmail: string,
    text: string,
    timestamp: Timestamp,
    read: boolean,
    type: string               // "text", "image", "system"
}
```

---

## 🔔 notifications Collection

Kullanıcı bildirimlerini içerir.

### Doküman Yapısı
```javascript
notifications/{notificationId} = {
    userId: string,
    title: string,
    body: string,
    type: string,              // "order", "system", "promo", "chat"
    read: boolean,
    createdAt: Timestamp,
    data: {                    // Ek veri
        orderId: string,
        gameId: string,
        link: string
    }
}
```

---

## ⚙️ settings Collection

Uygulama ayarlarını içerir.

### appConfig Dokümanı
```javascript
settings/appConfig = {
    // Popup ayarları
    popupEnabled: boolean,
    popupTitle: string,
    popupDescription: string,
    popupImage: string | null,
    popupButton: string,
    popupLink: string | null,
    
    // Duyuru
    announcement: string,
    
    // Bakım modu
    maintenanceMode: boolean,
    maintenanceMessage: string,
    
    // Son güncelleme
    updatedAt: Timestamp,
    updatedBy: string
}
```

### Örnek appConfig
```json
{
    "popupEnabled": false,
    "popupTitle": "🎉 Hoş Geldiniz!",
    "popupDescription": "Yeni kampanyamızı kaçırmayın!",
    "popupImage": "https://example.com/popup.jpg",
    "popupButton": "İncele",
    "popupLink": "https://example.com/promo",
    "announcement": "",
    "maintenanceMode": false,
    "maintenanceMessage": "Sistem bakımda, lütfen daha sonra tekrar deneyin.",
    "updatedAt": "2025-12-24T00:00:00Z",
    "updatedBy": "admin@example.com"
}
```

---

## 📋 setupModals Collection

Oyun kurulum modallarını içerir.

### Doküman Yapısı
```javascript
setupModals/{modalId} = {
    gameId: string | null,       // Bağlı oyun (null = genel)
    title: string,
    steps: [
        {
            title: string,
            description: string,
            image: string | null
        }
    ],
    isActive: boolean,
    order: number,
    createdAt: Timestamp
}
```

---

## 🔒 Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Helper: Admin kontrolü
    function isAdmin() {
      return request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin == true;
    }
    
    // Helper: Doküman sahibi mi?
    function isOwner(userId) {
      return request.auth != null && request.auth.uid == userId;
    }
    
    // Users
    match /users/{userId} {
      allow read: if isOwner(userId) || isAdmin();
      allow create: if isOwner(userId);
      allow update: if isOwner(userId) || isAdmin();
      allow delete: if isAdmin();
    }
    
    // Games
    match /games/{gameId} {
      allow read: if true;
      allow write: if isAdmin();
    }
    
    // Orders
    match /orders/{orderId} {
      allow read: if isOwner(resource.data.userId) || isAdmin();
      allow create: if request.auth != null;
      allow update: if isAdmin();
      allow delete: if isAdmin();
    }
    
    // Chats
    match /chats/{chatId} {
      allow read, write: if request.auth != null && 
        request.auth.uid in resource.data.participants;
      
      match /messages/{messageId} {
        allow read, write: if request.auth != null;
      }
    }
    
    // Notifications
    match /notifications/{notificationId} {
      allow read: if isOwner(resource.data.userId);
      allow write: if isAdmin();
    }
    
    // Settings
    match /settings/{docId} {
      allow read: if true;
      allow write: if isAdmin();
    }
    
    // Setup Modals
    match /setupModals/{modalId} {
      allow read: if true;
      allow write: if isAdmin();
    }
  }
}
```

---

## 📈 İndeks Gereksinimleri

Firebase Console'da oluşturulması gereken composite indeksler:

| Collection | Fields | Query Type |
|------------|--------|------------|
| games | isActive (asc), order (asc) | Collection |
| games | category (asc), isActive (asc), order (asc) | Collection |
| orders | userId (asc), createdAt (desc) | Collection |
| orders | status (asc), createdAt (desc) | Collection |
| notifications | userId (asc), createdAt (desc) | Collection |
| chats | participants (array-contains), lastMessageAt (desc) | Collection |
