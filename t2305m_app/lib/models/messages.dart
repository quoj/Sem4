import 'package:json_annotation/json_annotation.dart';

part 'messages.g.dart';

@JsonSerializable()
class Message {
  final int id;
  final int senderId;
  final int receiverId;
  final int studentId;
  final String content;
  final String? imagePath;
  final String status; // "Đã xác nhận" hoặc "Chưa xác nhận"
  final DateTime createdAt;

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.studentId,
    required this.content,
    this.imagePath,
    required this.status,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}
