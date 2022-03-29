import 'package:frontend/models/trip.dart';

class Journey {
  int? id;
  Trip id_trip;
  DateTime start;
  DateTime end;

  Journey({
    this.id,
    required this.id_trip,
    required this.start,
    required this.end,
  });
}
