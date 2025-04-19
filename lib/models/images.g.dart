// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'images.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Images _$ImagesFromJson(Map<String, dynamic> json) => Images(
      id: (json['id'] as num).toInt(),
      announcementId: (json['announcementId'] as num).toInt(),
      classId: (json['classId'] as num).toInt(),
      imageUrl: json['imageUrl'] as String,
    );

Map<String, dynamic> _$ImagesToJson(Images instance) => <String, dynamic>{
      'id': instance.id,
      'announcementId': instance.announcementId,
      'classId': instance.classId,
      'imageUrl': instance.imageUrl,
    };
