import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderHistoryScreen extends StatefulWidget {
  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  List<dynamic> orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    final response = await http.get(
      Uri.parse('https://your-backend.com/api/pesanans'),
      headers: {'Authorization': 'Bearer YOUR_TOKEN'}, // Ganti dengan token autentikasi
    );

    if (response.statusCode == 200) {
      setState(() {
        orders = jsonDecode(response.body);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat riwayat pesanan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Riwayat Pesanan')),
      body: orders.isEmpty
          ? Center(child: Text('Belum ada pesanan'))
          : ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return ListTile(
            title: Text('Pesanan #${order['id']} - ${order['layanan_dipesan'] ?? 'Layanan'}'),
            subtitle: Text('Status: ${order['status']} | Rp ${order['total_harga']}'),
            trailing: Text(order['created_at'].substring(0, 10)),
            onTap: () {
              // Navigasi ke halaman detail pesanan (opsional)
            },
          );
        },
      ),
    );
  }
}