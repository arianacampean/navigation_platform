import 'dart:developer' as dev;
import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/models/directions.dart';
import 'package:frontend/models/exceptie.dart';
import 'package:frontend/models/journey.dart';
import 'package:frontend/models/sizeConf.dart';
import 'package:frontend/models/trip.dart';
import 'package:frontend/models/tripDate.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/repository/app_repo.dart';
import 'package:frontend/repository/direction_repo.dart';

import 'package:frontend/views/maps_views/modify_trip.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:frontend/texts/text.dart' as text;
import 'package:location/location.dart';

class CurrentTrip extends StatefulWidget {
  User user;
  Journey journey;
  List<Trip> trips;
  CurrentTrip(
      {Key? key,
      required this.user,
      required this.journey,
      required this.trips})
      : super(key: key);

  @override
  _CurrentTripState createState() => _CurrentTripState();
}

class _CurrentTripState extends State<CurrentTrip> {
  bool isLoading = true;

  late AppRepository appRepository;
  late LatLng currentPostion;
  late GoogleMapController _controller;
  late Marker current_poz;
  late Marker destination;
  bool firstMesage = true;
  List<TripDate> tripdate = [];
  bool arrivedAtDestination = false;
  Map<int, int> order = {};
  late Timer _timer;
  // List<Trip> trips = [];
  late Trip trip = Trip(
      latitude: 0,
      longitude: 0,
      city: "",
      country: "",
      name: "",
      visited: false);
  LatLng coord = LatLng(46.7422, 23.4840);
  late Directions directions;
  late Exceptie ex;
  int index = 0;
  bool readToStart = false;
  Location _location = Location();
  late LatLng finalPosition;
  late Timer timer;
  bool stopEntering = false;
  late String mapStyle;
  bool stop = false;

  @override
  void initState() {
    super.initState();
    isLoading = true;

    ex = Exceptie.ex;

    appRepository = AppRepository();

    _getUserLocation();

    try {
      _arrived();
      startTimer();
    } catch (_) {
      dev.log("functia mai merge");
    }
  }

  void _arrived() {
    if (firstMesage == false && arrivedAtDestination == false) {
      dev.log("calculez");
      var loc;
      // _location.onLocationChanged.
      loc = _location.onLocationChanged.listen((l) async {
        try {
          setState(() {
            var current = LatLng(l.latitude!, l.longitude!);
            if (current.latitude != currentPostion.latitude ||
                current.longitude != currentPostion.longitude)
              currentPostion = current;
          });
          var dir = await DirectionsRepo().getDirections(
              origin: currentPostion, destination: finalPosition);
          // log("prima" + dir!.totalDuration);
          setState(() {
            directions = dir!;
          });
        } catch (_) {
          dev.log("fct merge");
          loc.cancel();
        }
      });
      // double nr = getDistanceFromLatLonInKm(currentPostion, finalPosition);
      // if (nr <= 20) {
      //   dev.log("da");
      //   setState(() {
      //     if (stopEntering == false) arrivedAtDestination = true;
      //   });
      // } else
      //   dev.log("nu");
    }
  }

