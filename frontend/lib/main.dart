import 'package:flutter/material.dart';
import 'package:frontend/models/journey.dart';
import 'package:frontend/models/settings.dart';
import 'package:frontend/models/trip.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/views/custom_settings_views/security_view.dart';
import 'package:frontend/views/custom_settings_views/theme_view.dart';
import 'package:frontend/views/home_view.dart';
import 'package:frontend/views/login_view.dart';

import 'package:frontend/views/maps_views/add_trip_view.dart';
import 'package:frontend/views/maps_views/current_trip_view.dart';
import 'package:frontend/views/maps_views/modify_trip.dart';
import 'package:frontend/views/maps_views/principal_page_view.dart';

import 'package:frontend/views/profile_view.dart';

import 'package:frontend/views/settings_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.blue),
        //home: AddTrip());
        // home: ModifyPage(
        //   journey: jj,
        // ));
        //  home: LoginForm());
        home: HomePage(
            user: User(
                id: 1,
                first_name: "Ariana",
                last_name: "Campean",
                email: "djnfk")));

    // home: HomePage(
    //     user: User(
    //         first_name: "Arinaa",
    //         last_name: "Cmapena",
    //         email: "kdmkjc@yahoo.com")));
  }
}
