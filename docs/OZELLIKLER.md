# 🌟 Uygulama Özellikleri

Bu dokümanda uygulamanın tüm özellikleri detaylı olarak açıklanmaktadır.

---

## 📱 Kullanıcı Özellikleri

### 🔐 Hesap Yönetimi
- **Kayıt Olma** - E-posta ve şifre ile
- **Giriş Yapma** - Firebase Authentication
- **Beni Hatırla** - LocalStorage ile oturum saklama
- **Şifremi Unuttum** - E-posta ile şifre sıfırlama
- **Şifre Değiştirme** - Mevcut şifre doğrulamalı
- **Profil Fotoğrafı** - URL ile profil resmi ekleme
- **Çıkış Yapma** - Güvenli oturum sonlandırma

### 🛒 Mağaza
- **Oyun Listesi** - Kategorilere göre oyunlar
- **Oyun Detayı** - Açıklama, fiyat, özellikler
- **Arama** - Oyun adına göre arama
- **Filtreleme** - Kategoriye göre filtreleme
- **Favoriler** - Oyunları favorilere ekleme

### 📦 Sipariş Sistemi
- **Sipariş Verme** - Oyun satın alma
- **Sipariş Takibi** - Bekleyen/onaylanan siparişler
- **Sipariş Geçmişi** - Tüm siparişler listesi

### 🔑 Key Sistemi
- **Key Girişi** - Aktivasyon key'i girme
- **Key Durumu** - Aktif/pasif kontrolü
- **Key Doğrulama** - Sunucu taraflı doğrulama

### 🔔 Bildirimler
- **Push Bildirimleri** - Firebase Cloud Messaging
- **Uygulama İçi Bildirimler** - Toast mesajları
- **Bildirim Geçmişi** - Tüm bildirimler listesi
- **Bildirimleri Temizle** - Toplu silme

### 💬 Destek
- **Canlı Sohbet** - Admin ile mesajlaşma
- **Destek Talebi** - Sorun bildirme
- **Sohbet Geçmişi** - Önceki mesajlar

### 🔄 Güncelleme
- **OTA Güncelleme** - Uygulama içi güncelleme
- **Versiyon Kontrolü** - Otomatik kontrol
- **Değişiklik Günlüğü** - Yenilikler listesi
- **Zorunlu Güncelleme** - Required flag desteği

---

## 👑 Admin Özellikleri

### 📊 Dashboard
- **İstatistikler** - Kullanıcı/sipariş sayıları
- **Hızlı Erişim** - Sık kullanılan işlemler

### 👥 Kullanıcı Yönetimi
- **Kullanıcı Listesi** - Tüm kullanıcılar
- **Kullanıcı Detayı** - Profil bilgileri
- **Admin Atama** - Yetki verme
- **Admin Seviyesi** - 1-3 arası yetki

### 📦 Sipariş Yönetimi
- **Bekleyen Siparişler** - Onay bekleyenler
- **Sipariş Onaylama** - Manuel onay
- **Sipariş Reddetme** - Red işlemi
- **Sipariş Detayı** - Tüm bilgiler

### 🎮 Oyun Yönetimi
- **Oyun Ekleme** - Yeni oyun girişi
- **Oyun Düzenleme** - Bilgi güncelleme
- **Oyun Silme** - Listeden kaldırma
- **Görsel Yönetimi** - Resim URL'leri

### 💬 Destek Yönetimi
- **Destek Talepleri** - Tüm talepler
- **Mesaj Yanıtlama** - Kullanıcıya cevap
- **Talep Kapatma** - Çözümlendi işareti

### 📢 Popup/Duyuru Sistemi
- **Popup Oluşturma** - Görsel popup
- **Duyuru Gönderme** - Text duyuru
- **Popup Ayarları** - Başlık, açıklama, görsel, link

### 🔧 Bakım Modu
- **Bakım Açma/Kapama** - Toggle switch
- **Bakım Mesajı** - Özel mesaj
- **Uzaktan Kontrol** - Firestore tabanlı

### 💾 Yedekleme
- **Ayarları Yedekle** - JSON export
- **Ayarları Geri Yükle** - JSON import
- **Orijinal Ayarlar** - Varsayılanlara dön
- **Firestore Senkron** - Bulut yedekleme

### 🔔 Bildirim Gönderme
- **Tekil Bildirim** - Belirli kullanıcıya
- **Toplu Bildirim** - Tüm kullanıcılara
- **Topic Bildirim** - Gruplara gönderim

---

## 🔧 Teknik Özellikler

### 🏗️ Mimari
- **Single Page Application** - Tek HTML dosyası
- **Capacitor 8** - Native Android wrapper
- **Firebase Backend** - BaaS çözümü
- **GitHub OTA** - Güncelleme dağıtımı
- **Vercel Serverless** - Push API

### 🔐 Güvenlik
- **Firebase Auth** - Güvenli kimlik doğrulama
- **Re-authentication** - Hassas işlemler için
- **Token Doğrulama** - API güvenliği
- **Key Sistemi** - Ek güvenlik katmanı

### 📱 Platform Desteği
- **Android 7.0+** (API 24)
- **Modern WebView** - Chrome tabanlı

### 🔄 Senkronizasyon
- **Realtime Updates** - Firestore listeners
- **Offline Support** - LocalStorage cache
- **Auto Sync** - Bağlantı gelince senkron

---

## 📂 Sayfa Yapısı

```
┌─────────────────────────────────────┐
│           Header (Logo)             │
├─────────────────────────────────────┤
│                                     │
│          Ana İçerik                 │
│          (Sayfalar)                 │
│                                     │
├─────────────────────────────────────┤
│    Bottom Navigation (4 buton)      │
│  🏠 Ana  🎮 Oyunlar  🛒 Sepet  👤   │
└─────────────────────────────────────┘
```

### Sayfalar
| Sayfa | Açıklama |
|-------|----------|
| `homePage` | Ana sayfa, öne çıkan oyunlar |
| `gamesPage` | Tüm oyunlar listesi |
| `cartPage` | Sipariş/sepet sayfası |
| `loginPage` | Giriş sayfası |
| `registerPage` | Kayıt sayfası |
| `forgotPasswordPage` | Şifre sıfırlama |
| `adminPage` | Admin paneli |
| `orderDetailPage` | Sipariş detayı |
| `gameDetailPage` | Oyun detayı |

---

## 🎨 UI Bileşenleri

### Modaller
- Login Required Modal
- Notifications Modal
- Password Change Modal
- Dynamic Setup Modal
- App Settings Modal
- Popup Modal
- Announcement Modal
- Support Chat Modal

### Toast/Bildirim
- Success Toast (yeşil)
- Error Toast (kırmızı)
- Info Toast (mavi)
- Warning Toast (sarı)
- Push Notification Toast

### Formlar
- Auth Form (giriş/kayıt)
- Order Form (sipariş)
- Search Form (arama)
- Key Input Form
- Support Message Form

---

## 🔌 API Entegrasyonları

### Firebase Services
- **Authentication** - Kullanıcı yönetimi
- **Firestore** - Veritabanı
- **Cloud Messaging** - Push bildirimleri

### GitHub API
- **Raw Content** - config.json, manifest.json
- **Commits API** - Versiyon kontrolü
- **Releases** - APK indirme

### Custom API (Vercel)
- **Push Notification API** - Bildirim gönderme
