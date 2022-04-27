import 'package:frontend/models/trip.dart';

import 'package:json_annotation/json_annotation.dart';
part 'journey.g.dart';

@JsonSerializable()
class Journey {
  int? id;
  int? id_user;
  DateTime start_date;
  DateTime end_date;

  Journey({
    this.id,
    this.id_user,
    required this.start_date,
    required this.end_date,
  });
  factory Journey.fromJson(Map<String, dynamic> json) =>
      _$JourneyFromJson(json);
  Map<String, dynamic> toJson() => _$JourneyToJson(this);
}
