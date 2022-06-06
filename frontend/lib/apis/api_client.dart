import 'package:dio/dio.dart';
import 'package:frontend/models/journey.dart';
import 'package:frontend/models/trip.dart';
import 'package:frontend/models/user.dart';

import 'package:retrofit/http.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: "http://192.168.8.112:8000/api/")
//@RestApi(baseUrl: "http://172.20.10.6:8000/api/")
abstract class ApiClient {
  factory ApiClient(Dio dio, {String? baseUrl}) = _ApiClient;

  @GET("/user")
  Future<List<User>> getAllUsers();

  @POST("/user")
  Future<User> addUser(@Body() User dr);

  @GET("/user/{email}")
  Future<List<User>> getOneUser(@Path("email") String email);

  @PUT("/user/pass/{pk}")
  Future<void> updateUser(@Path("pk") int pk, @Body() User user);
///////////////////////////////////////////////////////////
  @GET("/trip")
  Future<List<Trip>> getAllTrips();

  @POST("/trip")
  Future<Trip> addTrip(@Body() Trip dr);

  @GET("/trip/{pk}")
  Future<List<Trip>> getOneTripById(@Path("pk") int pk);

  @GET("/trip/{country}")
  Future<List<Trip>> getTripsByCountry(@Path("country") String country);

  @DELETE("/trip/{pk}")
  Future<void> deleteTrip(@Path("pk") int pk);

  @PUT("/trip/{pk}")
  Future<void> updateTrip(@Path("pk") int pk, @Body() Trip dr);

  @GET("/trip/journey/{id_trip}")
  Future<List<Trip>> getTripsByJourney(@Path("id_trip") int id_trip);

  ///////////////////////////////////////
  @GET("/journey")
  Future<List<Journey>> getAllJourneys();

  @POST("/journey")
  Future<Journey> addJourney(@Body() Journey dr);

  @GET("/journey/{pk}")
  Future<List<Journey>> getJourneysById(@Path("pk") int pk);

  @GET("/journey/user/{id_user}")
  Future<List<Journey>> getJourneysByUserId(@Path("id_user") int id_user);

  @DELETE("/journey/{pk}")
  Future<void> deleteJouney(@Path("pk") int pk);

  @PUT("/journey/{pk}")
  Future<void> updateJouney(@Path("pk") int pk, @Body() Journey dr);
}
