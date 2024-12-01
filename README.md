# jikan

Projek Mobile Jiikan Anime Apps merupakan sebuah projek yang saya buat untuk memenuhi kebutuhan tugas UAS saya selama menempuh mata kuliah pemrograman mobile. Tujuan dari projek ini adalah untuk menampilkan data anime seeprti my animelist namun dalam bentuk mobile apps yang lebih simple

## Lebih detail tentang projek

Halaman utama aplikasi menampilkan daftar anime terbaru dan rekomendasi anime menggunakan API eksternal. FutureBuilder digunakan untuk mengambil data secara asinkron, memastikan tampilan data yang responsif dan dinamis. Daftar anime ditampilkan dalam format grid, sementara rekomendasi anime disusun dalam slider horizontal. Setiap item anime dapat diklik untuk melihat detail lebih lanjut, dan ada penanganan kesalahan serta indikator loading yang meningkatkan keandalan aplikasi.

Halaman detail anime memungkinkan pengguna untuk mengakses informasi mendalam mengenai anime tertentu, seperti karakter, staf, episode, dan sinopsis. Pengambilan data dilakukan secara paralel dengan Future.wait, dan tampilan halaman menggunakan SliverAppBar untuk menampilkan poster anime. Pengguna juga dapat mengakses informasi episode dan staf melalui daftar yang dapat diperluas. Fungsi navigasi antar halaman berjalan lancar, menggunakan Navigator.push untuk berpindah ke halaman detail anime atau episode.

Fitur pencarian anime menggunakan TextField untuk memasukkan nama anime yang kemudian dicari melalui API Jikan. Data hasil pencarian ditampilkan dalam bentuk daftar yang terorganisir, dengan setiap item menampilkan gambar, judul, sinopsis, dan rating anime. Hasil pencarian dapat dipilih untuk melihat detail lebih lanjut. Untuk navigasi, aplikasi menggunakan CurvedNavBar dengan tab untuk berpindah antara halaman Home, Schedule, dan Search.

Secara keseluruhan, aplikasi ini menggabungkan berbagai fitur yang memudahkan pengguna untuk mencari, melihat, dan menjadwalkan anime dengan antarmuka yang ramah pengguna dan desain estetis. Meskipun telah mencakup banyak fitur utama, masih ada ruang untuk pengembangan lebih lanjut, seperti peningkatan kecepatan aplikasi, penambahan fitur personalisasi, dan penyempurnaan antarmuka pengguna agar lebih interaktif dan menarik.

![My Image](https://github.com/Nilfgard13/jikan_mobile/blob/main/images/my-image.png?raw=true)

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
