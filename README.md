# EcoTrack Flutter

EcoTrack Flutter adalah client aplikasi mobile untuk sistem pemantauan jejak karbon pribadi berbasis Flutter. Aplikasi ini terhubung ke backend Laravel untuk autentikasi, pencatatan aktivitas transportasi, pencatatan penggunaan listrik, serta menampilkan dashboard analisis emisi karbon pengguna.

## Gambaran Umum

EcoTrack hadir untuk membantu pengguna:
- mencatat aktivitas transportasi harian
- mencatat konsumsi listrik rumah tangga
- menghitung emisi karbon secara otomatis
- memantau progres pengurangan jejak karbon melalui dashboard interaktif
- menganalisis kontribusi emisi bulanan dan rekomendasi ramah lingkungan

Aplikasi ini dikembangkan sebagai bagian frontend dari ekosistem EcoTrack yang mendukung tujuan SDG 13: Climate Action, dengan antarmuka yang dioptimalkan khusus untuk perangkat seluler (*mobile-first*).

---

## Fitur Utama & Redesain UI

Aplikasi ini telah direkonstruksi penuh menggunakan desain **mobile-first** premium dengan fitur sebagai berikut:

- **Autentikasi Pengguna**: Login & Register terintegrasi langsung dengan API Laravel Sanctum menggunakan struktur kolom tunggal yang ramah seluler.
- **Navigasi Shell Terpadu**: Mengimplementasikan Bottom Navigation Bar dengan 5 tab utama (Home/Dashboard, Transportasi, Listrik, Rekomendasi, Profil) menggunakan `IndexedStack` untuk mempertahankan state halaman.
- **Profil Dinamis (Real-time Profile)**: Data profil (nama & email) diambil langsung dari endpoint backend `/user/profile` sehingga terbebas dari data dummy statis dan menampilkan sapaan personalisasi di Dashboard secara dinamis.
- **Log Transportasi & Listrik Terpadu**: Formulir masukan log (collapsible) serta daftar riwayat log ditampilkan dalam satu halaman terpadu. Pengguna dapat menambah, mengubah, dan menghapus log secara real-time.
- **Dashboard Emisi Interaktif**:
  - Kartu total emisi bulanan terintegrasi dengan persentase tren emisi.
  - Grafik Batang Emisi (`fl_chart`) interaktif dengan pilihan **Mingguan** (per hari pada minggu berjalan) dan **Bulanan** (per bulan untuk 6 bulan terakhir).
- **Analisis Emisi Detail**:
  - Grafik Donat kontribusi emisi (Transportasi vs Listrik).
  - Penghitungan otomatis untuk **Aktivitas Emisi Tertinggi** dan **Rata-rata Harian** secara dinamis dari log riwayat pengguna.
- **Rekomendasi Aksi Iklim**: Daftar aksi nyata yang dikelompokkan dalam tab "Untuk Anda" lengkap dengan ikon kategori ilustratif.

---

## Tech Stack

- **Flutter SDK** & **Dart**
- **Provider** (State management)
- **Dio** (HTTP Client untuk API requests)
- **flutter_secure_storage** (Penyimpanan token akses aman)
- **fl_chart** (Rendering grafik bar & donut secara dinamis)
- **responsive_framework** (Adaptabilitas tata letak antarmuka)
- **intl** (Formatting tanggal dan angka)

---

## Struktur Proyek

Berikut adalah struktur folder terbaru setelah penyatuan modul input/riwayat dan penghapusan berkas usang:

