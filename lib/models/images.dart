import 'package:json_annotation/json_annotation.dart';

part 'images.g.dart';

@JsonSerializable()
class Images {
  final int id;
  final int announcementId;
  final int classId;
  final String imageUrl;

  Images({
    required this.id,
    required this.announcementId,
    required this.classId,
    required this.imageUrl,
  });

  // Factory constructor để tạo đối tượng từ JSON
  factory Images.fromJson(Map<String, dynamic> json) {
    return Images(
      id: json['id'],
      announcementId: json['announcementId'],
      classId: json['classId'],
      imageUrl: json['imageUrl'],
    );
  }
}

