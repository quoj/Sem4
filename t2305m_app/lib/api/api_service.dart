import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import '../models/user.dart';


part 'api_service.g.dart';

@RestApi(baseUrl: "http://localhost:8080")
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET("/users")
  Future<List<User>> getUsers();

}