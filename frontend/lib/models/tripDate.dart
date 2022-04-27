class TripDate {
  int? id;
  int? id_journey;
  double? latitude;
  double? longitude;
  String? city;
  String? country;
  String? name;
  bool? visited;
  DateTime? start_date;
  DateTime? end_date;

  TripDate({
    this.id,
    this.id_journey,
    this.latitude,
    this.longitude,
    this.city,
    this.country,
    this.name,
    this.visited,
    this.start_date,
    this.end_date,
  });
}
