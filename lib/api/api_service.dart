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
import '../models/images.dart';
import '../models/menu.dart';
import '../models/attendance.dart';
import '../models/leave_requests.dart';


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

  @GET("/images")
  Future<List<Images>> getImages();

  @GET("/menus")
  Future<List<Menu>> getMenus();

  @GET("/menus/by-date")
  Future<Menu?> getMenuByDate(@Query("date") String date); // format: yyyy-MM-dd

  // 🔸 Lấy danh sách điểm danh
  @GET("/attendance")
  Future<List<Attendance>> getAttendances();

  // 🔸 Lấy điểm danh theo ID
  @GET("/attendance/{id}")
  Future<Attendance> getAttendanceById(@Path("id") int id);

  // 🔸 Tạo điểm danh mới
  @POST("/attendance")
  Future<Attendance> createAttendance(@Body() Attendance attendance);

  // 🔸 Cập nhật trạng thái điểm danh
  @PUT("/attendance/{id}/status")
  Future<Attendance> updateAttendanceStatus(
      @Path("id") int id,
      @Query("status") String status,
      );

  // 🔸 Xóa điểm danh
  @DELETE("/attendance/{id}")
  Future<void> deleteAttendance(@Path("id") int id);

// Lấy tất cả đơn xin nghỉ
  @GET("/leave_requests")
  Future<List<LeaveRequest>> getLeaveRequests();

  // Lấy đơn xin nghỉ theo ID
  @GET("/leave_requests/{id}")
  Future<LeaveRequest> getLeaveRequestById(@Path("id") int id);

  // Tạo đơn xin nghỉ mới
  @POST("/leave_requests")
  Future<LeaveRequest> createLeaveRequest(@Body() LeaveRequest leaveRequest);

  // Cập nhật trạng thái đơn xin nghỉ
  @PUT("/leave_requests/{id}/status")
  Future<LeaveRequest> updateLeaveRequestStatus(
      @Path("id") int id,
      @Query("status") String status,
      );

  // Xóa đơn xin nghỉ
  @DELETE("/leave_requests/{id}")
  Future<void> deleteLeaveRequest(@Path("id") int id);

}
