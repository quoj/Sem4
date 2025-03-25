import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import '../models/login_request.dart';
import '../models/user.dart';
import '../models/schedule.dart';


part 'api_service.g.dart';

@RestApi(baseUrl: "http://10.0.2.2:8080") // Nếu chạy trên Android Emulator
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET("/users")
  Future<List<User>> getUsers();

  @POST("/users/login")
  Future<User> loginUser(@Body() LoginRequest loginRequest);

  @GET("/schedules")
  Future<List<Schedule>> getSchedules();


}