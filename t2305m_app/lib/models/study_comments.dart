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

  factory StudyComment.fromJson(Map<String, dynamic> json) {
    return StudyComment(
      id: json['id'],
      studentId: json['studentId'],
      commentType: json['commentType'],
      commentText: json['commentText'],
      commentDate: DateTime.parse(json['commentDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "studentId": studentId,
      "commentType": commentType,
      "commentText": commentText,
      "commentDate": DateFormat("yyyy-MM-dd").format(commentDate),
    };
  }

}
