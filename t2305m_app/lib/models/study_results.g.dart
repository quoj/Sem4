// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_results.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudyResult _$StudyResultFromJson(Map<String, dynamic> json) => StudyResult(
      id: (json['id'] as num?)?.toInt(),
      studentId: (json['studentId'] as num).toInt(),
      category: json['category'] as String,
      detail: json['detail'] as String,
      resultDate: DateTime.parse(json['resultDate'] as String),
    );

Map<String, dynamic> _$StudyResultToJson(StudyResult instance) =>
    <String, dynamic>{
      'id': instance.id,
      'studentId': instance.studentId,
      'category': instance.category,
      'detail': instance.detail,
      'resultDate': instance.resultDate.toIso8601String(),
    };
