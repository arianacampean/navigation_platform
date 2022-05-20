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
import 'package:frontend/views/custom_settings_views/security_view.dart';
import 'package:frontend/views/maps_views/add_trip_view.dart';
import 'package:frontend/views/maps_views/history_view.dart';
import 'package:frontend/views/profile_view.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../recommendations_view.dart';
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
  late LatLng currentPostion;
  late double alt;
  Placemark placemark =
      Placemark(street: "", locality: "", administrativeArea: "", country: "");
  int _selectedIndex = 0;
  int place = 0;

  // late Color col_background;
  // late Color buttons_col;
  // late Color color_border;
  // late Color text_color;

  @override
  void initState() {
    super.initState();
    getCoordonates();
    repo = Repo.repo;
    ex = Exceptie.ex;

    appRepository = AppRepository(repo);

    getData();
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
    if (place == 1) {
      setState(() => isLoading = false);
    }
  }

  getCoordonates() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    var position = await GeolocatorPlatform.instance.getCurrentPosition();

    setState(() {
      log("sunt in setState");
      currentPostion = LatLng(position.latitude, position.longitude);
      alt = position.altitude;
      if (trips.length != 0) {
        setState(() => isLoading = false);
      }
    });
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          currentPostion.latitude, currentPostion.longitude);
      setState(() {
        placemark = placemarks[1];
        place = 1;
      });
    } catch (_) {
      log("coord nu s-au putut gasi");
      setState(() => isLoading = false);
    }
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
            ? CircularProgressIndicator(
                backgroundColor: Color.fromRGBO(221, 209, 199, 1),
              )
            : Container(
                // padding: EdgeInsets.fromLTRB(3, 0, 3, 0),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(75, 74, 103, 1),
                ),
                child: ListView(
                  children: [
                    // SizedBox(
                    //   height: SizeConfig.screenHeight! * 0.15,
                    // ),
                    Container(
                      height: SizeConfig.screenHeight! * 0.35,
                      //  margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(75, 74, 103, 1),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/images/map.png'),
                            colorFilter: ColorFilter.mode(
                              Colors.white.withOpacity(0.12),
                              BlendMode.modulate,
                            )),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Current position:",
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Color.fromRGBO(221, 209, 199, 1)),
                            ),
                            Divider(
                              color: Color.fromRGBO(221, 209, 199, 1),
                              height: 10,
                              thickness: 1,
                              indent: SizeConfig.screenWidth! * 0.38,
                              endIndent: SizeConfig.screenWidth! * 0.38,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Adress: " +
                                  placemark.street! +
                                  ", " +
                                  placemark.locality! +
                                  ", " +
                                  placemark.administrativeArea! +
                                  ", " +
                                  placemark.country!,
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Color.fromRGBO(221, 209, 199, 1)),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Latitude: " +
                                      currentPostion.latitude.toString(),
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: Color.fromRGBO(221, 209, 199, 1)),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "Longitude: " +
                                      currentPostion.longitude.toString(),
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: Color.fromRGBO(221, 209, 199, 1)),
                                ),
                              ],
                            ),
                            // Divider(
                            //   color: Color.fromRGBO(221, 209, 199, 1),
                            //   height: 10,
                            //   thickness: 1,
                            //   indent: SizeConfig.screenWidth! * 0.09,
                            //   endIndent: SizeConfig.screenWidth! * 0.09,
                            // ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Altitude: " + alt.toString(),
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Color.fromRGBO(221, 209, 199, 1)),
                            ),
                            // Divider(
                            //   color: Color.fromRGBO(221, 209, 199, 1),
                            //   height: 10,
                            //   thickness: 1,
                            //   indent: SizeConfig.screenWidth! * 0.35,
                            //   endIndent: SizeConfig.screenWidth! * 0.35,
                            // ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Current date: " + DateTime.now().toString(),
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Color.fromRGBO(221, 209, 199, 1)),
                            ),
                            Divider(
                              color: Color.fromRGBO(221, 209, 199, 1),
                              height: 10,
                              thickness: 1,
                              indent: SizeConfig.screenWidth! * 0.2,
                              endIndent: SizeConfig.screenWidth! * 0.2,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "My Trips",
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Color.fromRGBO(221, 209, 199, 1)),
                            ),
                            Divider(
                              color: Color.fromRGBO(221, 209, 199, 1),
                              height: 10,
                              thickness: 1,
                              indent: SizeConfig.screenWidth! * 0.43,
                              endIndent: SizeConfig.screenWidth! * 0.43,
                            ),
                          ],
                        ),
                      ),
                      alignment: Alignment.centerLeft,
                    ),

                    Container(
                      height: SizeConfig.screenHeight! * 0.45,
                      decoration: BoxDecoration(
                        //color: Color.fromRGBO(221, 209, 199, 1),
                        color: Color.fromRGBO(221, 209, 199, 1),
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        border: Border.all(
                          //color: Color.fromRGBO(126, 137, 135, 1),
                          color: Color.fromRGBO(194, 207, 178, 1),
                          width: 2,
                        ),

                        //  ),

                        // borderRadius: BorderRadius.circular(10),
                      ),
                      // decoration: BoxDecoration(
                      //   boxShadow: [
                      //     BoxShadow(
                      //         color: Colors.black26,
                      //         offset: Offset(0, 4),
                      //         blurRadius: 5.0)
                      //   ],
                      //   gradient: LinearGradient(
                      //     begin: Alignment.bottomRight,
                      //     end: Alignment.topCenter,
                      //     stops: [0.7, 2.0],
                      //     colors: [
                      //       Color.fromRGBO(221, 209, 199, 1),
                      //       //  Colors.red,
                      //       //   Color.fromRGBO(126, 137, 135, 1),
                      //       Color.fromRGBO(194, 207, 178, 10),
                      //     ],
                      //   ),
                      // color: Colors.deepPurple.shade300,
                      // borderRadius: BorderRadius.circular(50),
                      //  ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // SizedBox(
                          //   height: SizeConfig.screenHeight! * 0.05,
                          // ),
                          //Wrap(alignment: WrapAlignment.center, children: [
                          // SizedBox(width: SizeConfig.screenWidth! * 0.02),
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
                              child: Container(
                                alignment: Alignment.center,
                                width: SizeConfig.screenWidth! * 0.9,
                                height: SizeConfig.screenHeight! * 0.09,
                                //  padding: EdgeInsets.fromLTRB(3, 0, 3, 3),
                                child: Text(
                                  "Current trip",
                                  style: TextStyle(
                                      color: Color.fromRGBO(221, 209, 199, 1),
                                      fontSize:
                                          SizeConfig.screenHeight! * 0.022),
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                  primary: Color.fromRGBO(75, 74, 103, 1),
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(50)))),
                          // SizedBox(width: SizeConfig.screenWidth! * 0.02),
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
                                    List<Trip>? t =
                                        await getTripsByJourney(currentJourney);
                                    log(t!.length.toString());
                                    setState(() {
                                      trips = t;
                                    });
                                  }
                                } catch (_) {
                                  log("nu s a adaugat nimic");
                                }
                              },
                              child: Container(
                                  alignment: Alignment.center,
                                  width: SizeConfig.screenWidth! * 0.9,
                                  height: SizeConfig.screenHeight! * 0.09,
                                  padding: EdgeInsets.fromLTRB(3, 0, 3, 3),
                                  child: Text(
                                    "Add a new trip",
                                    style: TextStyle(
                                        color: Color.fromRGBO(221, 209, 199, 1),
                                        fontSize:
                                            SizeConfig.screenHeight! * 0.022),
                                  )),
                              style: ElevatedButton.styleFrom(
                                  elevation: 10,
                                  primary: Color.fromRGBO(75, 74, 103, 1),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(50)))),
                          Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(0, 4),
                                    blurRadius: 5.0)
                              ],
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                stops: [0.4, 1.0],
                                colors: [
                                  Color.fromRGBO(75, 74, 103, 1),
                                  //   Color.fromRGBO(126, 137, 135, 1),
                                  Color.fromRGBO(141, 181, 128, 1),
                                ],
                              ),
                              // color: Colors.deepPurple.shade300,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: ElevatedButton(
                              onPressed: () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HistoryPage(
                                              user: widget.user,
                                            )));
                              },
                              child: Container(
                                  alignment: Alignment.center,
                                  width: SizeConfig.screenWidth! * 0.9,
                                  height: SizeConfig.screenHeight! * 0.09,
                                  padding: EdgeInsets.fromLTRB(3, 0, 3, 3),
                                  child: Text(
                                    "Past and next destinations",
                                    style: TextStyle(
                                        color: Color.fromRGBO(221, 209, 199, 1),
                                        fontSize:
                                            SizeConfig.screenHeight! * 0.022),
                                  )),
                              style: ButtonStyle(
                                //  elevation: 10,
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                ),
                                minimumSize: MaterialStateProperty.all(Size(
                                  SizeConfig.screenWidth! * 0.9,
                                  SizeConfig.screenHeight! * 0.09,
                                )),
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.transparent),
                                // elevation: MaterialStateProperty.all(3),
                                shadowColor: MaterialStateProperty.all(
                                    Colors.transparent),
                              ),
                            ),
                          ),

                          //  );
                          /////////butoane
                          ///
                          ///

                          // ElevatedButton(
                          //     onPressed: () async {
                          //       try {
                          //         Journey jj = await Navigator.push(
                          //             context,
                          //             MaterialPageRoute(
                          //                 builder: (context) => AddTrip(
                          //                       user: widget.user,
                          //                       index: 0,
                          //                     )));
                          //         if (jj.start_date.isBefore(currentdate) &&
                          //             jj.end_date.isAfter(currentdate)) {
                          //           setState(() {
                          //             currentJourney = jj;
                          //           });
                          //           List<Trip>? t =
                          //               await getTripsByJourney(currentJourney);
                          //           log(t!.length.toString());
                          //           setState(() {
                          //             trips = t;
                          //           });
                          //         }
                          //       } catch (_) {
                          //         log("nu s a adaugat nimic");
                          //       }
                          //     },
                          //     child: Wrap(
                          //         // width: SizeConfig.screenWidth! * 0.1,
                          //         // height: SizeConfig.screenHeight! * 0.1,
                          //         children: [
                          //           Container(
                          //             padding: EdgeInsets.all(10),
                          //             width: SizeConfig.screenWidth! * 0.55,
                          //             height: SizeConfig.screenHeight! * 0.08,
                          //             // child: Image.asset(
                          //             //     'assets/images/add.png')
                          //           ),
                          //           Container(
                          //               padding:
                          //                   EdgeInsets.fromLTRB(3, 0, 3, 3),
                          //               child: Text(
                          //                 "Add a new trip",
                          //                 style: TextStyle(
                          //                     color: Colors.black,
                          //                     fontSize:
                          //                         SizeConfig.screenHeight! *
                          //                             0.018),
                          //               )),
                          //         ]),
                          //     style: ElevatedButton.styleFrom(
                          //         primary: Color.fromRGBO(0, 115, 255, 150),
                          //         shape: RoundedRectangleBorder(
                          //             borderRadius:
                          //                 BorderRadius.circular(40)))),
                          // SizedBox(width: SizeConfig.screenWidth! * 0.02),
                          // //  height: SizeConfig.screenHeight! * 0.08,
                          // // ]
                          // //),
                          // Container(
                          //   padding: EdgeInsets.all(20),
                          //   width: SizeConfig.screenWidth! * 0.85,
                          //   child: ElevatedButton(
                          //       onPressed: () {
                          //         Navigator.push(
                          //             context,
                          //             MaterialPageRoute(
                          //                 builder: (context) => HistoryPage(
                          //                       user: widget.user,
                          //                     )));
                          //       },
                          //       child: Wrap(
                          //           // width: SizeConfig.screenWidth! * 0.1,
                          //           // height: SizeConfig.screenHeight! * 0.1,
                          //           children: [
                          //             Container(
                          //                 padding: EdgeInsets.all(10),
                          //                 width: SizeConfig.screenWidth! * 0.55,
                          //                 height:
                          //                     SizeConfig.screenHeight! * 0.08,
                          //                 child: Image.asset(
                          //                     'assets/images/history.png')),
                          //             Container(
                          //                 padding:
                          //                     EdgeInsets.fromLTRB(3, 0, 3, 3),
                          //                 child: Text(
                          //                   "All trips",
                          //                   style: TextStyle(
                          //                       color: Colors.black,
                          //                       fontSize:
                          //                           SizeConfig.screenHeight! *
                          //                               0.018),
                          //                 )),
                          //           ]),
                          //       style: ElevatedButton.styleFrom(
                          //           primary: Colors.grey,
                          //           shape: RoundedRectangleBorder(
                          //               borderRadius:
                          //                   BorderRadius.circular(40)))),

                          //  ),
                        ],
                      ),
                    ),
                  ],
                ),
                // ),
              ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromRGBO(141, 181, 128, 1),
        // type: BottomNavigationBarType.shifting,
        // selectedFontSize: 20,
        // selectedIconTheme: IconThemeData(
        //   color: Color.fromRGBO(75, 74, 103, 1),
        // ),
        currentIndex: _selectedIndex, //New
        onTap: _onItemTapped,
        unselectedItemColor: Color.fromRGBO(75, 74, 103, 1),
        selectedItemColor: Color.fromRGBO(103, 112, 110, 1),
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.recommend),
            label: 'Recommendations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.supervised_user_circle),
            label: 'Profile',
            // backgroundColor: Color.fromRGBO(194, 207, 178, 1),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.security),
            label: 'Security',
            //backgroundColor: Color.fromRGBO(194, 207, 178, 1),
          ),
        ],
        iconSize: 60,
        //  selectedItemColor: Color.fromRGBO(141, 181, 128, 1),
      ),
    );
  }

  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });
    if (_selectedIndex == 0) {
      try {
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RecommendationsPage(
                      user: widget.user,
                    )));
      } catch (_) {
        log("err la nav recom");
      }
    }
    if (_selectedIndex == 1) {
      try {
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfilePage(
                      user: widget.user,
                    )));
        setState(() {
          // settings = setting;
          // getSettings();
        });
      } catch (_) {
        log(_.toString());
        log("er la nav profile");
      }
    }
    if (_selectedIndex == 2) {
      try {
        Settings setting = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SecurityPage(user: widget.user)));
        setState(() {
          settings = setting;
          // getSettings();
        });
      } catch (_) {
        log(_.toString());
      }
    }
    log(_selectedIndex.toString());
  }
}