```plaintext
lib/
├── app.dart
├── main.dart
├── core/
│   └── api/
│       └── api_client.dart
└── features/
    ├── main_view.dart                 # Shell utama dengan Bottom Navigation
    ├── auth/
    │   ├── providers/
    │   │   └── auth_provider.dart
    │   └── views/
    │       ├── login_view.dart
    │       └── register_view.dart
    ├── dashboard/
    │   └── views/
    │       └── dashboard_view.dart    # Dashboard dengan fl_chart bar emisi
    ├── electricity/
    │   ├── models/
    │   │   └── electricity_log.dart
    │   ├── providers/
    │   │   └── electricity_provider.dart
    │   └── views/
    │       └── electricity_view.dart  # Form input & log riwayat listrik terpadu
    ├── transport/
    │   ├── models/
    │   │   ├── transport_log.dart
    │   │   └── transport_type.dart
    │   ├── providers/
    │   │   └── transport_provider.dart
    │   └── views/
    │       └── transport_view.dart    # Form input & log riwayat transportasi terpadu
    ├── analysis/
    │   └── views/
    │       └── analysis_view.dart     # Analisis detail & grafik donat emisi
    ├── recommendation/
    │   └── views/
    │       └── recommendation_view.dart # Daftar saran aksi ramah lingkungan
    └── profile/
        └── views/
            └── profile_view.dart      # Informasi profil riil & menu log out
```

---

## Integrasi Backend

Frontend ini dirancang untuk berkomunikasi dengan backend Laravel melalui base URL:
- Android emulator: http://10.0.2.2:8000/api
- Device fisik / browser lokal: http://127.0.0.1:8000/api

Token akses disimpan aman menggunakan `flutter_secure_storage` dan otomatis ditambahkan ke header `Authorization` saat request dikirim.

---

## Prasyarat

Pastikan perangkat Anda sudah memiliki:
- Flutter SDK (versi terbaru yang mendukung `withValues` pada class `Color`)
- Android Studio / VS Code dengan Flutter extension
- Backend EcoTrack Laravel berjalan di lokal (port 8000)

---

## Cara Menjalankan Aplikasi

1. Install dependency Flutter:
   ```bash
   flutter pub get
   ```

2. Jalankan aplikasi:
   ```bash
   flutter run
   ```

Untuk mode emulator Android, pastikan backend Laravel berjalan pada port 8000 dan menggunakan host `10.0.2.2` pada konfigurasi API.

---

## Dokumentasi Pendukung

Dokumen desain dan arsitektur proyek tersedia di folder `docs` dan direktori brain:
- [walkthrough.md](file:///C:/Users/ACER/.gemini/antigravity-ide/brain/fd686eda-9730-496f-9d50-90c520db069a/walkthrough.md) — Panduan perubahan redesign terbaru & detail fungsionalitas
- docs/MVP.md — blueprint arsitektur MVP Flutter + Laravel
- docs/UI_UX.md — panduan desain UI/UX EcoTrack
- docs/API/API.md — dokumentasi endpoint backend yang digunakan oleh frontend

---

## 🚀 Deployment & Maintenance

### Backend Laravel
- Backend EcoTrack berjalan menggunakan Laravel 11.x dengan Sanctum untuk autentikasi.
- Untuk deploy produksi, pastikan:
  - `APP_ENV=production`
  - `APP_DEBUG=false`
  - SSL aktif
  - database dan storage permission benar

### Frontend Flutter
- Aplikasi Flutter dapat dijalankan langsung dengan `flutter run` untuk development.
- Untuk distribusi production:
  - `flutter build apk --release`
  - `flutter build appbundle --release`

### Maintenance Rutin
- Cek log API dan error dari backend.
- Jalankan backup database secara berkala.
- Update dependency backend/frontend saat ada patch keamanan.
- Validasi ulang setelah setiap update dengan `php artisan test` dan `flutter analyze`.

---

## Tujuan Proyek

EcoTrack Flutter bertujuan menjadi antarmuka yang intuitif bagi pengguna untuk memantau jejak karbon pribadi, sekaligus menjadi fondasi pengembangan aplikasi yang lebih lengkap di masa mendatang. Pengguna dapat mengetahui secara nyata kontribusi jejak karbon harian mereka untuk mengambil aksi mitigasi perubahan iklim secara mandiri.
