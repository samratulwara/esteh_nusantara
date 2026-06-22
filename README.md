# 🍵 Es Teh Nusantara — Aplikasi Mobile Flutter

> UTS Pemrograman Mobile — Aplikasi Jualan Es Teh dengan Flutter

---

## 📱 Tentang Aplikasi

**Es Teh Nusantara** adalah aplikasi mobile pemesanan minuman teh khas Indonesia yang dibangun menggunakan framework Flutter. Aplikasi ini menampilkan berbagai pilihan es teh nusantara dengan tampilan modern bertema **kuning & hijau**.

---

## ✨ Fitur Utama

| Fitur | Keterangan |
|---|---|
| 🎨 Splash Screen | Animasi intro dengan logo dan branding |
| 📋 Katalog Menu | Grid produk dengan 12 varian es teh |
| 🔍 Pencarian | Filter menu secara real-time |
| 🗂️ Kategori | Filter berdasarkan jenis teh |
| 📄 Detail Produk | Pilih ukuran (S/M/L) & tingkat kemanisan |
| 🛒 Keranjang | Tambah, ubah qty, hapus item |
| 💳 Checkout | Form lengkap + pilihan pengiriman & pembayaran |
| ✅ Konfirmasi | Halaman sukses dengan nomor pesanan |

---

## 🏗️ Struktur Proyek

```
lib/
├── main.dart                    # Entry point aplikasi
├── theme.dart                   # Warna & tema aplikasi
├── data/
│   └── products.dart            # Data produk (dummy)
├── models/
│   ├── product.dart             # Model produk
│   ├── cart_item.dart           # Model item keranjang
│   └── cart_provider.dart       # State management keranjang
└── screens/
    ├── splash_screen.dart       # Halaman splash
    ├── home_screen.dart         # Halaman utama / katalog
    ├── product_detail_screen.dart # Detail produk
    ├── cart_screen.dart         # Keranjang belanja
    ├── checkout_screen.dart     # Form checkout
    └── order_success_screen.dart # Konfirmasi pesanan
```

---

## 🎨 Desain & Tema

**Palet Warna:**
- 🟢 Hijau Utama: `#2D7A3A` — identitas brand
- 🟡 Kuning Utama: `#F5C518` — aksen & highlight
- 🟩 Hijau Muda: `#E8F5E9` — background card
- 🟨 Kuning Muda: `#FFF3B0` — background produk
- 🌑 Hijau Gelap: `#1B5E20` — teks & header

**Font:** Google Fonts — Poppins

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  google_fonts: ^6.1.0        # Font Poppins
  provider: ^6.1.1             # State management
  shared_preferences: ^2.2.2   # Local storage
```

---

## 🚀 Cara Menjalankan

### Prasyarat
- Flutter SDK 3.x ke atas
- Dart SDK 3.x
- Android Studio / VS Code
- Emulator atau device fisik

### Langkah-langkah

```bash
# 1. Masuk ke folder proyek
cd esteh_nusantara

# 2. Install dependencies
flutter pub get

# 3. Jalankan aplikasi
flutter run
```

---

## 📐 Arsitektur

Aplikasi menggunakan arsitektur **MVVM sederhana** dengan **Provider** sebagai state management:

```
View (Screens) ←→ Provider (CartProvider) ←→ Model (Product, CartItem)
```

- **Model**: Representasi data (Product, CartItem)
- **Provider**: State management untuk keranjang belanja
- **View**: Tampilan UI di setiap screen

---

## 📸 Alur Aplikasi

```
Splash Screen
     ↓
Home Screen (Katalog Menu)
     ↓
Product Detail Screen (Pilih ukuran & kemanisan)
     ↓
Cart Screen (Keranjang belanja)
     ↓
Checkout Screen (Form & pembayaran)
     ↓
Order Success Screen (Konfirmasi)
```

---

## 👨‍💻 Informasi

- **Framework**: Flutter 3.x
- **Bahasa**: Dart
- **State Management**: Provider
- **Mata Kuliah**: Pemrograman Mobile
- **Tema**: Es Teh Nusantara 🍵
