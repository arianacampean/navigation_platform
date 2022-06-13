import 'package:json_annotation/json_annotation.dart';

part 'trip.g.dart';

@JsonSerializable()
class Trip {
  int? id;
  int? id_journey;
  double latitude;
  double longitude;
  String city;
  String country;
  String name;
  bool visited;

  Trip({
    this.id,
    this.id_journey,
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.country,
    required this.name,
    required this.visited,
  });

  @override
  String toString() {
    // TODO: implement toString
    return this.city + " - " + this.country + " - " + this.name;
  }

  Trip.clone(Trip clone)
      : this.id = clone.id,
        this.latitude = clone.latitude,
        this.longitude = clone.longitude,
        this.city = clone.city,
        this.country = clone.country,
        this.name = clone.name,
        this.visited = clone.visited;

  factory Trip.fromJson(Map<String, dynamic> json) => _$TripFromJson(json);
  Map<String, dynamic> toJson() => _$TripToJson(this);
}
