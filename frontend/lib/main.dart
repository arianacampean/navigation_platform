import 'package:flutter/material.dart';
import 'package:frontend/models/journey.dart';
import 'package:frontend/models/settings.dart';
import 'package:frontend/models/trip.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/views/custom_settings_views/security_view.dart';

import 'package:frontend/views/login_view.dart';

import 'package:frontend/views/maps_views/add_trip_view.dart';
import 'package:frontend/views/maps_views/current_trip_view.dart';
import 'package:frontend/views/maps_views/modify_trip.dart';
import 'package:frontend/views/maps_views/principal_page_view.dart';

import 'package:frontend/views/profile_view.dart';

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
        theme: ThemeData(
            //primarySwatch: Color.fromRGBO(75, 74, 103,1)
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: Color.fromRGBO(75, 74, 103, 1),
              onPrimary: Color.fromRGBO(221, 209, 199, 1),
              onBackground: Colors.green,
              onSecondary: Colors.blue,
              secondary: Color.fromRGBO(103, 112, 110, 1),
            ),
            scaffoldBackgroundColor: Color.fromRGBO(75, 74, 103, 1)),
        //verde inchis Color.fromRGBO(141, 181, 128, 1),
        //verde deschis  Color.fromRGBO( 194, 207, 178, 1)
        //home: Home());
        //home: AddTrip());
        // home: ModifyPage(
        //   journey: jj,
        // ));
        home: LoginForm());
    // home: PrincipalPage(
    //     user: User(
    //         id: 1,
    //         first_name: "Ariana",
    //         last_name: "Campean",
    //         email: "deborah_ariana@yahoo.com")));

    // home: SecurityPage(
    //     user: User(
    //         first_name: "Arinaa",
    //         last_name: "Campean",
    //         email: "kdmkjc@yahoo.com")));
  }
}
