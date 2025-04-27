import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RiwayatPesananPage extends StatefulWidget {
  @override
  _RiwayatPesananPageState createState() => _RiwayatPesananPageState();
}

class _RiwayatPesananPageState extends State<RiwayatPesananPage> {
  List<dynamic> pesananSelesai = [];

  @override
  void initState() {
    super.initState();
    fetchRiwayatPesanan();
  }

  void fetchRiwayatPesanan() async {
    final response =
        await http.get(Uri.parse('http://192.168.100.14:8000/api/pesanan'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        // Pastikan status tidak null
        pesananSelesai = data.where((p) {
          final status = p['status']?.toLowerCase();
          return status == 'selesai';
        }).toList();
      });
    } else {
      print('Gagal mengambil data pesanan');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Riwayat Pesanan")),
      body: pesananSelesai.isEmpty
          ? Center(child: Text("Belum ada pesanan yang selesai"))
          : ListView.builder(
              itemCount: pesananSelesai.length,
              itemBuilder: (context, index) {
                final pesanan = pesananSelesai[index];

                final name = pesanan['nama'] ?? '-';
                final alamat = pesanan['alamat'] ?? '-';
                final noTelepon = pesanan['no_telepon'] ?? '-';
                final layanan_dipesan = pesanan['layanan_dipesan'] ?? '-';
                final metode = pesanan['metode_pembayaran'] ?? '-';
                final total = pesanan['total_pembayaran']?.toString() ?? '0';
                final status = pesanan['status'] ?? '-';
                final catatan = pesanan['catatan'] ?? '-';
                final waktu_pemesanan = pesanan['waktu_pemesanan'] ?? '-';
                final jenis_pengiriman = pesanan['jenis_pengiriman'] ?? '-';
                final jarak = pesanan['jarak'] ?? '-';

                final buktiTransfer = pesanan['bukti_transfer'] ?? '';

                // URL gambar bukti transfer, jika ada
                final String? imageUrl = buktiTransfer.isNotEmpty
                    ? 'http://192.168.100.14:8000/$buktiTransfer'
                    : null;

                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Alamat: $alamat"),
                        Text("Telepon: $noTelepon"),
                        Text("Layanan: $layanan_dipesan"),
                        Text("Metode Pembayaran: $metode"),
                        Text("Total: Rp$total"),
                        Text("Waktu Pemesanan: $waktu_pemesanan"),
                        Text("Jenis Pengiriman: $jenis_pengiriman"),
                        Text("Catatan: $catatan"),
                        Text("Jarak: $jarak"),

                        // Menambahkan tampilan bukti transfer jika ada
                        if (imageUrl != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Bukti Transfer:",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 8),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      imageUrl,
                                      height: 400,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Text("Gagal memuat gambar"),
                                    ),
                                  )
                                ]),
                          ),

                        SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Status: ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                status,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
