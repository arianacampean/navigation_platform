// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Trip _$TripFromJson(Map<String, dynamic> json) => Trip(
      id: json['id'] as int?,
      id_journey: json['id_journey'] as int?,
      latitude: double.parse(json['latitude']),
      longitude: double.parse(json['longitude']),
      city: json['city'] as String,
      country: json['country'] as String,
      name: json['name'] as String,
      visited: json['visited'] as bool,
    );

Map<String, dynamic> _$TripToJson(Trip instance) => <String, dynamic>{
      'id': instance.id,
      'id_journey': instance.id_journey,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'city': instance.city,
      'country': instance.country,
      'name': instance.name,
      'visited': instance.visited,
    };
