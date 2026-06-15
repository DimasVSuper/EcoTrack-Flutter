# EcoTrack Flutter API Integration Notes

## Overview
Dokumen ini menjelaskan endpoint backend yang dipakai oleh aplikasi Flutter EcoTrack saat ini.

Yang digunakan oleh frontend:
- autentikasi token Sanctum (`/login`, `/register`, `/logout`)
- profil pengguna (`/user/profile`)
- transport logs (`/transport-logs` + CRUD)
- electricity logs (`/electricity-logs` + CRUD)
- transport type lookup (`/transport-types`)

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

### 4. GET /api/transport-types
- Deskripsi: Mengambil daftar jenis kendaraan untuk dropdown input transportasi.
- Middleware: publik.
- Response contoh:
```json
{
  "data": [
    {
      "id": 1,
      "name": "Mobil Bensin",
      "emission_factor_per_km": 0.192
    }
  ]
}
```

### 5. GET /api/transport-logs
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

### 6. POST /api/transport-logs
- Deskripsi: Menyimpan log transportasi baru dan menghitung emisi otomatis.
- Middleware: `auth:sanctum`
- Body:
```json
{
  "transport_type_id": 1,
  "distance_km": 12.5,
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

### 7. PUT/PATCH /api/transport-logs/{id}
- Deskripsi: Mengubah log transportasi milik user yang sedang login.
- Middleware: `auth:sanctum`

### 8. DELETE /api/transport-logs/{id}
- Deskripsi: Menghapus log transportasi milik user yang sedang login.
- Middleware: `auth:sanctum`

### 9. GET /api/electricity-logs
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

### 10. POST /api/electricity-logs
- Deskripsi: Menyimpan log listrik baru dan menghitung emisi otomatis.
- Middleware: `auth:sanctum`
- Body:
```json
{
  "usage_kwh": 150.00,
  "period_month": "2026-06",
  "record_date": "2026-06-11"
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

### 11. PUT/PATCH /api/electricity-logs/{id}
- Deskripsi: Mengubah log listrik milik user yang sedang login.
- Middleware: `auth:sanctum`

### 12. DELETE /api/electricity-logs/{id}
- Deskripsi: Menghapus log listrik milik user yang sedang login.
- Middleware: `auth:sanctum`

## Catatan Penting untuk Flutter
- Backend sudah menyediakan endpoint publik `/api/register` dan `/api/login`.
- Token diambil dari response login/register lalu disimpan di `flutter_secure_storage` oleh `AuthProvider`.
- Semua endpoint riwayat data dilindungi oleh `auth:sanctum`.
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
