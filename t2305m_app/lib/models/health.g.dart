// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Health _$HealthFromJson(Map<String, dynamic> json) => Health(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      birthDate: json['birthDate'] as String,
      gender: json['gender'] as String,
      height: (json['height'] as num).toDouble(),
      weight: (json['weight'] as num).toDouble(),
      healthNotes: json['healthNotes'] as String,
    );

Map<String, dynamic> _$HealthToJson(Health instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'birthDate': instance.birthDate,
      'gender': instance.gender,
      'height': instance.height,
      'weight': instance.weight,
      'healthNotes': instance.healthNotes,
    };
