import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

// Asumsi halaman lain sudah ada
import 'kupondiskon_page.dart';
import 'pesanansayapage.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  final String token;

  const HomePage({super.key, required this.token});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  File? _image;
  String? _detectionResult;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  final List<Map<String, String>> kuponList = [
    {
      "title": "DISKON 30%",
      "desc": "Aughment treatment",
      "date": "22 Februari 2025"
    },
    {"title": "DISKON 50%", "desc": "Shoes treatment", "date": "5 Maret 2025"},
    {"title": "DISKON 15%", "desc": "Bag treatment", "date": "15 Maret 2025"},
    {"title": "DISKON 10%", "desc": "Carpet treatment", "date": "1 April 2025"},
    {"title": "DISKON 20%", "desc": "Jacket treatment", "date": "10 Mei 2025"},
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      // Tetap di halaman Home
    } else if (index == 1) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => KuponDiskonPage(token: widget.token)));
    } else if (index == 2) {
      // Ganti dengan halaman yang sesuai, misalnya BuatPesananPage
      // Navigator.push(context, MaterialPageRoute(builder: (context) => BuatPesananPage()));
    } else if (index == 3) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => PesananSayaPage()));
    } else if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(token: widget.token),
        ),
      );
    }
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Konfirmasi Logout"),
          content: Text("Apakah Anda yakin ingin keluar?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Tidak", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, "/");
              },
              child: Text("Ya", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
        _detectionResult = null;
      });
    }
  }

  Future<void> sendImage(File image) async {
    setState(() {
      _isLoading = true;
    });

    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse('http://192.168.100.14:5000/api/detect')); // URL server Anda
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
      var response = await request.send();

      if (response.statusCode == 200) {
        var result = jsonDecode(await response.stream.bytesToString());
        setState(() {
          _detectionResult = result['detection'].toString();
          _isLoading = false;
        });
      } else {
        setState(() {
          _detectionResult = 'Gagal mengirim gambar: ${response.statusCode}';
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengirim gambar')),
        );
      }
    } catch (e) {
      setState(() {
        _detectionResult = 'Error: $e';
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String name = widget.token;

    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.black),
            onPressed: () {
              _showLogoutConfirmationDialog(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(
              //   "Halo, $name!",
              //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              // ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage('assets/banner.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PesananSayaPage()),
                  );
                },
                icon: Icon(Icons.receipt_long),
                label: Text("Pesanan Saya"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "yuk pilih layanan yg cocok untuk sepatumu!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: Icon(Icons.image),
                    label: Text("Pilih Foto"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  if (_image != null)
                    ElevatedButton.icon(
                      onPressed: () => sendImage(_image!),
                      icon: Icon(Icons.send),
                      label: Text("Kirim Foto"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                      ),
                    ),
                ],
              ),
              SizedBox(height: 10),
              if (_image != null)
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: FileImage(_image!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              SizedBox(height: 10),
              if (_isLoading)
                CircularProgressIndicator()
              else if (_detectionResult != null)
                Text(
                  "Hasil Deteksi: $_detectionResult",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  menuItem(Icons.local_offer, "Kupon/diskon"),
                  menuItem(Icons.campaign, "Promosi"),
                ],
              ),
              SizedBox(height: 20),
              Text("Kupon",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: kuponList.length,
                itemBuilder: (context, index) {
                  final kupon = kuponList[index];
                  return kuponItem(
                      kupon['title']!, kupon['desc']!, kupon['date']!);
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_offer), label: "Kupon"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: "Keranjang"),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long), label: "Pesanan"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }

  Widget menuItem(IconData icon, String title) {
    return Column(
      children: [
        Icon(icon, size: 40, color: Colors.black),
        SizedBox(height: 5),
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget kuponItem(String title, String desc, String date) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        leading: Icon(Icons.local_offer, color: Colors.black),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(desc, softWrap: true),
            Text("Berlaku s/d $date",
                style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}