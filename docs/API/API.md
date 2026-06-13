# EcoTrack Backend API Documentation

## Overview
EcoTrack Backend saat ini menyediakan API untuk:
- autentikasi token berbasis Laravel Sanctum
- profil pengguna
- pencatatan dan riwayat transportasi
- pencatatan dan riwayat penggunaan listrik

> Catatan: Jalur publik untuk registrasi dan login belum terdaftar dalam `routes/api.php` saat ini. Hanya endpoint yang dilindungi `auth:sanctum` yang tersedia.

## Base URL
Gunakan base URL backend:
- `http://127.0.0.1:8000`

Semua endpoint API terletak di bawah prefix:
- `/api`

## Autentikasi
Backend menggunakan `Laravel Sanctum` untuk autentikasi token.

Header yang wajib dikirim untuk endpoint dilindungi:
```http
Authorization: Bearer <access_token>
Accept: application/json
Content-Type: application/json
```

### CSRF / Sanctum
Backend juga mendaftarkan route `GET /sanctum/csrf-cookie` untuk kebutuhan Sanctum SPAs, tetapi untuk Flutter mobile app cukup gunakan token bearer.

## Endpoint Terdaftar

### 1. GET /api/user
- Deskripsi: Mengambil data user saat ini berdasarkan token autentikasi.
- Middleware: `auth:sanctum`
- Response contoh:
```json
{
  "id": 1,
  "name": "John Doe",
  "email": "johndoe@example.com",
  "email_verified_at": null,
  "created_at": "2026-06-11T...",
  "updated_at": "2026-06-11T..."
}
```

### 2. GET /api/user/profile
- Deskripsi: Mengambil profil pengguna.
- Middleware: `auth:sanctum`
- Response contoh:
```json
{
  "status": "success",
  "user": {
    "id": 1,
    "name": "John Doe",
    "email": "johndoe@example.com"
  }
}
```

### 3. POST /api/logout
- Deskripsi: Mencabut token akses saat ini.
- Middleware: `auth:sanctum`
- Body: kosong
- Response contoh:
```json
{
  "message": "Berhasil logout, token akses telah dicabut."
}
```

### 4. GET /api/transport-logs
- Deskripsi: Mengambil riwayat log transportasi user.
- Middleware: `auth:sanctum`
- Response contoh:
```json
{
  "status": "success",
  "data": [
    {
      "id": 1,
      "user_id": 1,
      "transport_type_id": 1,
      "distance": 12.5,
      "calculated_emission": 3.75,
      "activity_date": "2026-06-11",
      "created_at": "2026-06-11T...",
      "updated_at": "2026-06-11T...",
      "transport_type": {
        "id": 1,
        "name": "Mobil Bensin",
        "emission_factor": 0.3
      }
    }
  ]
}
```

### 5. POST /api/transport-logs
- Deskripsi: Menyimpan log transportasi baru dan menghitung emisi otomatis.
- Middleware: `auth:sanctum`
- Body:
```json
{
  "transport_type_id": 1,
  "distance": 12.5,
  "activity_date": "2026-06-11"
}
```
- Response contoh:
```json
{
  "message": "Aktivitas transportasi berhasil dicatat!",
  "data": {
    "id": 2,
    "user_id": 1,
    "transport_type_id": 1,
    "distance": 12.5,
    "calculated_emission": 3.75,
    "activity_date": "2026-06-11",
    "transport_type": {
      "id": 1,
      "name": "Mobil Bensin",
      "emission_factor": 0.3
    }
  }
}
```

### 6. GET /api/electricity-logs
- Deskripsi: Mengambil riwayat penggunaan listrik user.
- Middleware: `auth:sanctum`
- Response contoh:
```json
{
  "status": "success",
  "data": [
    {
      "id": 1,
      "user_id": 1,
      "kwh": 150.0,
      "period": "Juni 2026",
      "calculated_emission": 130.5,
      "logging_date": "2026-06-11",
      "created_at": "2026-06-11T...",
      "updated_at": "2026-06-11T..."
    }
  ]
}
```

### 7. POST /api/electricity-logs
- Deskripsi: Menyimpan log listrik baru dan menghitung emisi otomatis.
- Middleware: `auth:sanctum`
- Body:
```json
{
  "kwh": 150.00,
  "period": "Juni 2026",
  "logging_date": "2026-06-11"
}
```
- Response contoh:
```json
{
  "message": "Penggunaan listrik berhasil dicatat!",
  "data": {
    "id": 3,
    "user_id": 1,
    "kwh": 150.0,
    "period": "Juni 2026",
    "calculated_emission": 130.5,
    "logging_date": "2026-06-11",
    "created_at": "2026-06-11T...",
    "updated_at": "2026-06-11T..."
  }
}
```

## Catatan Penting untuk Flutter
- Backend tidak menyediakan route publik untuk `/api/register` dan `/api/login` saat ini.
- Untuk menggunakan API saat ini, Anda perlu menambahkan endpoint login/register atau mengeluarkan token dari backend yang sudah ada.
- Semua endpoint data penggunanya dilindungi oleh `auth:sanctum`.
- Pastikan request header mencakup `Authorization: Bearer <token>`.

## Struktur Layanan Backend
- `App\Http\Controllers\Auth\AuthController`
  - `profile()`
  - `logout()`
- `App\Http\Controllers\TransportLogController`
  - `index()`
  - `store()`
- `App\Http\Controllers\ElectricityLogController`
  - `index()`
  - `store()`
- `App\Services\Auth\AuthService`
  - `register()`
  - `login()`
  - `logout()`
- `App\Services\TransportService`
  - `getUserLogs()`
  - `createLog()`
- `App\Services\ElectricityService`
  - `getUserLogs()`
  - `createLog()`

## Routes tambahan sistem
- `GET /sanctum/csrf-cookie`
- `GET /storage/{path}`
- `GET /up`
