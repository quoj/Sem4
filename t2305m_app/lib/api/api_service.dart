import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import '../models/announcements.dart';
import '../models/messages.dart';
import '../models/login_request.dart';
import '../models/study_comments.dart';
import '../models/study_results.dart';
import '../models/user.dart';
import '../models/schedule.dart';
import '../models/feedback.dart';
import '../models/tuition.dart';
import '../models/health.dart';

import 'package:retrofit/error_logger.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: "http://10.0.2.2:8080")
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET("/users")
  Future<List<User>> getUsers();

  @POST("/users/login")
  Future<User> loginUser(@Body() LoginRequest loginRequest);

  @GET("/schedules")
  Future<List<Schedule>> getSchedules();

  @GET("/messages")
  Future<List<Message>> getMessage();

  @POST("/messages")
  Future<void> sendMessage(@Body() Message message);

  @GET("/feedbacks")
  Future<List<FeedbackModel>> getFeedback();

  @MultiPart()
  @POST("/feedbacks")
  Future<void> sendFeedback(@Body() Map<String, dynamic> feedbackData);

  @GET("/announcements")
  Future<List<Announcement>> getAnnouncements();

  @POST("/announcements")
  Future<void> createAnnouncement(@Body() Announcement announcement);

  @GET("/study_comments")
  Future<List<StudyComment>> getStudyComment();

  @GET("/study_results")
  Future<List<StudyResult>> getStudyResult();

  @GET("/tuitions")
  Future<List<Tuition>> getTuitions();

  @GET("/health")
  Future<List<Health>> getHealth();
}
