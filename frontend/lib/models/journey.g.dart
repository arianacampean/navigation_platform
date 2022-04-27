// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journey.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Journey _$JourneyFromJson(Map<String, dynamic> json) => Journey(
      id: json['id'] as int?,
      id_user: json['id_user'] as int?,
      start_date: DateTime.parse(json['start_date'] as String),
      end_date: DateTime.parse(json['end_date'] as String),
    );

Map<String, dynamic> _$JourneyToJson(Journey instance) => <String, dynamic>{
      'id': instance.id,
      'id_user': instance.id_user,
      'start_date': instance.start_date.toIso8601String(),
      'end_date': instance.end_date.toIso8601String(),
    };
