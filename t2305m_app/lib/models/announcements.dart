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

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      content: json['content'],
      imagePath: json['imagePath'],
      createdAt: json['createdAt'],
    );
  }

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
}
