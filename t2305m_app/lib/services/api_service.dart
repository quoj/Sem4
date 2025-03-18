import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8080"; // URL API (Android Emulator)

  // Hàm đăng nhập
  static Future<Map<String, dynamic>?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/users"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Trả về dữ liệu từ API
    } else {
      return null; // Xử lý lỗi
    }
  }
}
