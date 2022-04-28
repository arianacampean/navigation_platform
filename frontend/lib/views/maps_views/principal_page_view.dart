import 'dart:developer';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/exceptie.dart';
import 'package:frontend/models/journey.dart';
import 'package:frontend/models/settings.dart';
import 'package:frontend/models/sizeConf.dart';
import 'package:frontend/models/trip.dart';
import 'package:frontend/models/tripDate.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/repository/app_repo.dart';
import 'package:frontend/repository/repo.dart';
import 'package:frontend/views/maps_views/add_trip_view.dart';
import 'package:frontend/views/maps_views/history_view.dart';
import 'package:frontend/views/profile_view.dart';
import 'package:frontend/views/settings_view.dart';

import 'current_trip_view.dart';

class PrincipalPage extends StatefulWidget {
  User user;
  PrincipalPage({Key? key, required this.user}) : super(key: key);

  @override
  _PrincipalPageState createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {
  CarouselController buttonCarouselController = CarouselController();
  //late User user;
  late Exceptie ex;
  late Repo repo;
  late AppRepository appRepository;
  String goodCredentials = "";
  bool isLoading = false;
  late Settings settings;
  List<Journey> journeys = [];
  DateTime currentdate = DateTime.now();
  Journey currentJourney =
      Journey(start_date: DateTime(2019), end_date: DateTime(2019));
  List<Trip> trips = [];

  // late Color col_background;
  // late Color buttons_col;
  // late Color color_border;
  // late Color text_color;

  @override
  void initState() {
    super.initState();
    repo = Repo.repo;
    ex = Exceptie.ex;

    appRepository = AppRepository(repo);
    getData();

    // col_background = Colors.white;
    // buttons_col = Color.fromRGBO(159, 224, 172, 1);
    // color_border = Colors.white;
    // text_color = Colors.black;
    // getData();
  }

  Future getData() async {
    // log("iau datele de pe server pt prima pagina");
    setState(() => isLoading = true);
    try {
      journeys = await appRepository.getJouneysByUserId(widget.user);
      journeys.forEach((element) async {
        if (element.start_date.isBefore(currentdate) &&
                element.end_date.isAfter(currentdate) ||
            (element.start_date.day == currentdate.day &&
                element.start_date.month == currentdate.month &&
                element.start_date.year == currentdate.year) ||
            (element.end_date.day == currentdate.day &&
                element.end_date.month == currentdate.month &&
                element.end_date.year == currentdate.year)) {
          currentJourney = element;
          log("avem!!!!");
          trips = await appRepository.getTripsByJouneyId(currentJourney);
        }
      });
    } catch (_) {
      log(_.toString());

      //  exceptie.showAlertDialogExceptions(
      //context, "Eroare", "Nu se gasesc obiectele");
    }
    setState(() => isLoading = false);
  }

  Future<List<Trip>?> getTripsByJourney(Journey j) async {
    try {
      List<Trip> trip = await appRepository.getTripsByJouneyId(currentJourney);
      log("am luat tripurile");
      return trip;
    } catch (_) {
      log(_.toString());
      log("erare la getTripsBuJ");
    }
  }
  //dark theme

  // Color col_background = Color.fromRGBO(38, 41, 40, 1);
  // Color buttons_col = Color.fromRGBO(38, 41, 40, 1);
  // Color color_border = Colors.black;
  // Color text_color = Color.fromRGBO(159, 224, 172, 1);

  //light theme

  Color col_background = Colors.white;
  Color buttons_col = Color.fromRGBO(159, 224, 172, 1);
  Color color_border = Colors.white;
  Color text_color = Colors.black;

  //trebuie sa iei tabelul de setari si sa trimiti la celelalte-Userul,thema momentan
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("My Trips"),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : Container(
                // padding: EdgeInsets.fromLTRB(3, 0, 3, 0),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(159, 224, 172, 1),
                ),
                child: ListView(
                  children: [
                    // SizedBox(
                    //   height: SizeConfig.screenHeight! * 0.15,
                    // ),
                    Container(
                      height: SizeConfig.screenHeight! * 0.35,
                      margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "My Trips",
                            style: TextStyle(fontSize: 30),
                          ),
                          Divider(
                            color: Colors.black,
                            height: 25,
                            thickness: 2,
                            indent: SizeConfig.screenWidth! * 0.05,
                            endIndent: SizeConfig.screenWidth! * 0.05,
                          ),
                        ],
                      ),
                      alignment: Alignment.centerLeft,
                    ),

                    // SizedBox(
                    //   height: SizeConfig.screenHeight! * 0.18,
                    // ),
                    Container(
                      height: SizeConfig.screenHeight! * 0.6,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(50)),

