// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_requests.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeaveRequest _$LeaveRequestFromJson(Map<String, dynamic> json) => LeaveRequest(
      id: (json['id'] as num).toInt(),
      studentId: (json['studentId'] as num).toInt(),
      reason: json['reason'] as String,
      date: json['date'] as String,
      status: json['status'] as String?,
      requestTime: json['requestTime'] as String?,
    );

Map<String, dynamic> _$LeaveRequestToJson(LeaveRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'studentId': instance.studentId,
      'reason': instance.reason,
      'date': instance.date,
      'status': instance.status,
      'requestTime': instance.requestTime,
    };
