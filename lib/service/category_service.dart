import 'dart:async';

import 'package:dio/dio.dart';
import 'package:t2305m_app/model/category.dart';
import 'package:t2305m_app/models/announcements.dart';

class CategoryService{
  final Dio _dio;
  // constructor base URL
  CategoryService(): _dio = Dio(BaseOptions(baseUrl: "https://dummyjson.com"));

  Future<List<Category>> getCategories() async{
    try{
      final res = await _dio.get("/product/categories");
      final data = res.data as List;
      return data.map((json) => Category.fromJson(json)).toList();
    }on DioException {
      return [];
    }
  }

  Future<List<Announcement>> getAnnouncements() async {
    try {
      final res = await _dio.get("/announcements");
      final data = res.data as List;
      return data.map((json) => Announcement.fromJson(json)).toList();
    } catch (e) {
      print("Lỗi khi tải thông báo: $e");
      return [];
    }
  }
}
