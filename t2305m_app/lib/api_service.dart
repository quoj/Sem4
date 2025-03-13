import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl = 'http://localhost/phpMyAdmin5/index.php?route=/sql&server=1&db=t2305m_preschool&table=accounts&pos=0'; // Đường dẫn đến API

  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${baseUrl}login.php'), // Đường dẫn đến file PHP
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['success']; // Giả sử API trả về {"success": true/false}
    } else {
      throw Exception('Failed to load data');
    }
  }
}