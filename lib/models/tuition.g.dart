// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tuition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tuition _$TuitionFromJson(Map<String, dynamic> json) => Tuition(
      id: (json['id'] as num).toInt(),
      studentId: (json['studentId'] as num).toInt(),
      description: json['description'] as String,
      amount: (json['amount'] as num?)?.toDouble(),
      tuitionDate: json['tuitionDate'] == null
          ? null
          : DateTime.parse(json['tuitionDate'] as String),
    );

Map<String, dynamic> _$TuitionToJson(Tuition instance) => <String, dynamic>{
      'id': instance.id,
      'studentId': instance.studentId,
      'description': instance.description,
      'amount': instance.amount,
      'tuitionDate': instance.tuitionDate?.toIso8601String(),
    };
