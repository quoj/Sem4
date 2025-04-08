// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_comments.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudyComment _$StudyCommentFromJson(Map<String, dynamic> json) => StudyComment(
      id: (json['id'] as num?)?.toInt(),
      studentId: (json['studentId'] as num).toInt(),
      commentType: json['commentType'] as String,
      commentText: json['commentText'] as String?,
      commentDate: DateTime.parse(json['commentDate'] as String),
    );

Map<String, dynamic> _$StudyCommentToJson(StudyComment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'studentId': instance.studentId,
      'commentType': instance.commentType,
      'commentText': instance.commentText,
      'commentDate': instance.commentDate.toIso8601String(),
    };
