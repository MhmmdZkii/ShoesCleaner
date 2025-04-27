import 'package:flutter/material.dart';

// Halaman Promosi tanpa tombol kembali dan tanpa tulisan "Promosi"
class PromosiPage extends StatefulWidget {
  @override
  _PromosiPageState createState() => _PromosiPageState();
}

class _PromosiPageState extends State<PromosiPage> {
  int _selectedIndex = 2; // Indeks default untuk halaman "Promosi"

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Logika untuk navigasi antar halaman bisa ditambahkan di sini
    print("Navigasi ke halaman indeks: $index");
    // Contoh: Navigator.pushReplacementNamed(context, '/halaman-lain');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            _buildPromo(
              "Cuci Sepatu Bergaransi",
              "Diskon 30% Berlaku untuk sepatu casual",
              "assets/Jasa cuci sepatu promosi 1.png", // Gambar dari assets
            ),
            _buildPromo(
              "Promo 170RB 5 Pasang",
              "Cuci Sepatu Murah, Bersih, dan Wangi",
              "assets/Jasa cuci sepatu promosi 1 (1).png",
            ),
            _buildPromo(
              "Flash Sale",
              "Cuci sepatu lebih hemat",
              "assets/Jasa cuci sepatu promosi 1 (2).png",
            ),
            _buildPromo(
              "Cuci Sepatumu Sekarang!",
              "Gratis antar jemput, diskon 15%",
              "assets/Jasa cuci sepatu promosi 1 (3).png",
            ),
            _buildPromo(
              "Cuci Sepatumu Sekarang!",
              "Gratis antar jemput, diskon 15%",
              "assets/Jasa cuci sepatu promosi 1 (4).png",
            ),
            _buildPromo(
              "Cuci Sepatumu Sekarang!",
              "Gratis antar jemput, diskon 15%",
              "assets/Jasa cuci sepatu promosi 1 (5).png",
            ),
            _buildPromo(
              "Cuci Sepatumu Sekarang!",
              "Gratis antar jemput, diskon 15%",
              "assets/Jasa cuci sepatu promosi 1 (6).png",
            ),
            _buildPromo(
              "Cuci Sepatumu Sekarang!",
              "Gratis antar jemput, diskon 15%",
              "assets/Jasa cuci sepatu promosi 1 (7).png",
            ),
            _buildPromo(
              "Cuci Sepatumu Sekarang!",
              "Gratis antar jemput, diskon 15%",
              "assets/Jasa cuci sepatu promosi 1 (8).png",
            ),
            _buildPromo(
              "Cuci Sepatumu Sekarang!",
              "Gratis antar jemput, diskon 15%",
              "assets/Jasa cuci sepatu promosi 1 (9).png",
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildPromo(String title, String description, String imageUrl) {
  return Card(
    elevation: 4,
    margin: EdgeInsets.symmetric(vertical: 10),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
          child: Image.network(imageUrl,
              fit: BoxFit.cover, width: double.infinity, height: 150),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(description, style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ],
    ),
  );
}
