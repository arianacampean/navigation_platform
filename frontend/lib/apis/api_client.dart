import 'package:dio/dio.dart';
import 'package:frontend/models/settings.dart';
import 'package:frontend/models/user.dart';

import 'package:retrofit/http.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: "http://127.0.0.1:8000/api/")
abstract class ApiClient {
  factory ApiClient(Dio dio, {String? baseUrl}) = _ApiClient;

  @GET("/user")
  Future<List<User>> getAllUsers();

  @POST("/user")
  Future<User> addUser(@Body() User dr);

  @GET("/user/{email}")
  Future<List<User>> getOneUser(@Path("email") String email);

  @GET("/user/settings/{id_user}")
  Future<List<Settings>> getSettingsForUser(@Path("id_user") int id_user);
}
