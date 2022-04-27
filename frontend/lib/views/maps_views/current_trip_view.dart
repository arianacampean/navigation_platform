import 'dart:developer';
import 'dart:io';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/directions.dart';
import 'package:frontend/models/exceptie.dart';
import 'package:frontend/models/journey.dart';
import 'package:frontend/models/sizeConf.dart';
import 'package:frontend/models/trip.dart';
import 'package:frontend/models/tripDate.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/repository/app_repo.dart';
import 'package:frontend/repository/direction_repo.dart';
import 'package:frontend/repository/repo.dart';
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
  late Repo repo;
  late AppRepository appRepository;
  late LatLng currentPostion;
  late GoogleMapController _controller;
  late Marker current_poz;
  late Marker destination;
  bool firstMesage = true;
  List<TripDate> tripdate = [];
  bool arrivedAtDestination = false;
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

  @override
  void initState() {
    super.initState();
    repo = Repo.repo;
    ex = Exceptie.ex;

    appRepository = AppRepository(repo);

    isLoading = true;

    _getUserLocation();
    const duration = Duration(minutes: 1);
    //Timer.periodic(duration, (Timer t) => _arrived());
  }

  void _arrived() async {
    log("calculez");
    _location.onLocationChanged.listen((l) async {
      setState(() {
        // currentPostion = LatLng(l.latitude!, l.longitude!);
        currentPostion = LatLng(46.7712, 23.6236);
      });
      var dir = await DirectionsRepo()
          .getDirections(origin: currentPostion, destination: finalPosition);
      setState(() {
        directions != dir;
      });
      log(directions.totalDuration);
    });
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
                child: Text("Current position")),
            if (trip.name != "")
              TextButton(
                  onPressed: () =>
                      _controller.animateCamera(CameraUpdate.newCameraPosition(
                        CameraPosition(target: destination.position, zoom: 19),
                      )),
                  style: TextButton.styleFrom(primary: Colors.white),
                  child: Text("Destination"))
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
            Navigator.pop(context, tripdate);
            //  Navigator.pop(context);
            return false;
          },
          child: Center(
              child: trip.name == ""
                  ? CircularProgressIndicator()
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
                            myLocationEnabled: true,
                            mapType: MapType.normal,

                            markers: {destination},
                            onMapCreated: (controller) {
                              //method called when map is created
                              setState(() {
                                _controller = controller;
                              });
                            },
                            polylines: {
                              Polyline(
                                polylineId:
                                    const PolylineId('overview_polyline'),
                                color: Colors.blue,
                                width: 5,
                                points: directions.polylinePoints
                                    .map((e) => LatLng(e.latitude, e.longitude))
                                    .toList(),
                              )
                            },
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
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Column(
                                      children: [
                                        SizedBox(height: 10),
                                        Text("Next",
                                            style: TextStyle(fontSize: 25)),
                                        SizedBox(height: 20),
                                        Text(
                                          "The nearest destination is: " +
                                              trip.name,
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        SizedBox(height: 20),
                                        TextButton(
                                            onPressed: () {
                                              setState(() {
                                                firstMesage = false;
                                              });
                                            },
                                            child: Text("ok",
                                                style: TextStyle(fontSize: 20)))
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
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Column(
                                      children: [
                                        SizedBox(height: 10),
                                        Text("Information",
                                            style: TextStyle(fontSize: 25)),
                                        SizedBox(height: 20),
                                        Text(
                                          "Have you reached your destination? ",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            TextButton(
                                                onPressed: () {},
                                                child: Text("No",
                                                    style: TextStyle(
                                                        fontSize: 20))),
                                            TextButton(
                                                onPressed: () {},
                                                child: Text("Yes",
                                                    style: TextStyle(
                                                        fontSize: 20)))
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
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Column(
                                      children: [
                                        SizedBox(height: 10),
                                        Text("Informations",
                                            style: TextStyle(fontSize: 25)),
                                        SizedBox(height: 20),
                                        Text(
                                          "You don't have any destinations left to visit",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        SizedBox(height: 20),
                                        TextButton(
                                            onPressed: () {
                                              setState(() {
                                                index = 1;
                                                firstMesage = false;
                                              });
                                            },
                                            child: Text("ok",
                                                style: TextStyle(fontSize: 20)))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (trip.name != "key")
                            Positioned(
                                top: 20,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 6.0, horizontal: 12.0),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
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
                                        color: Colors.white),
                                  ),
                                )),
                          Positioned(
                              // alignment: Alignment(-0.9, -0.81),
                              top: 20,
                              left: 20,
                              child: Container(
                                width: 60,
                                height: 40,
                                child: _popUpMenuButton(),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
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
    log("sunt in getUserLoc");
    readToStart = false;
    setState(() {
      index = 0;
    });
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    var position = await GeolocatorPlatform.instance.getCurrentPosition();

    setState(() {
      currentPostion = LatLng(position.latitude, position.longitude);
      firstMesage = true;
    });
    addRoute();
  }

  Future<void> addRoute() async {
    if (widget.trips.length == 0) {
      incomplete();
    } else {
      log("sunt in add route");

      int minTime = 3200000000;
      late Trip t;
      var dir;
      int contor = 0;

      widget.trips.forEach((element) async {
        log("sunt inforeach");
        LatLng position = LatLng(element.latitude, element.longitude);
        //daca a terminat de vizitata tot pune condtitie

        if (element.visited == false) {
          setState(() {
            index++;
          });
          log(element.visited.toString() + " " + element.name);
          dir = await DirectionsRepo()
              .getDirections(origin: currentPostion, destination: position);

          log(dir!.totalDuration + " " + element.name);
          if (transformInMinutes(dir!.totalDuration) < minTime) {
            log("sunt in if");
            log(transformInMinutes(dir!.totalDuration).toString());
            t = element;
            minTime = transformInMinutes(dir!.totalDuration);
            contor++;

            setState(() {
              directions = dir!;
              log("am initializat tripul");
              finalPosition = LatLng(element.latitude, element.longitude);
              destination = Marker(
                  markerId: const MarkerId('destination'),
                  infoWindow: const InfoWindow(title: 'Destination'),
                  position: LatLng(t.latitude, t.longitude));
              trip = t;
            });
          } else
            sleep(Duration(milliseconds: 100));
        }
      });
      if (index == 0) {
        incomplete();
      }
    }
  }

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
    });
  }

  Widget _popUpMenuButton() => PopupMenuButton<int>(
      itemBuilder: (context) => [
            PopupMenuItem(
                value: 1,
                child: Text(
                  "Trip details",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w700),
                ),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (_) => new AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            content: Builder(
                              builder: (context) {
                                // Get available height and width of the build area of this widget. Make a choice depending on the size.
                                //  var height = MediaQuery.of(context).size.height;
                                //  var width = MediaQuery.of(context).size.width;

                                return Container(
                                  // height: SizeConfig.screenHeight! * 0.3,
                                  width: SizeConfig.screenWidth! * 0.7,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.details),
                                          Text(
                                            "Details",
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 25),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 30),
                                      Text(details(widget.trips),
                                          style: TextStyle(fontSize: 23)),
                                      SizedBox(height: 30),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("Ok",
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 23))),
                                    ],
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
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
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
                  if (tr.length == 1) {
                    if (tr[0].name == "delete") {
                      Navigator.pop(context);
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
                    widget.trips = t;
                    widget.trips.forEach((element) {
                      log(element.visited.toString());
                    });
                    widget.journey.start_date = tr[0].start_date!;
                    widget.journey.end_date = tr[0].end_date!;
                  });
                  _getUserLocation();
                } catch (_) {
                  log(_.toString());
                  log("exceptie navig curent");
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
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
              ),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (_) => new AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          content: Builder(
                            builder: (context) {
                              // Get available height and width of the build area of this widget. Make a choice depending on the size.
                              var height = MediaQuery.of(context).size.height;
                              var width = MediaQuery.of(context).size.width;

                              return Container(
                                height: height - 600,
                                width: width - 400,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.info_rounded),
                                        Text(
                                          "Informations",
                                          style: TextStyle(
                                              color: Colors.blue, fontSize: 25),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 30),
                                    Text(text.info,
                                        style: TextStyle(fontSize: 23)),
                                    SizedBox(height: 30),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("Ok",
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 23))),
                                  ],
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
          child: Icon(Icons.menu, color: Colors.white)));

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
            style: TextStyle(color: Colors.blue),
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

  int transformInMinutes(String s) {
    int sum = 0;
    List<String> array = s.split(" ");
    for (int i = 0; i < array.length; i = i + 2) {
      if (array[i + 1] == 'hours') {
        sum = sum + int.parse(array[i]) * 60;
      } else if (array[i + 1] == 'day') {
        sum = sum + int.parse(array[i]) * 60 * 24;
      } else if (array[i + 1] == 'mins') {
        sum = sum + int.parse(array[i]);
      }
    }
    return sum;
  }
}
