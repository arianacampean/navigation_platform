import 'package:flutter/material.dart';
import 'package:frontend/models/settings.dart';
import 'package:frontend/models/trip.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/views/custom_settings_views/security_view.dart';
import 'package:frontend/views/custom_settings_views/theme_view.dart';
import 'package:frontend/views/home_view.dart';
import 'package:frontend/views/login_view.dart';
import 'package:frontend/views/map_test.dart';
import 'package:frontend/views/maps_views/add_trip_view.dart';
import 'package:frontend/views/maps_views/current_trip_view.dart';
import 'package:frontend/views/maps_views/modify_trip.dart';
import 'package:frontend/views/maps_views/principal_page_view.dart';
import 'package:frontend/views/profile_view.dart';
import 'package:frontend/views/search_test.dart';
import 'package:frontend/views/settings_view.dart';

import 'package:frontend/views/test_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Trip t1 = Trip(
        latitude: 45.3570,
        longitude: 23.2132,
        city: 'Lupeni',
        country: 'Romania',
        name: 'lupeni,ro',
        visited: false);
    Trip t2 = Trip(
        latitude: 44.4268,
        longitude: 26.1025,
        city: 'Bucuresti',
        country: 'Romania',
        name: 'Bucuresti,B,Ro',
        visited: false);
    Trip t3 = Trip(
        latitude: 45.7489,
        longitude: 21.2087,
        city: 'Timisoara',
        country: 'Romania',
        name: 'Timisoara,TM,Roamnia',
        visited: false);
    Trip t4 = Trip(
        latitude: 53.4808,
        longitude: 2.2426,
        city: 'Sibiu',
        country: 'Romania',
        name: 'Sibiu,sb,Romania',
        visited: true);
    List<Trip> trips = [];
    Trip t5 = Trip(
        latitude: 46.7422,
        longitude: 23.4840,
        city: 'Floresti',
        country: 'Romania',
        name: 'Floresti,Romania',
        visited: false);
    trips.add(t1);
    trips.add(t2);
    trips.add(t4);
    trips.add(t5);
    trips.add(t3);
    trips.add(t4);
    trips.add(t5);
    trips.add(t3);

    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.blue),
        //home: AddTrip());
        home: ModifyPage(trips: trips));

    // home: ProfilePage(
    //     settings: Settings(id_user: 0, theme: "light"),
    //     user: User(
    //         first_name: "Arinaa",
    //         last_name: "Cmapena",
    //         email: "kdmkjc@yahoo.com")));
  }
}
