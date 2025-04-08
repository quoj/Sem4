import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'study_comments.g.dart';

@JsonSerializable()
class StudyComment {
  final int? id;
  final int studentId;
  final String commentType;
  final String? commentText;
  final DateTime commentDate;

  StudyComment({
    this.id,
    required this.studentId,
    required this.commentType,
    this.commentText,
    required this.commentDate,
  });

  /// Chuyển đổi JSON thành Object
  factory StudyComment.fromJson(Map<String, dynamic> json) {
    return StudyComment(
      id: json['id'],
      studentId: json['student_id'],
      commentType: json['comment_type'],
      commentText: json['comment_text'],
      commentDate: DateFormat("yyyy-MM-dd").parse(json['comment_date']),
    );
  }

  /// Chuyển đổi Object thành JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "student_id": studentId,
      "comment_type": commentType,
      "comment_text": commentText,
      "comment_date": DateFormat("yyyy-MM-dd").format(commentDate),
    };
  }
}
