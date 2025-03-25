import 'package:dio/dio.dart';


import '../models/schedule.dart';

class ScheduleService {
  final Dio _dio = Dio(BaseOptions(baseUrl: "http://10.0.2.2:8080")); // Thay API thật vào

  Future<List<Schedule>> getSchedules() async {
    try {
      final response = await _dio.get("/schedules"); // Gọi API
      final data = response.data as List;
      return data.map((json) => Schedule.fromJson(json)).toList(); // Chuyển thành danh sách Schedule
    } catch (e) {
      print("Lỗi API: $e");
      return []; // Nếu lỗi, trả về danh sách rỗng
    }
  }
}
