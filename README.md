# EcoTrack Flutter

EcoTrack Flutter adalah client aplikasi mobile/web untuk sistem pemantauan jejak karbon pribadi berbasis Flutter. Aplikasi ini terhubung ke backend Laravel untuk autentikasi, pencatatan aktivitas transportasi, pencatatan penggunaan listrik, serta menampilkan dashboard emisi karbon pengguna.

## Gambaran Umum

EcoTrack hadir untuk membantu pengguna:
- mencatat aktivitas transportasi harian
- mencatat konsumsi listrik rumah tangga
- menghitung emisi karbon secara otomatis
- memantau progres pengurangan jejak karbon melalui dashboard

Aplikasi ini dikembangkan sebagai bagian frontend dari ekosistem EcoTrack yang mendukung tujuan SDG 13: Climate Action.

---

## Fitur Utama

- Autentikasi pengguna dengan token berbasis Laravel Sanctum
- Login, register, dan logout
- Pencatatan log transportasi
- Pencatatan log listrik
- Dashboard awal dan alur UI MVP
- Integrasi API dengan Dio + secure storage untuk session token
- CRUD riwayat transportasi dan listrik dari UI (edit/hapus)

---

## Tech Stack

- Flutter SDK
- Dart
- Provider (state management)
- Dio (HTTP client)
- flutter_secure_storage (token storage)
- fl_chart & intl (dashboard dan format data)

---

## Struktur Proyek

```plaintext
lib/
├── app.dart
├── main.dart
├── core/
│   └── api/
│       └── api_client.dart
└── features/
    ├── auth/
    │   ├── providers/
    │   │   └── auth_provider.dart
    │   └── views/
    │       ├── login_view.dart
    │       └── register_view.dart
    ├── dashboard/
    │   ├── views/
    │   │   └── dashboard_view.dart
    │   └── widgets/
    │       └── tree_equivalency_card.dart
    ├── electricity/
    │   ├── models/
    │   │   └── electricity_log.dart
    │   ├── providers/
    │   │   └── electricity_provider.dart
    │   └── views/
    │       ├── electricity_history_view.dart
    │       └── electricity_input_view.dart
    └── transport/
        ├── models/
        │   ├── transport_log.dart
        │   └── transport_type.dart
        ├── providers/
        │   └── transport_provider.dart
        └── views/
            ├── transport_history_view.dart
            └── transport_input_view.dart
```

---

## Integrasi Backend

Frontend ini dirancang untuk berkomunikasi dengan backend Laravel melalui base URL:

- Android emulator: http://10.0.2.2:8000/api
- Device fisik / browser lokal: http://127.0.0.1:8000/api

Token akses disimpan aman menggunakan flutter_secure_storage dan otomatis ditambahkan ke header Authorization saat request dikirim.

---

## Prasyarat

Pastikan perangkat Anda sudah memiliki:

- Flutter SDK (versi yang sesuai dengan project)
- Android Studio / VS Code dengan Flutter extension
- Backend EcoTrack Laravel berjalan di lokal

---

## Cara Menjalankan Aplikasi

1. Install dependency Flutter

```bash
flutter pub get
```

2. Jalankan aplikasi

```bash
flutter run
```

Untuk mode emulator Android, pastikan backend Laravel berjalan pada port 8000 dan menggunakan host 10.0.2.2 pada konfigurasi API.

---

## Dokumentasi Pendukung

Dokumen desain dan arsitektur proyek tersedia di folder docs:

- docs/MVP.md — blueprint arsitektur MVP Flutter + Laravel
- docs/UI_UX.md — panduan desain UI/UX EcoTrack
- docs/API/API.md — dokumentasi endpoint backend yang digunakan oleh frontend

---

## Catatan Penting

- Aplikasi ini masih dalam tahap MVP dan fokus pada alur core product.
- Integrasi API bergantung pada backend Laravel yang sudah berjalan.
- Untuk pengujian lokal, pastikan backend dan frontend berjalan pada environment yang saling kompatibel.

---

## Tujuan Proyek

EcoTrack Flutter bertujuan menjadi antarmuka yang intuitif bagi pengguna untuk memantau jejak karbon pribadi, sekaligus menjadi fondasi pengembangan aplikasi yang lebih lengkap di masa mendatang.
