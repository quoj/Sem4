import 'package:dio/dio.dart';
import '../models/messages.dart';

class MessageApi {
  final Dio _dio = Dio(BaseOptions(baseUrl: "http://10.0.2.2:8080"));

  Future<List<Message>> getMessages() async {
    try {
      final response = await _dio.get("/messages"); // Sửa lại API endpoint
      final List<dynamic> data = response.data; // Kiểm tra dữ liệu trả về có phải List không
      return data.map((json) => Message.fromJson(json)).toList();
    } catch (e) {
      print("Lỗi API: $e");
      return [];
    }
  }

  Future<void> sendMessage(Message message) async {
    try {
      final response = await _dio.post(
        "/messages",
        data: {
          "senderId": message.senderId,
          "receiverId": message.receiverId,
          "studentId": message.studentId,
          "content": message.content,
          "imagePath": message.imagePath,
          "status": message.status,
          "createdAt": message.createdAt.toIso8601String(),
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Gửi tin nhắn thành công!");
      } else {
        print("Lỗi khi gửi tin nhắn: ${response.statusCode}");
      }
    } catch (e) {
      print("Lỗi khi gọi API: $e");
    }
  }
}
