import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = "http://192.168.100.14:8000/api";
  static const Duration timeoutDuration = Duration(seconds: 10);

  static Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final client = http.Client();
      final response = await client
          .post(
        Uri.parse("$baseUrl/login"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({"email": email, "password": password}),
      )
          .timeout(timeoutDuration);

      print("Login Response Status Code: ${response.statusCode}");
      print("Login Response Body: ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        await saveToken(data['token']);
        return data;
      } else {
        return {"error": "Login gagal. Periksa email dan password!"};
      }
    } catch (e) {
      print("Login Error: $e");
      return {"error": "Terjadi kesalahan: $e"};
    }
  }

  static Future<Map<String, dynamic>?> register(
      String name, String email, String password, String confirmPassword) async {
    try {
      final client = http.Client();
      final response = await client
          .post(
        Uri.parse("$baseUrl/register"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password,
          "password_confirmation": confirmPassword,
        }),
      )
          .timeout(timeoutDuration);

      print("Register Response Status Code: ${response.statusCode}");
      print("Register Response Body: ${response.body}");

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        return {"error": "Registrasi gagal: ${response.body}"};
      }
    } catch (e) {
      print("Register Error: $e");
      return {"error": "Terjadi kesalahan: $e"};
    }
  }

  static Future<Map<String, dynamic>?> logout(String token) async {
    try {
      final client = http.Client();
      final response = await client
          .post(
        Uri.parse("$baseUrl/logout"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      )
          .timeout(timeoutDuration);

      print("Logout Response Status Code: ${response.statusCode}");
      print("Logout Response Body: ${response.body}");

      if (response.statusCode == 200) {
        await clearToken();
        return jsonDecode(response.body);
      } else {
        return {"error": "Gagal logout: ${response.body}"};
      }
    } catch (e) {
      print("Logout Error: $e");
      return {"error": "Terjadi kesalahan: $e"};
    }
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
}