                        //  borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // SizedBox(
                          //   height: SizeConfig.screenHeight! * 0.05,
                          // ),
                          Wrap(alignment: WrapAlignment.center, children: [
                            SizedBox(width: SizeConfig.screenWidth! * 0.02),
                            ElevatedButton(
                                onPressed: () async {
                                  try {
                                    log("sunt in pressed");
                                    log(trips.length.toString());
                                    if (currentJourney.start_date !=
                                        DateTime(2019)) {
                                      log("sint in if");
                                      List<TripDate> tr = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => CurrentTrip(
                                                    user: widget.user,
                                                    journey: currentJourney,
                                                    trips: trips,
                                                  )));
                                      if (tr.length == 0)
                                        setState(() {
                                          currentJourney = Journey(
                                              start_date: DateTime(2019),
                                              end_date: DateTime(2019));
                                          trips = [];
                                        });
                                      else {
                                        List<Trip> t = [];
                                        tr.forEach((element) {
                                          log("sunt in schimb de trips " +
                                              element.visited.toString());
                                          Trip tt = Trip(
                                              id: element.id,
                                              id_journey: element.id_journey,
                                              latitude: element.latitude!,
                                              longitude: element.longitude!,
                                              city: element.city!,
                                              country: element.country!,
                                              name: element.name!,
                                              visited: element.visited!);
                                          t.add(tt);
                                        });
                                        setState(() {
                                          log("sunt in setstae");
                                          trips = t;
                                          currentJourney.start_date =
                                              tr[0].start_date!;
                                          currentJourney.end_date =
                                              tr[0].end_date!;
                                        });
                                      }
                                    }
                                    if (currentJourney.start_date ==
                                        DateTime(2019))
                                      ex.showAlertDialogExceptions(
                                          context,
                                          "Informations",
                                          "You dont have an existing trip at the moment");
                                  } catch (_) {
                                    log("erare la primit din curent");
                                  }
                                },
                                child: Column(
                                    // width: SizeConfig.screenWidth! * 0.1,
                                    // height: SizeConfig.screenHeight! * 0.1,
                                    children: [
                                      Container(
                                          padding: EdgeInsets.all(10),
                                          width: SizeConfig.screenWidth! * 0.35,
                                          height:
                                              SizeConfig.screenHeight! * 0.15,
                                          child: Image.asset(
                                              'assets/images/gps.png')),
                                      Container(
                                          padding:
                                              EdgeInsets.fromLTRB(3, 0, 3, 3),
                                          child: Text(
                                            "Current trip",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize:
                                                    SizeConfig.screenHeight! *
                                                        0.018),
                                          )),
                                    ]),
                                style: ElevatedButton.styleFrom(
                                    primary: Color.fromRGBO(0, 115, 255, 100),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(0)))),
                            SizedBox(width: SizeConfig.screenWidth! * 0.02),
                            // SizedBox(width: SizeConfig.screenWidth! * 0.01),
                            ElevatedButton(
                                onPressed: () async {
                                  try {
                                    Journey jj = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AddTrip(
                                                  user: widget.user,
                                                  index: 0,
                                                )));
                                    if (jj.start_date.isBefore(currentdate) &&
                                        jj.end_date.isAfter(currentdate)) {
                                      setState(() {
                                        currentJourney = jj;
                                      });
                                      List<Trip>? t = await getTripsByJourney(
                                          currentJourney);
                                      log(t!.length.toString());
                                      setState(() {
                                        trips = t;
                                      });
                                    }
                                  } catch (_) {
                                    log("nu s a adaugat nimic");
                                  }
                                },
                                child: Column(
                                    // width: SizeConfig.screenWidth! * 0.1,
                                    // height: SizeConfig.screenHeight! * 0.1,
                                    children: [
                                      Container(
                                          padding: EdgeInsets.all(10),
                                          width: SizeConfig.screenWidth! * 0.35,
                                          height:
                                              SizeConfig.screenHeight! * 0.15,
                                          child: Image.asset(
                                              'assets/images/add.png')),
                                      Container(
                                          padding:
                                              EdgeInsets.fromLTRB(3, 0, 3, 3),
                                          child: Text(
                                            "Add a new trip",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize:
                                                    SizeConfig.screenHeight! *
                                                        0.018),
                                          )),
                                    ]),
                                style: ElevatedButton.styleFrom(
                                    primary: Color.fromRGBO(0, 115, 255, 150),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(0)))),
                            SizedBox(width: SizeConfig.screenWidth! * 0.02)
                            //  height: SizeConfig.screenHeight! * 0.08,
                          ]),
                          Container(
                            padding: EdgeInsets.all(20),
                            width: SizeConfig.screenWidth! * 0.85,
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HistoryPage(
                                                user: widget.user,
                                              )));
                                },
                                child: Column(
                                    // width: SizeConfig.screenWidth! * 0.1,
                                    // height: SizeConfig.screenHeight! * 0.1,
                                    children: [
                                      Container(
                                          padding: EdgeInsets.all(10),
                                          width: SizeConfig.screenWidth! * 0.35,
                                          height:
                                              SizeConfig.screenHeight! * 0.15,
                                          child: Image.asset(
                                              'assets/images/history.png')),
                                      Container(
                                          padding:
                                              EdgeInsets.fromLTRB(3, 0, 3, 3),
                                          child: Text(
                                            "All trips",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize:
                                                    SizeConfig.screenHeight! *
                                                        0.018),
                                          )),
                                    ]),
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.grey,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(0)))),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
