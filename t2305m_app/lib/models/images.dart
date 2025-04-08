import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'images.g.dart';

@JsonSerializable()
class Image {
  final int? id;
  final int announcementId;
  final String imagePath;

  Image({
    this.id,
    required this.announcementId,
    required this.imagePath,
  });

  /// Chuyển đổi JSON thành Object
  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      id: json['id'],
      announcementId: json['announcementId'],
      imagePath: json['imagePath'],
    );
  }

  /// Chuyển đổi Object thành JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "announcementId": announcementId,
      "imagePath": imagePath,
    };
  }
}
