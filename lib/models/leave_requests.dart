  import 'package:json_annotation/json_annotation.dart';

  part 'leave_requests.g.dart'; // Thêm dòng này để tạo file .g.dart

  @JsonSerializable()
  class LeaveRequest {
    final int id;
    final int studentId;
    final String reason;
    final String date;
    final String? status;
    final String? requestTime;

    LeaveRequest({
      required this.id,
      required this.studentId,
      required this.reason,
      required this.date,
      this.status,
      this.requestTime,
    });

    // Phương thức factory để chuyển đổi từ JSON thành đối tượng LeaveRequest
    factory LeaveRequest.fromJson(Map<String, dynamic> json) => _$LeaveRequestFromJson(json);

    // Phương thức để chuyển đổi đối tượng LeaveRequest thành JSON
    Map<String, dynamic> toJson() => _$LeaveRequestToJson(this);
  }
