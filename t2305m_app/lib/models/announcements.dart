import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'announcements.g.dart';

@JsonSerializable()
class Announcement {
  final int? id;
  final String title;
  final String author;
  final String content;
  final String imagePath;
  final String createdAt;

  Announcement({
    this.id,
    required this.title,
    required this.author,
    required this.content,
    required this.imagePath,
    required this.createdAt,
  });

  /// Chuyển đổi JSON thành Object
  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      content: json['content'],
      imagePath: json['imagePath'],
      createdAt: _formatDateTime(json['createdAt']), // Xử lý thời gian
    );
  }

  /// Chuyển đổi Object thành JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "author": author,
      "content": content,
      "imagePath": imagePath,
      "createdAt": createdAt,
    };
  }

  /// Hàm định dạng thời gian
  static String _formatDateTime(String? dateTime) {
    if (dateTime == null || dateTime.isEmpty) return "Không xác định";
    try {
      DateTime parsedDate = DateTime.parse(dateTime);
      return DateFormat('hh:mm a, dd/MM/yyyy').format(parsedDate);
    } catch (e) {
      return "Không xác định";
    }
  }
}