  void userAtDestination() {
    double nr = getDistanceFromLatLonInKm(currentPostion, finalPosition);
    if (nr <= 20) {
      dev.log("da");
      setState(() {
        if (stopEntering == false) arrivedAtDestination = true;
      });
    } else
      dev.log("nu");
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 30);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (stop == true) {
          // timer.cancel();
          dev.log("te-am oprit");
          //});
        } else {
          userAtDestination();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    SizeConfig().init(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Route'),
          centerTitle: false,
          actions: [
            TextButton(
                onPressed: () =>
                    _controller.animateCamera(CameraUpdate.newCameraPosition(
                      CameraPosition(target: currentPostion, zoom: 19),
                    )),
                style: TextButton.styleFrom(primary: Colors.white),
                child: Text(
                  "Current position",
                  style: TextStyle(color: Color.fromRGBO(221, 209, 199, 1)),
                )),
            if (trip.name != "")
              TextButton(
                  onPressed: () =>
                      _controller.animateCamera(CameraUpdate.newCameraPosition(
                        CameraPosition(target: destination.position, zoom: 19),
                      )),
                  style: TextButton.styleFrom(primary: Colors.white),
                  child: Text("Destination",
                      style:
                          TextStyle(color: Color.fromRGBO(221, 209, 199, 1))))
          ],
        ),
        body: WillPopScope(
          onWillPop: () async {
            if (widget.trips.length != 0) {
              widget.trips.forEach((element) {
                TripDate tr = TripDate(
                    id: element.id,
                    id_journey: element.id_journey,
                    latitude: element.latitude,
                    longitude: element.longitude,
                    city: element.city,
                    country: element.country,
                    name: element.name,
                    visited: element.visited,
                    start_date: widget.journey.start_date,
                    end_date: widget.journey.end_date);
                tripdate.add(tr);
              });
            }
            setState(() {
              _timer.cancel();
              stop = true;
            });
            Navigator.pop(context, tripdate);
            //  Navigator.pop(context);
            return false;
          },
          child: Center(
              child: isLoading
                  ? CircularProgressIndicator(
                      backgroundColor: Color.fromRGBO(221, 209, 199, 1),
                    )
                  : Container(
                      // padding: EdgeInsets.fromLTRB(3, 0, 3, 0),

                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          GoogleMap(
                            // onMapCreated: _onMapCreated,
                            initialCameraPosition: CameraPosition(
                              target: currentPostion,
                              zoom: 15,
                            ),
                            //myLocationButtonEnabled: true,
                            zoomControlsEnabled: false,
                            myLocationEnabled: true,
                            mapType: MapType.normal,

                            markers: {destination},
                            onMapCreated: (controller) {
                              //method called when map is created
                              setState(() {
                                _controller = controller;
                              });
                              //   _controller.setMapStyle(mapStyle);
                            },
                            polylines: {
                              Polyline(
                                polylineId: const PolylineId('poly'),
                                color: Color.fromRGBO(75, 74, 103, 1),
                                width: 5,
                                points: directions.polylinePoints
                                    .map((e) => LatLng(e.latitude, e.longitude))
                                    .toList(),
                              )
                            },
                          ),
                          Positioned(
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: SizeConfig.screenHeight! * 0.05,
                                  width: MediaQuery.of(context).size.width,
                                  //  margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(75, 74, 103, 1),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: AssetImage(
                                              'assets/images/map.png'),
                                          colorFilter: ColorFilter.mode(
                                            Colors.white.withOpacity(0.12),
                                            BlendMode.modulate,
                                          )),
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(50),
                                          bottomRight: Radius.circular(50))),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: SizeConfig.screenHeight! * 0.05,
                                  width: MediaQuery.of(context).size.width,
                                  //  margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(141, 181, 128, 1),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: AssetImage(
                                              'assets/images/map.png'),
                                          colorFilter: ColorFilter.mode(
                                            Colors.white.withOpacity(0.2),
                                            BlendMode.modulate,
                                          )),
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(50),
                                          topRight: Radius.circular(50))),
                                ),
                              ],
                            ),
                          ),
                          if (firstMesage == true)
                            // ex.showAlertDialogExceptions(context, "mdf", "df"),
                            Positioned(
                              top: SizeConfig.screenHeight! * 0.35,
                              child: Column(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    // color: Colors.white,
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                                    width: SizeConfig.screenWidth! * 0.7,
                                    // height: SizeConfig.screenHeight! * 0.15,
                                    decoration: BoxDecoration(
                                        color: Color.fromRGBO(75, 74, 103, 1),
                                        // border: Border.all(
                                        //   //color: Color.fromRGBO(126, 137, 135, 1),
                                        //   color:
                                        //       Color.fromRGBO(141, 181, 128, 1),
                                        //   width: 2,
                                        // ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(height: 10),
                                        Text("Next",
                                            style: TextStyle(
                                                fontSize: 25,
                                                color: Color.fromRGBO(
                                                    221, 209, 199, 1))),
                                        SizedBox(height: 20),
                                        Text(
                                          "The nearest destination is: " +
                                              trip.name,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 23,
                                              color: Color.fromRGBO(
                                                  221, 209, 199, 1)),
                                        ),
                                        SizedBox(height: 20),
                                        TextButton(
                                            onPressed: () {
                                              setState(() {
                                                firstMesage = false;
                                              });
                                            },
                                            child: Text("Ok",
                                                style: TextStyle(
                                                    fontSize: 23,
                                                    color: Color.fromRGBO(
                                                        221, 209, 199, 1))))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (arrivedAtDestination == true)
                            // ex.showAlertDialogExceptions(context, "mdf", "df"),
                            Positioned(
                              top: SizeConfig.screenHeight! * 0.35,
                              child: Column(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    // color: Colors.white,
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                                    width: SizeConfig.screenWidth! * 0.7,
                                    // height: SizeConfig.screenHeight! * 0.15,
                                    decoration: BoxDecoration(
                                        color: Color.fromRGBO(75, 74, 103, 1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Column(
                                      children: [
                                        SizedBox(height: 10),
                                        Text("Information",
                                            style: TextStyle(
                                                fontSize: 25,
                                                color: Color.fromRGBO(
                                                    221, 209, 199, 1))),
                                        SizedBox(height: 20),
                                        Text(
                                          "Have you reached your destination? ",
                                          style: TextStyle(
                                              fontSize: 23,
                                              color: Color.fromRGBO(
                                                  221, 209, 199, 1)),
                                        ),
                                        SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    arrivedAtDestination =
                                                        false;
                                                  });
                                                },
                                                child: Text("No",
                                                    style: TextStyle(
                                                        fontSize: 23,
                                                        color: Color.fromRGBO(
                                                            221,
                                                            209,
                                                            199,
                                                            1)))),
                                            TextButton(
                                                onPressed: () async {
                                                  trip.visited = true;
                                                  await appRepository
                                                      .updateTrip(trip);

                                                  setState(() {
                                                    isLoading = true;
                                                    arrivedAtDestination =
                                                        false;
                                                    firstMesage = true;
                                                    stopEntering = true;
                                                    index = 0;
                                                  });
                                                  widget.trips
                                                      .forEach((element) {
                                                    if (element.id == trip.id)
                                                      element.visited = true;
                                                  });

                                                  addRoute();
                                                },
                                                child: Text("Yes",
                                                    style: TextStyle(
                                                        fontSize: 23,
                                                        color: Color.fromRGBO(
                                                            221, 209, 199, 1))))
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (index == 0)
                            // ex.showAlertDialogExceptions(context, "mdf", "df"),
                            Positioned(
                              top: SizeConfig.screenHeight! * 0.35,
                              child: Column(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    // color: Colors.white,
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                                    width: SizeConfig.screenWidth! * 0.7,
                                    // height: SizeConfig.screenHeight! * 0.15,
                                    decoration: BoxDecoration(
                                        color: Color.fromRGBO(75, 74, 103, 1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Column(
                                      children: [
                                        SizedBox(height: 10),
                                        Text("Informations",
                                            style: TextStyle(
                                                fontSize: 25,
                                                color: Color.fromRGBO(
                                                    221, 209, 199, 1))),
                                        SizedBox(height: 20),
                                        Text(
                                          "You don't have any destinations left to visit",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Color.fromRGBO(
                                                  221, 209, 199, 1)),
                                        ),
                                        SizedBox(height: 20),
                                        TextButton(
                                            onPressed: () {
                                              setState(() {
                                                index = 1;
                                                firstMesage = false;
                                              });
                                            },
                                            child: Text("Ok",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Color.fromRGBO(
                                                        221, 209, 199, 1))))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (trip.name != "key")
                            Positioned(
                                top: 80,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 6.0, horizontal: 12.0),
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(75, 74, 103, 1),
                                    borderRadius: BorderRadius.circular(20.0),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.black,
                                          offset: Offset(0, 2),
                                          blurRadius: 6.0),
                                    ],
                                  ),
                                  child: Text(
                                    '${directions.totalDistance},${directions.totalDuration}',
                                    style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600,
                                        color:
                                            Color.fromRGBO(221, 209, 199, 1)),
                                  ),
                                )),
                          Positioned(
                              // alignment: Alignment(-0.9, -0.81),
                              top: 80,
                              left: 20,
                              child: Container(
                                width: 60,
                                height: 40,
                                child: _popUpMenuButton(),
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(75, 74, 103, 1),
                                  borderRadius: BorderRadius.circular(20.0),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black,
                                        offset: Offset(0, 2),
                                        blurRadius: 6.0),
                                  ],
                                ),
                              ))
                        ],
                      ),
                    )),
        ));
  }

  void _getUserLocation() async {
    dev.log("sunt in getUserLoc");
    readToStart = false;
    setState(() {
      index = 0;
    });
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    var position = await GeolocatorPlatform.instance.getCurrentPosition();

    setState(() {
      currentPostion = LatLng(position.latitude, position.longitude);
      //  currentPostion = LatLng(46.7422, 23.4840);
      firstMesage = true;
    });
    addRoute();
  }

  addRoute() {
    Trip t = calculateNextDestination();
    calculateRoute(t);
  }

  Trip calculateNextDestination() {
    Trip nextTrip = Trip(
        latitude: 0,
        longitude: 0,
        city: " ",
        country: " ",
        name: " ",
        visited: false);
    var dir;
    widget.trips.forEach((element) {
      dev.log("sunt inforeach");
      LatLng position = LatLng(element.latitude, element.longitude);
      //daca a terminat de vizitata tot pune condtitie
      double min = 32000000000000;
      if (element.visited == false) {
        setState(() {
          index++;
        });
        dev.log(element.visited.toString() + " " + element.name);

        double calc = getDistanceFromLatLonInKm(currentPostion, position);
        dev.log(calc.toString() + " " + element.name);
        if (calc < min) {
          min = calc;
          nextTrip = element;
        }
      }
    });
    if (index == 0) {
      incomplete();
    }
    return nextTrip;
  }

  calculateRoute(Trip nexttrip) async {
    if (nexttrip.longitude != 0) {
      var dir;
      LatLng position = LatLng(nexttrip.latitude, nexttrip.longitude);
      try {
        dir = await DirectionsRepo()
            .getDirections(origin: currentPostion, destination: position);
      } catch (_) {
        ex.showAlertDialogExceptions(
            context, "Error", "The routes could not be loaded");
        Navigator.pop(context);
      }

      setState(() {
        directions = dir!;
        dev.log("am initializat tripul");
        finalPosition = LatLng(nexttrip.latitude, nexttrip.longitude);
        destination = Marker(
            // icon: BitmapDescriptor.defaultMarkerWithHue(
            //     BitmapDescriptor.hueGreen),
            markerId: const MarkerId('destination'),
            infoWindow: const InfoWindow(title: 'Destination'),
            position: LatLng(nexttrip.latitude, nexttrip.longitude));
        trip = nexttrip;
        isLoading = false;
        arrivedAtDestination = false;
        stopEntering = false;
      });
    }
  }

  double getDistanceFromLatLonInKm(LatLng current, LatLng destin) {
    var R = 6371; // Radius of the earth in km
    var dLat = deg2rad(destin.latitude - current.latitude); // deg2rad below
    var dLon = deg2rad(destin.longitude - current.longitude);
    var a = sin(dLat / 2) * sin(dLat / 2) +
        cos(deg2rad(current.latitude)) *
            cos(deg2rad(destin.latitude)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));
    var d = R * c; // Distance in km
    return d;
  }

  double deg2rad(deg) {
    return deg * (pi / 180);
  }

  // Future<void> addRoute() async {
  //   if (widget.trips.length == 0) {
  //     incomplete();
  //   } else {
  //     dev.log("sunt in add route");

  //     int minTime = 3200000000;
  //     late Trip t;
  //     var dir;
  //     int contor = 0;
  //     int findVisited = 0;
  //     try {
  //       widget.trips.forEach((element) async {
  //         dev.log("sunt inforeach");
  //         LatLng position = LatLng(element.latitude, element.longitude);
  //         //daca a terminat de vizitata tot pune condtitie

  //         if (element.visited == false) {
  //           setState(() {
  //             index++;
  //           });
  //           dev.log(element.visited.toString() + " " + element.name);
  //           try {
  //             dir = await DirectionsRepo()
  //                 .getDirections(origin: currentPostion, destination: position);
  //           } catch (_) {
  //             ex.showAlertDialogExceptions(
  //                 context, "Error", "The routes could not be loaded");
  //             Navigator.pop(context);
  //           }
  //           //  log(dir!.totalDuration + " " + element.name);
  //           int time = transformInMinutes(dir!.totalDuration);
  //           // final add = <int, int>{1: time, 2: element.id!};

  //           if (time < minTime) {
  //             dev.log("sunt in if");
  //             dev.log(transformInMinutes(dir!.totalDuration).toString());
  //             t = element;
  //             minTime = transformInMinutes(dir!.totalDuration);
  //             contor++;

  //             setState(() {
  //               directions = dir!;
  //               dev.log("am initializat tripul");
  //               finalPosition = LatLng(element.latitude, element.longitude);
  //               destination = Marker(
  //                   // icon: BitmapDescriptor.defaultMarkerWithHue(
  //                   //     BitmapDescriptor.hueGreen),
  //                   markerId: const MarkerId('destination'),
  //                   infoWindow: const InfoWindow(title: 'Destination'),
  //                   position: LatLng(t.latitude, t.longitude));
  //               trip = t;
  //               isLoading = false;
  //               arrivedAtDestination = false;
  //               stopEntering = false;
  //             });
  //           } else
  //             sleep(Duration(milliseconds: 100));
  //           findVisited++;
  //         } else
  //           findVisited++;
  //       });
  //       if (findVisited == widget.trips.length)
  //         setState(() {
  //           // isLoading = false;
  //         });
  //     } catch (_) {
  //       ex.showAlertDialogExceptions(
  //           context, "Error", "The routes could not be loaded");
  //       Navigator.pop(context);
  //     }
  //     if (index == 0) {
  //       incomplete();
  //     }
  //   }
  // }

  void incomplete() async {
    index = 0;

    var dir = await DirectionsRepo()
        .getDirections(origin: currentPostion, destination: currentPostion);
    setState(() {
      destination = Marker(
          markerId: const MarkerId('destination'),
          infoWindow: const InfoWindow(title: 'Destination'),
          position: LatLng(currentPostion.latitude, currentPostion.longitude));
      trip = Trip(
          latitude: currentPostion.latitude,
          longitude: currentPostion.longitude,
          city: "",
          country: "",
          name: "key",
          visited: false);
      directions = dir!;
      finalPosition = LatLng(currentPostion.latitude, currentPostion.longitude);
      isLoading = false;
    });
  }

  Widget _popUpMenuButton() => PopupMenuButton<int>(
      color: Color.fromRGBO(75, 74, 103, 1),
      itemBuilder: (context) => [
            PopupMenuItem(
                value: 1,
                child: Text(
                  "Trip details",
                  style: TextStyle(
                      color: Color.fromRGBO(221, 209, 199, 1),
                      fontWeight: FontWeight.w700),
                ),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (_) => new AlertDialog(
                            backgroundColor: Color.fromRGBO(221, 209, 199, 1),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.0)),
                                side: BorderSide(
                                    color: Color.fromRGBO(194, 207, 178, 1),
                                    width: 5)),
                            content: Builder(
                              builder: (context) {
                                // Get available height and width of the build area of this widget. Make a choice depending on the size.
                                //  var height = MediaQuery.of(context).size.height;
                                //  var width = MediaQuery.of(context).size.width;

                                return Container(
                                  height: SizeConfig.screenHeight! * 0.35,
                                  width: SizeConfig.screenWidth! * 0.7,
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(221, 209, 199, 1)),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.details_outlined,
                                              color: Color.fromRGBO(
                                                  75, 74, 103, 1),
                                            ),
                                            Text(
                                              "Details",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 25),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 30),
                                        Text(details(widget.trips),
                                            style: TextStyle(
                                              fontSize: 23,
                                              color: Colors.black,
                                            )),
                                        SizedBox(height: 30),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text("Ok",
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        75, 74, 103, 1),
                                                    fontSize: 23))),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ));

                  // showAlertDialogExceptions(
                  //     context, ' Informations', 'Eroare la get drinks');
                  _editAlert();
                }),
            PopupMenuItem(
              value: 2,
              child: Text(
                "Trip settings",
                style: TextStyle(
                    color: Color.fromRGBO(221, 209, 199, 1),
                    fontWeight: FontWeight.w700),
              ),
              // onTap: ()  {
              onTap: () async {
                try {
                  // final navigator = ;
                  await Future.delayed(Duration.zero);
                  List<TripDate> tr = await Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => ModifyPage(
                              user: widget.user,
                              journey: widget.journey,
                              trips: widget.trips)));
                  setState(() {
                    isLoading = true;
                  });
                  if (tr.length == 1) {
                    if (tr[0].name == "delete") {
                      List<TripDate> trr = [];
                      Navigator.pop(context, trr);
                      // log("trebuie sa ies");
                    }
                  }

                  if (tr.length == 0) {
                    setState(() {
                      index = 0;
                    });
                    incomplete();
                    //   Navigator.pop(context, tr);
                  }

                  List<Trip> t = [];
                  tr.forEach((element) {
                    dev.log("sunt in schimb de trips " +
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
                    dev.log("sunt in setstae");
                    widget.trips = t;
                    widget.trips.forEach((element) {
                      dev.log(element.visited.toString());
                    });
                    widget.journey.start_date = tr[0].start_date!;
                    widget.journey.end_date = tr[0].end_date!;
                  });
                  _getUserLocation();
                } catch (_) {
                  dev.log(_.toString());
                  dev.log("exceptie navig curent");
                }
                //);
                // },
                //  Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => ModifyPage(
                //             journey: widget.journey, trips: widget.trips)));
              },
            ),
            PopupMenuItem(
              value: 3,
              child: Text(
                "Info",
                style: TextStyle(
                    color: Color.fromRGBO(221, 209, 199, 1),
                    fontWeight: FontWeight.w700),
              ),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (_) => new AlertDialog(
                          backgroundColor: Color.fromRGBO(221, 209, 199, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                            side: BorderSide(
                                color: Color.fromRGBO(194, 207, 178, 1),
                                width: 5),
                          ),
                          content: Builder(
                            builder: (context) {
                              // Get available height and width of the build area of this widget. Make a choice depending on the size.
                              // var height = MediaQuery.of(context).size.height;
                              // var width = MediaQuery.of(context).size.width;

                              return Container(
                                height: SizeConfig.screenHeight! * 0.35,
                                width: SizeConfig.screenWidth! * 0.7,
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(221, 209, 199, 1)),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.info,
                                            color:
                                                Color.fromRGBO(75, 74, 103, 1),
                                          ),
                                          Text(
                                            "Informations",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 25),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 30),
                                      Text(text.info,
                                          style: TextStyle(
                                            fontSize: 23,
                                            color: Colors.black,
                                          )),
                                      SizedBox(height: 30),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("Ok",
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      75, 74, 103, 1),
                                                  fontSize: 23))),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ));

                // showAlertDialogExceptions(
                //     context, ' Informations', 'Eroare la get drinks');
                _editAlert();
              },
            ),
          ],
      icon: Align(
          alignment: Alignment.center,
          child: Icon(Icons.menu, color: Color.fromRGBO(221, 209, 199, 1))));

  showAlertDialogExceptions(BuildContext context, String tittl, String mes) {
    // set up the buttons
    Widget okButton = TextButton(
      child: Text("Ok"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
        // Navigator.pop(dialog)
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      insetPadding: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      title: Row(
        children: [
          Icon(Icons.info_outlined),
          Text(
            tittl,
            style: TextStyle(color: Color.fromRGBO(75, 74, 103, 1)),
          )
        ],
      ),
      content: Text(mes),
      scrollable: true,
      actions: [
        okButton,
      ],
    );

    // show the dialog
    // Navigator.pop(context);
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _editAlert() {
    //edit alertDialog
    var editItem = AlertDialog(
      title: Text('Edit'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Edit Item',
            ),
            // controller: addeditem,
          ),
          TextButton(
              child: Text('Done'),
              onPressed: () {
                ;
                Navigator.of(context).pop();
              })
        ],
      ),
    );
    // var editItem;
    return showDialog(
        //like that
        context: context,
        builder: (BuildContext context) {
          return editItem;
        });
  }

  String details(List<Trip> ls) {
    String finall = "";
    int yes = 0;
    int no = 0;
    String isVisited = "Tourist attractions already visited: " + "\n";
    String isNotVisited = "The next destinations: " + "\n";
    ls.forEach((element) {
      if (element.visited == true) {
        isVisited = isVisited + " " + element.toString() + " \n";
        yes++;
      } else {
        isNotVisited = isNotVisited +
            " " +
            element.city +
            " - " +
            element.country +
            " - " +
            element.name;
        no++;
      }
    });
    if (yes == 0) {
      finall = isVisited + " None for now " + "\n";
    } else
      finall = isVisited;
    finall = finall + "\n" + "\n";
    if (no == widget.trips.length) {
      finall = finall + isNotVisited + " None ";
    } else
      finall = finall + isNotVisited;
    return finall;
  }
}
