📦 Aplikasi Inventaris Komputer – Responsi 2 Mobile Paket 1

Nama: Amel (H1D023017)
Shift KRS : D
Shift Lama : E

Aplikasi ini dibuat untuk memenuhi tugas Responsi 2 Mobile Programming.
Aplikasi berjalan menggunakan Flutter Web dan terhubung ke backend CodeIgniter 4 sebagai REST API.

Aplikasi ini memungkinkan pengguna untuk melakukan:

✔ Login
✔ Register
✔ Melihat daftar inventaris
✔ Menambah data inventaris
✔ Mengedit data inventaris
✔ Menghapus inventaris
✔ Perhitungan otomatis total barang dan total nilai

Fitur Aplikasi
1. Halaman Login

User dapat login menggunakan email & password

Tersedia akun testing:

Email : h1d023017@student.com  
Password : password123


Menggunakan Auth API (login + token)

Screenshot:
<img width="959" height="954" alt="Screenshot 2025-12-06 082436" src="https://github.com/user-attachments/assets/967843b7-3d7d-4892-a90b-fb9918bffafd" />

2. Halaman Home

Setelah login, pengguna akan masuk ke halaman utama:

Menampilkan seluruh inventaris komputer

Sudah termasuk:

Harga satuan

Jumlah barang

Tanggal masuk

Total nilai (otomatis dihitung)

Informasi User ID

Tersedia tombol:

Refresh (ambil ulang data API)

Logout

Screenshot:
<img width="955" height="877" alt="Screenshot 2025-12-06 082104" src="https://github.com/user-attachments/assets/1623b632-d577-4c41-a89b-bfd4b033324b" />

 3. Tambah Inventaris

Pengguna bisa menambah data baru:

Nama barang

Harga satuan

Jumlah

Tanggal masuk

Data tersimpan ke database melalui API CodeIgniter 4

Notifikasi muncul: "Data berhasil ditambahkan"

Screenshot:
<img width="953" height="866" alt="Screenshot 2025-12-06 082322" src="https://github.com/user-attachments/assets/4abd4d46-68f8-4922-8607-5087f0cdba88" />
<img width="950" height="863" alt="Screenshot 2025-12-06 082135" src="https://github.com/user-attachments/assets/a24b1e62-4036-4a04-9b2e-8501447d43b6" />


 4. Edit Inventaris

Pengguna dapat memperbarui data item yang sudah ada

Perubahan langsung terlihat pada halaman Home

Notifikasi: "Data berhasil diperbarui"

Screenshot:
<img width="951" height="875" alt="Screenshot 2025-12-06 082345" src="https://github.com/user-attachments/assets/5e10ece8-fd57-4b44-b82d-78f71b6d491f" />
<img width="952" height="875" alt="Screenshot 2025-12-06 082213" src="https://github.com/user-attachments/assets/1d1fe2be-8d3d-47ac-a70f-7fdc3bc1a4e1" />


5. Hapus Inventaris

Data inventaris dapat dihapus

List otomatis diperbarui

Notifikasi: "Data berhasil dihapus"

Screenshot:
<img width="946" height="868" alt="Screenshot 2025-12-06 082357" src="https://github.com/user-attachments/assets/5032c728-94bd-43f0-9253-c309c3bc530a" />

🛠️ Teknologi yang Digunakan
Frontend (Flutter Web)

- Flutter 3.x

- State management: Provider

- HTTP package untuk request REST API

- Shared Preferences untuk menyimpan token login

- Fluttertoast untuk notifikasi CRUD

Backend (CodeIgniter 4)

- RESTful API

- Controller:

AuthController (login, register)

InventarisController (CRUD)

- Database MySQL
