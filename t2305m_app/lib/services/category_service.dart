import 'dart:async';

import 'package:dio/dio.dart';
import 'package:t2305m_app/model/category.dart';

class CategoryService{
  final Dio _dio;
  // constructor base URL
  CategoryService(): _dio = Dio(BaseOptions(baseUrl: "https://dummyjson.com"));

  Future<List<Category>> getCategories() async{
    try{
      final res = await _dio.get("/product/categories");
      final data = res.data as List;
      return data.map((json) => Category.fromJson(json)).toList();
      // List<Category> data = [];
      // for(int i=0;i<res.data.length;i++){
      //   data.add(Category.fromJson(res.data[i]));
      // }
      // return data;
    }on DioException {
      return [];
    }
  }
}