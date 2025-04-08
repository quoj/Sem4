// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tuition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tuition _$TuitionFromJson(Map<String, dynamic> json) => Tuition(
      id: (json['id'] as num).toInt(),
      studentId: (json['student_id'] as num).toInt(),
      description: json['description'] as String,
      amount: (json['amount'] as num?)?.toDouble(),
      tuitionDate: json['tuition_date'] as String?,
    );

Map<String, dynamic> _$TuitionToJson(Tuition instance) => <String, dynamic>{
      'id': instance.id,
      'student_id': instance.studentId,
      'description': instance.description,
      'amount': instance.amount,
      'tuition_date': instance.tuitionDate,
    };
