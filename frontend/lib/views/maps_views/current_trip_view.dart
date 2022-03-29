import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/directions.dart';
import 'package:frontend/models/sizeConf.dart';
import 'package:frontend/models/trip.dart';
import 'package:frontend/repository/direction_repo.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:frontend/texts/text.dart' as text;

class CurrentTrip extends StatefulWidget {
  CurrentTrip() : super();

  @override
  _CurrentTripState createState() => _CurrentTripState();
}

class _CurrentTripState extends State<CurrentTrip> {
  bool isLoading = true;
  late LatLng currentPostion;
  late GoogleMapController _controller;
  late Marker current_poz;
  late Marker destination;
  bool firstMesage = true;
  late Trip trip = Trip(
      latitude: 0,
      longitude: 0,
      city: "",
      country: "",
      name: "",
      visited: false);
  //LatLng coord = LatLng(46.7422, 23.4840);
  late Directions directions;
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

  @override
  void initState() {
    super.initState();
    isLoading = true;
    trips.add(t1);
    trips.add(t2);
    trips.add(t4);
    trips.add(t5);
    trips.add(t3);

    _getUserLocation();

    //  isLoading = false;
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
      body: Center(
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
                        myLocationButtonEnabled: true,
                        //  myLocationEnabled: true,
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
                            polylineId: const PolylineId('overview_polyline'),
                            color: Colors.blue,
                            width: 5,
                            points: directions.polylinePoints
                                .map((e) => LatLng(e.latitude, e.longitude))
                                .toList(),
                          )
                        },
                      ),
                      if (firstMesage == true)
                        Positioned(
                          top: SizeConfig.screenHeight! * 0.35,
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                color: Colors.white,
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                                width: SizeConfig.screenWidth! * 0.8,
                                height: SizeConfig.screenHeight! * 0.2,
                                child: Column(
                                  children: [
                                    SizedBox(height: 20),
                                    Text("Next",
                                        style: TextStyle(fontSize: 25)),
                                    SizedBox(height: 30),
                                    Text(
                                      "The nearest destination is: " +
                                          trip.name,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    SizedBox(height: 50),
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
                      if (directions != null)
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
    );
  }

  void _getUserLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    var position = await GeolocatorPlatform.instance.getCurrentPosition();

    setState(() {
      currentPostion = LatLng(position.latitude, position.longitude);
    });
    addRoute();
  }

  void addRoute() async {
    int minTime = 3200000000;
    late Trip t;
    var dir;
    int contor = 0;
    trips.forEach((element) async {
      log("sunt inforeach");
      LatLng position = LatLng(element.latitude, element.longitude);
      //daca a terminat de vizitata tot pune condtitie
      if (element.visited == false) {
        dir = await DirectionsRepo()
            .getDirections(origin: currentPostion, destination: position);

        log(dir!.totalDuration);
        if (transformInMinutes(dir!.totalDuration) < minTime) {
          log("sunt in if");
          log(transformInMinutes(dir!.totalDuration).toString());
          t = element;
          minTime = transformInMinutes(dir!.totalDuration);
          contor++;
          setState(() {
            directions = dir!;
            log("am initializat tripul");
            trip = t;
            destination = Marker(
                markerId: const MarkerId('destination'),
                infoWindow: const InfoWindow(title: 'Destination'),
                position: LatLng(trip.latitude, trip.longitude));
          });
        } else
          sleep(Duration(milliseconds: 100));
      }
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
                                var height = MediaQuery.of(context).size.height;
                                var width = MediaQuery.of(context).size.width;

                                return Container(
                                  height: height - 800,
                                  width: width - 200,
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
                                      Text(details(trips),
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
        isNotVisited = isNotVisited + " " + element.toString() + " \n";
        no++;
      }
    });
    if (yes == 0) {
      finall = isVisited + " None for now " + "\n";
    } else
      finall = isVisited;
    finall = finall + "\n" + "\n";
    if (no == trips.length) {
      finall = finall + " None ";
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
