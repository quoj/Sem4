import 'package:json_annotation/json_annotation.dart';

part 'feedback.g.dart';

@JsonSerializable()
class FeedbackModel {
  final int id;
  final int senderId;   // Đổi userId -> senderId để khớp với Backend
  final int receiverId; // Thêm receiverId
  final String content; // Đổi message -> content
  final String status;  // Thêm status nếu cần
  final String? imageUrl;
  final DateTime createdAt;

  FeedbackModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.status,
    this.imageUrl,
    required this.createdAt,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) =>
      _$FeedbackModelFromJson(json);

  Map<String, dynamic> toJson() => _$FeedbackModelToJson(this);
}
