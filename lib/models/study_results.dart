import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'study_results.g.dart';

@JsonSerializable()
class StudyResult {
  final int? id;
  final int studentId;
  final String category;
  final String detail;
  final DateTime resultDate;

  StudyResult({
    this.id,
    required this.studentId,
    required this.category,
    required this.detail,
    required this.resultDate,
  });

  /// Chuyển đổi JSON thành Object
  factory StudyResult.fromJson(Map<String, dynamic> json) {
    return StudyResult(
      id: json['id'],
      studentId: json['student_id'],
      category: json['category'],
      detail: json['detail'],
      resultDate: DateFormat("yyyy-MM-dd").parse(json['result_date']),
    );
  }

  /// Chuyển đổi Object thành JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "student_id": studentId,
      "category": category,
      "detail": detail,
      "result_date": DateFormat("yyyy-MM-dd").format(resultDate),
    };
  }
}
