import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:frontend/apis/api_client.dart';
import 'package:frontend/models/journey.dart';
import 'package:frontend/models/settings.dart';
import 'package:frontend/models/trip.dart';
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
      log(_.toString());
      //log('exceptie update ');
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

  Future<Journey> addJouney(Journey jn, List<Trip> trips) async {
    log('add jouney');
    final client = _apiRequest;
    try {
      Journey new_jn = await client.addJourney(jn);
      for (int i = 0; i < trips.length; i++) {
        trips[i].id_journey = new_jn.id;

        await client.addTrip(trips[i]);
      }
      return new_jn;
    } catch (_) {
      log(_.toString());
      // log('exceptie add ');
      rethrow;
    }
  }

  Future<List<Trip>> addTrips(List<Trip> trips) async {
    log('add jouney');
    final client = _apiRequest;
    List<Trip> tr = [];
    try {
      for (int i = 0; i < trips.length; i++) {
        Trip t = await client.addTrip(trips[i]);
        tr.add(t);
      }
      return tr;
    } catch (_) {
      log(_.toString());
      // log('exceptie add ');
      rethrow;
    }
  }

  Future<List<Trip>> getallTrips() async {
    final client = _apiRequest;

    try {
      List<Trip> tr = await client.getAllTrips();

      return tr;
    } catch (_) {
      log(_.toString());
      // log('exceptie add ');
      rethrow;
    }
  }

  Future<List<Trip>> getTripsByJouneyId(Journey j) async {
    log('get_trips by j id');
    final client = _apiRequest;
    try {
      List<Trip> trips = await client.getTripsByJourney(j.id!);

      log(trips[0].city);
      return trips;
    } catch (_) {
      log(_.toString());
      //log('exceptie update ');
      rethrow;
    }
  }

  Future updateTrips(List<Trip> trips) async {
    log('update app_repo');
    final client = _apiRequest;
    try {
      for (int i = 0; i < trips.length; i++) {
        await client.updateTrip(trips[i].id!, trips[i]);
      }
    } catch (_) {
      log('exceptie update ');
      rethrow;
    }
  }

  Future updateTrip(Trip trips) async {
    log('update app_repo');
    final client = _apiRequest;
    try {
      await client.updateTrip(trips.id!, trips);
    } catch (_) {
      log('exceptie update ');
      rethrow;
    }
  }

  Future updateJouneyandTrips(Journey j, List<Trip> trips) async {
    log('update app_repo');
    final client = _apiRequest;
    try {
      for (int i = 0; i < trips.length; i++) {
        await client.updateTrip(trips[i].id!, trips[i]);
      }
      await client.updateJouney(j.id!, j);
    } catch (_) {
      log('exceptie update ');
      rethrow;
    }
  }

  //pentru istoric
  Future<List<Journey>> getJouneysByUserId(User u) async {
    log('get_one app_repo');
    final client = _apiRequest;
    try {
      List<Journey> trips = await client.getJourneysByUserId(u.id!);
      return trips;
    } catch (_) {
      log(_.toString());
      //log('exceptie update ');
      rethrow;
    }
  }

  Future<List<Journey>> getJouneys() async {
    log('get_one app_repo');
    final client = _apiRequest;
    try {
      List<Journey> trips = await client.getAllJourneys();
      return trips;
    } catch (_) {
      log(_.toString());
      //log('exceptie update ');
      rethrow;
    }
  }

  Future deleteTrip(int id) async {
    log('stergere app_repo');
    final client = _apiRequest;
    try {
      await client.deleteTrip(id);
    } catch (_) {
      log('exceptie stergere');
      rethrow;
    }
  }

  Future deleteTrips(List<Trip> tr) async {
    log('stergere app_repo');
    final client = _apiRequest;
    try {
      for (int i = 0; i < tr.length; i++) {
        await client.deleteTrip(tr[i].id!);
      }
    } catch (_) {
      log('exceptie stergere');
      rethrow;
    }
  }

  Future deleteJourney(int id) async {
    log('stergere app_repo');
    final client = _apiRequest;
    try {
      await client.deleteJouney(id);
    } catch (_) {
      log('exceptie stergere');
      rethrow;
    }
  }

  Future deleteJourneyandTrips(List<Trip> trips, Journey j) async {
    log('stergere app_repo');
    final client = _apiRequest;
    try {
      for (int i = 0; i < trips.length; i++) {
        await client.deleteTrip(trips[i].id!);
      }
      await client.deleteJouney(j.id!);
    } catch (_) {
      log(_.toString());
      log('exceptie stergere');
      rethrow;
    }
  }

  //pentru recomandari
  Future<List<Trip>> getTripsByCountry(String city) async {
    log('get_one app_repo');
    final client = _apiRequest;
    try {
      List<Trip> trips = await client.getTripsByCountry(city);
      return trips;
    } catch (_) {
      log(_.toString());
      //log('exceptie update ');
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
