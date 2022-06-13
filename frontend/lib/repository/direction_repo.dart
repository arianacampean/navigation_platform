import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:frontend/models/directions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DirectionsRepo {
  static const String url =
      'https://maps.googleapis.com/maps/api/directions/json?';
  late final Dio _dio;
  String googleApiKey = 'AIzaSyBi5Y_ei3rpHfOV2AhVquMzd0YhSEqvhBA';
  DirectionsRepo({Dio? dio}) : _dio = dio ?? Dio();

  //aflarea rutei de la sursa origin la destinatia destination
  Future<Directions?> getDirections({
    @required LatLng? origin,
    @required LatLng? destination,
  }) async {
    final rsp = await _dio.get(
      url,
      queryParameters: {
        'origin': '${origin!.latitude},${origin.longitude}',
        'destination': '${destination!.latitude},${destination.longitude}',
        'key': googleApiKey
      },
    );
    if (rsp.statusCode == 200) {
      return Directions.fromMap(rsp.data);
    }
    return null;
  }
}
