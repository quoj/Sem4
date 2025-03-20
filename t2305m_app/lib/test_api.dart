import 'package:dio/dio.dart';
import 'api/api_service.dart';


void main() async {
  final dio = Dio();
  final apiService = ApiService(dio);

  try {
    final users = await apiService.getUsers();
    print("Danh sách Users:");
    for (var user in users) {
      print("ID: ${user.id}, Name: ${user.name}, Email: ${user.email}");
    }
  } catch (e) {
    print("Lỗi gọi API: $e");
  }
}