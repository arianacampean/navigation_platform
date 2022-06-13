import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:frontend/apis/api_client.dart';
import 'package:frontend/models/journey.dart';

import 'package:frontend/models/trip.dart';
import 'package:frontend/models/user.dart';

class AppRepository {
  late ApiClient _apiRequest;
  late Dio dio;

  AppRepository() {
    dio = Dio(BaseOptions(contentType: "application/json"));
    _apiRequest = ApiClient(dio);
  }

  //luarea unui singur user in functie de email
  Future<List<User>> getOneUser(String email) async {
    log('get_one app_repo');
    final client = _apiRequest;
    try {
      List<User> user = await client.getOneUser(email);
      log(user[0].password!);
      return user;
    } catch (_) {
      log(_.toString());
      log("error getOneUser");
      rethrow;
    }
  }

  //adaugare de utilizator
  Future addUser(User user) async {
    log('addUser app_repo');
    final client = _apiRequest;
    try {
      await client.addUser(user);
    } catch (_) {
      log(_.toString());
      log("error addUser");
      rethrow;
    }
  }

  //actualizarea utilizatorului
  Future updateUser(User user) async {
    log('updateUser app_repo');
    final client = _apiRequest;
    try {
      await client.updateUser(user.id!, user);
    } catch (_) {
      log(_.toString());
      log("error updateUser");
      rethrow;
    }
  }

  //adaugare de jouney-uri
  Future<Journey> addJouney(Journey jn, List<Trip> trips) async {
    log('add jouney app repo');
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
      log("error addJouney");
      rethrow;
    }
  }

  //adaugare de trip-uri
  Future<List<Trip>> addTrips(List<Trip> trips) async {
    log('add trips app repo');
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
      log("error addTrips");
      rethrow;
    }
  }

  //luarea tuturor trip-urilor
  Future<List<Trip>> getallTrips() async {
    log('getAllTrips app repo');
    final client = _apiRequest;
    try {
      List<Trip> tr = await client.getAllTrips();

      return tr;
    } catch (_) {
      log(_.toString());
      log("error getallTrips()");
      rethrow;
    }
  }

  //uare de trip uri in functie de id ul jouney ului
  Future<List<Trip>> getTripsByJouneyId(Journey j) async {
    log('getTripsByJouneyId app repo');
    final client = _apiRequest;
    try {
      List<Trip> trips = await client.getTripsByJourney(j.id!);

      return trips;
    } catch (_) {
      log(_.toString());
      log("error getTripsByJouneyId");
      rethrow;
    }
  }

  //actiualizare lista trip uri
  Future updateTrips(List<Trip> trips) async {
    log('updateTrips app_repo');
    final client = _apiRequest;
    try {
      for (int i = 0; i < trips.length; i++) {
        await client.updateTrip(trips[i].id!, trips[i]);
      }
    } catch (_) {
      log("error updateTrips");
      rethrow;
    }
  }

  //actualizare de trip
  Future updateTrip(Trip trips) async {
    log('updateTrips app_repo');
    final client = _apiRequest;
    try {
      await client.updateTrip(trips.id!, trips);
    } catch (_) {
      log("error updateTrip");
      rethrow;
    }
  }

  //actualizare lista tripuri si journey uri
  Future updateJouneyandTrips(Journey j, List<Trip> trips) async {
    log('updateJouneyandTrips app_repo');
    final client = _apiRequest;
    try {
      for (int i = 0; i < trips.length; i++) {
        await client.updateTrip(trips[i].id!, trips[i]);
      }
      await client.updateJouney(j.id!, j);
    } catch (_) {
      log("error updateTrips");
      rethrow;
    }
  }

  //luarea journy-lor in functe de id userului
  Future<List<Journey>> getJouneysByUserId(User u) async {
    log('getJouneysByUserId app_repo');
    final client = _apiRequest;
    try {
      List<Journey> trips = await client.getJourneysByUserId(u.id!);
      return trips;
    } catch (_) {
      log(_.toString());
      log("error getJouneysByUserId");
      rethrow;
    }
  }

  // luarea tuturor journey lor
  Future<List<Journey>> getJouneys() async {
    log('getJouneys( app_repo');
    final client = _apiRequest;
    try {
      List<Journey> trips = await client.getAllJourneys();
      return trips;
    } catch (_) {
      log(_.toString());
      log('error  getJouneys()');
      rethrow;
    }
  }

  // stergerea unui singur trip
  Future deleteTrip(int id) async {
    log('deleteTrip app_repo');
    final client = _apiRequest;
    try {
      await client.deleteTrip(id);
    } catch (_) {
      log('error  deleteTri');
      rethrow;
    }
  }

  // stergerea unei liste de trip uri
  Future deleteTrips(List<Trip> tr) async {
    log('deleteTrips app_repo');
    final client = _apiRequest;
    try {
      for (int i = 0; i < tr.length; i++) {
        await client.deleteTrip(tr[i].id!);
      }
    } catch (_) {
      log('error  deleteTrips');
      rethrow;
    }
  }

  // stergerea unui journey
  Future deleteJourney(int id) async {
    log('deleteJourney app_repo');
    final client = _apiRequest;
    try {
      await client.deleteJouney(id);
    } catch (_) {
      log('error  deleteJourney');
      rethrow;
    }
  }

  // stergerea calatoriei
  Future deleteJourneyandTrips(List<Trip> trips, Journey j) async {
    log('deleteJourneyandTrips app_repo');
    final client = _apiRequest;
    try {
      for (int i = 0; i < trips.length; i++) {
        await client.deleteTrip(trips[i].id!);
      }
      await client.deleteJouney(j.id!);
    } catch (_) {
      log(_.toString());
      log('error  deleteJourneyandTrips');
      rethrow;
    }
  }
}
