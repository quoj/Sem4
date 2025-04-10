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

  factory Image.fromJson(Map<String, dynamic> json) => _$ImageFromJson(json);
  Map<String, dynamic> toJson() => _$ImageToJson(this);
}
