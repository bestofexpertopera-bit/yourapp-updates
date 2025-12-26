# 🚀 APK Oluşturma Rehberi

## Seçenek 1: Online APK Builder (En Hızlı - 2 Dakika)

### AppsGeyser (Ücretsiz)
1. https://appsgeyser.com/create/start/ adresine git
2. "Website" seç
3. URL olarak GitHub Pages linkini gir
4. Uygulama adı: "TheBestML Installer"
5. İkon yükle
6. "Create App" tıkla
7. APK indir!

### PWA Builder (Microsoft - Ücretsiz)
1. https://www.pwabuilder.com/ adresine git
2. GitHub Pages URL'ni gir
3. "Package for stores" tıkla
4. "Android" seç
5. APK indir!

---

## Seçenek 2: Lokal Build (Java 11 Gerekli)

### Java 11 Yükle
1. https://adoptium.net/ adresinden Java 11 indir
2. Kur ve PATH'e ekle
3. Terminal'i yeniden aç

### Build Komutu
```bash
cd capacitor-app/android
.\gradlew.bat assembleDebug
```

APK burada: `android/app/build/outputs/apk/debug/app-debug.apk`

---

## Seçenek 3: GitHub Actions (Ücretsiz - Otomatik)

GitHub repo'na bu workflow'u ekle ve her push'ta APK otomatik oluşturulur:

`.github/workflows/build.yml`:
```yaml
name: Build APK
on: [push]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-java@v3
        with:
          java-version: 17
          distribution: temurin
      - name: Build APK
        run: |
          cd android
          chmod +x gradlew
          ./gradlew assembleDebug
      - uses: actions/upload-artifact@v3
        with:
          name: app-debug
          path: android/app/build/outputs/apk/debug/app-debug.apk
```

---

## Dosyalar

GitHub'a yüklenecek dosyalar:
- `www/index.html` - Ana uygulama
- `capacitor.config.json` - Capacitor ayarları
- `android/` - Android projesi (build için)
