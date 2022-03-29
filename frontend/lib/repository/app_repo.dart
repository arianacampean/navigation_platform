import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:frontend/apis/api_client.dart';
import 'package:frontend/models/settings.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/repository/repo.dart';

class AppRepository {
  late ApiClient _apiRequest;
  late Dio dio;
  late Repo repo;

  AppRepository(Repo repo) {
    this.repo = repo;
    dio = Dio(BaseOptions(contentType: "application/json"));
    _apiRequest = ApiClient(dio);
  }

  Future<List<User>> getOneUser(String email) async {
    log('get_one app_repo');
    final client = _apiRequest;
    try {
      List<User> user = await client.getOneUser(email);
      log(user[0].password!);
      return user;
    } catch (_) {
      //log(_.toString());
      log('exceptie update ');
      rethrow;
    }
  }

  Future addUser(User user) async {
    log('get_one app_repo');
    final client = _apiRequest;
    try {
      await client.addUser(user);
    } catch (_) {
      //log(_.toString());
      log('exceptie add ');
      rethrow;
    }
  }

  Future<Settings> getSettingsForUser(int id) async {
    log('get_one app_repo');
    final client = _apiRequest;
    try {
      List<Settings> sett = await client.getSettingsForUser(id);
      //log(sett.theme);
      return sett[0];
    } catch (_) {
      //log(_.toString());
      log('exceptie get ');
      rethrow;
    }
  }
}
