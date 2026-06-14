# Daftar Fitur Sistem EcoTrack – Personal Carbon Footprint Monitoring System

## 1. Modul Manajemen Pengguna

### 1.1 Registrasi Akun
Fitur yang memungkinkan pengguna membuat akun baru dengan mengisi:
- Nama lengkap
- Email
- Password

### 1.2 Login dan Logout
Fitur autentikasi pengguna untuk masuk dan keluar dari sistem.

### 1.3 Profil Pengguna
Fitur untuk:
- Melihat data profil
- Mengubah nama pengguna
- Mengubah email
- Mengubah password

---

## 2. Modul Pencatatan Aktivitas Transportasi

### 2.1 Input Aktivitas Transportasi
Pengguna dapat mencatat aktivitas transportasi dengan data:
- Jenis kendaraan
- Jarak tempuh (km)
- Tanggal aktivitas

### 2.2 Perhitungan Emisi Transportasi Otomatis
Sistem secara otomatis menghitung emisi CO₂ berdasarkan:
- Jenis kendaraan
- Faktor emisi kendaraan
- Jarak tempuh

### 2.3 Riwayat Aktivitas Transportasi
Fitur untuk:
- Melihat daftar aktivitas transportasi
- Mengedit data aktivitas
- Menghapus data aktivitas

---

## 3. Modul Pencatatan Penggunaan Listrik

### 3.1 Input Penggunaan Listrik
Pengguna dapat memasukkan:
- Jumlah penggunaan listrik (kWh)
- Periode penggunaan
- Tanggal pencatatan

### 3.2 Perhitungan Emisi Listrik Otomatis
Sistem menghitung estimasi emisi karbon berdasarkan konsumsi listrik yang diinput.

### 3.3 Riwayat Penggunaan Listrik
Fitur untuk:
- Melihat data penggunaan listrik
- Mengedit data
- Menghapus data

---

## 4. Modul Dashboard Monitoring

### 4.1 Total Emisi Karbon
Menampilkan total emisi karbon pengguna yang berasal dari:
- Aktivitas transportasi
- Penggunaan listrik

### 4.2 Grafik Emisi
Menampilkan grafik:
- Emisi per hari
- Emisi per minggu
- Emisi per bulan

### 4.3 Analisis Sumber Emisi
Menampilkan:
- Aktivitas dengan emisi terbesar
- Persentase kontribusi tiap kategori emisi

### 4.4 Ringkasan Statistik
Menampilkan:
- Total perjalanan
- Total penggunaan listrik
- Total emisi karbon

---

## 5. Modul Rekomendasi Pengurangan Emisi

### 5.1 Rekomendasi Otomatis
Sistem memberikan rekomendasi berdasarkan pola aktivitas pengguna.

**Contoh:**
- Menggunakan transportasi umum
- Berjalan kaki atau bersepeda
- Mengurangi penggunaan perangkat listrik
- Menggunakan lampu hemat energi

### 5.2 Riwayat Rekomendasi
Pengguna dapat melihat daftar rekomendasi yang pernah diberikan sistem.

---

## 6. Modul Administrasi (Opsional)

### 6.1 Manajemen Jenis Transportasi
Admin dapat:
- Menambah jenis kendaraan
- Mengubah faktor emisi kendaraan
- Menghapus jenis kendaraan

### 6.2 Monitoring Data Pengguna
Admin dapat melihat:
- Jumlah pengguna
- Total aktivitas yang tercatat
- Statistik emisi keseluruhan sistem

---

## Kebutuhan Database

1. `Users`
2. `Transport_Types`
3. `Transport_Logs`
4. `Electricity_Logs`
5. `Recommendations`
6. `User_Recommendations`

**Relasi:**
- `Users` → `Transport_Logs` (1:N)
- `Users` → `Electricity_Logs` (1:N)
- `Transport_Types` → `Transport_Logs` (1:N)
- `Recommendations` → `User_Recommendations` (1:N)
- `Users` → `User_Recommendations` (1:N)

---

## Fitur MVP yang Wajib Dibuat

1. Registrasi dan Login
2. Kelola Profil
3. Input Aktivitas Transportasi
4. Input Penggunaan Listrik
5. Perhitungan Emisi Otomatis
6. Dashboard Total Emisi
7. Grafik Emisi
8. Riwayat Aktivitas
9. Rekomendasi Pengurangan Emisi
10. CRUD Data Transportasi dan Listrik

Fitur-fitur tersebut sudah cukup untuk memenuhi kebutuhan Minimum Viable Product (MVP) serta mendukung tujuan SDG 13 (Climate Action).

---

## Roadmap Pengembangan EcoTrack

### Tahap 1: Fondasi Backend (Laravel API)

**Setup Laravel Project**
- [x] Install Laravel
- [x] Konfigurasi `.env`

**Database Design (Migrations)**
- [x] Buat tabel `users`
- [x] Buat tabel `transport_types`
- [x] Buat tabel `transport_logs`
- [x] Buat tabel `electricity_logs`
- [x] Buat tabel `recommendations`
- [x] Buat tabel `user_recommendations`

**Authentication (Sanctum)**
- [x] Setup Laravel Sanctum untuk API Token (Mobile)
- [x] Setup Laravel Sanctum untuk Session (Web)

**Models & Relationships**
- [x] Definisikan relasi HasMany/BelongsTo di setiap model

**Service Layer**
- [x] Buat `EmissionCalculatorService`

**Controllers & API Routes**
- [x] Buat CRUD untuk setiap modul
- [x] Pastikan output berupa JSON yang konsisten (gunakan API Resources)

**Testing**
- [ ] Pastikan semua endpoint bisa di-hit via Postman

---

### Tahap 2: Fondasi Frontend (Flutter)

**Setup Project**
- [x] Tambahkan dependensi `dio` (networking)
- [x] Tambahkan dependensi `flutter_dotenv` (config)
- [x] Tambahkan dependensi `provider/bloc` (state management)
- [x] Tambahkan dependensi `responsive_framework` (UI responsif)

**Auth System**
- [x] Buat halaman Login
- [x] Buat halaman Registrasi
- [x] Simpan token ke `shared_preferences`

**API Client**
- [x] Buat class `ApiClient` (Dio)
- [x] Sisipkan token otomatis di setiap request

**UI Layouting**
- [x] Buat kerangka utama menggunakan `ResponsiveBreakpoints`
- [x] Sesuaikan tampilan Mobile dan Desktop

**Dashboard**
- [x] Implementasikan grafik menggunakan `fl_chart`

---

### Tahap 3: Modul Spesifik (Sesuai List Fitur)

**Modul Transportasi**
- [x] Input form (dropdown jenis kendaraan, jarak)
- [x] Tampilan riwayat (list view)

**Modul Listrik**
- [x] Input form (kWh, periode)

**Modul Rekomendasi**
- [ ] Tarik data rekomendasi dari database
- [ ] Tampilkan sebagai cards

**Dashboard Analytics**
- [x] Hitung total emisi (panggil Service dari backend)
- [x] Visualisasi grafik per hari/minggu/bulan

---

### Tahap 4: Polishing untuk TOP 3 & HAKI

**Error Handling**
- [ ] Pastikan aplikasi memberikan pesan yang ramah pengguna saat koneksi gagal atau input salah

**Documentation (Wajib)**
- [ ] Buat `README.md`
- [ ] Buat diagram ERD
- [ ] Buat diagram arsitektur sistem
- [ ] Export Postman/Insomnia Collection

**Final UI Tweak**
- [ ] Pastikan tidak ada UI yang patah saat dijalankan di Chrome (Desktop Mode)
