import 'package:dio/dio.dart';
import '../models/announcements.dart';

class AnnouncementService {
  final Dio _dio = Dio(BaseOptions(baseUrl: "https://dummyjson.com"));

  Future<List<Announcement>> getAnnouncements() async {
    try {
      final response = await _dio.get("/announcements");
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => Announcement.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load announcements");
      }
    } catch (e) {
      print("Error fetching announcements: $e");
      return [];
    }
  }
}
