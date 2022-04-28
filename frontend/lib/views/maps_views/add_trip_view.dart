import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:frontend/models/exceptie.dart';
import 'package:frontend/models/tripDate.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/models/journey.dart';
import 'package:frontend/models/sizeConf.dart';
import 'package:frontend/models/trip.dart';
import 'package:frontend/repository/app_repo.dart';
import 'package:frontend/repository/repo.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:google_maps_webservice/places.dart';

//vezi sa i dai sa poata i srollable
class AddTrip extends StatefulWidget {
  User user;
  int index;
  AddTrip({Key? key, required this.user, required this.index})
      : super(key: key);
  @override
  _AddTripState createState() => _AddTripState();
}

class _AddTripState extends State<AddTrip> {
  //String date = "";
  late Repo repo;
  late Exceptie ex;
  late AppRepository appRepository;
  DateTime selectedDate_to_Start = DateTime.now();
  DateTime selectedDate_to_End = DateTime(2020);
  String dateText = "Select the date when you finish your trip";
  String googleApikey = "AIzaSyBi5Y_ei3rpHfOV2AhVquMzd0YhSEqvhBA";
  GoogleMapController? mapController; //contrller for Google map
  CameraPosition? cameraPosition;
  LatLng startLocation = LatLng(46.7712, 23.6236);
  String location = "Search Location";
  late PlacesDetailsResponse detail_for_info;
  bool findPlace = false;
  late double forStart;
  List<Journey> journeys = [];
  bool isLoading = true;
  Trip trip = Trip(
      latitude: 0,
      longitude: 0,
      city: "",
      country: "",
      name: "",
      visited: false);
  List<Trip> trips = [];
  Journey journey =
      Journey(start_date: DateTime.now(), end_date: DateTime.now());
  //Journey journey =
  //    Journey(start: DateTime.now(), end: DateTime.now(), visited: false);
  @override
  void initState() {
    super.initState();
    repo = Repo.repo;
    ex = Exceptie.ex;

    appRepository = AppRepository(repo);
    getData();
  }

  Future getData() async {
    try {
      journeys = await appRepository.getJouneysByUserId(widget.user);
    } catch (_) {
      log(_.toString());
      log("eroare la luat journeys");
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
        appBar: AppBar(
          title: Text("Place Search Autocomplete"),
          //backgroundColor: Colors.deepPurpleAccent,
        ),
        body: Center(
            child: isLoading
                ? CircularProgressIndicator()
                : Stack(children: [
                    Container(
                      height: SizeConfig.screenHeight! * 0.6,
                      child: GoogleMap(
                        //Map widget from google_maps_flutter package
                        zoomGesturesEnabled: true, //enable Zoom in, out on map
                        initialCameraPosition: CameraPosition(
                          //innital position in map
                          target: startLocation, //initial position
                          zoom: 14.0, //initial zoom level
                        ),
                        mapType: MapType.hybrid, //map type
                        onMapCreated: (controller) {
                          //method called when map is created
                          setState(() {
                            mapController = controller;
                          });
                        },
                      ),
                    ),

                    if (findPlace != false)
                      Positioned(
                        top: SizeConfig.screenHeight! * 0.6,
                        child: Container(
                          height: SizeConfig.screenHeight! * 0.3,
                          width: SizeConfig.screenWidth! * 1,
                          //child:Icon(detail_for_info.result.photos[0].photoReference),
                          //child:Image(image: assertIm,)
                          // child: Text(details_destinations_openingHours()),
                          child: IntrinsicHeight(
                            child: Row(
                              children: [
                                Divider(),
                                SizedBox(
                                  width: SizeConfig.screenWidth! * 0.05,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    width: SizeConfig.screenWidth! * 0.4,
                                    height: SizeConfig.screenHeight! * 0.2,
                                    decoration: BoxDecoration(
                                      // color: Colors.amber,
                                      image: DecorationImage(
                                        image: NetworkImage(buildPhotoURL(
                                            detail_for_info.result.photos[0]
                                                .photoReference)),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                                VerticalDivider(
                                  thickness: 4,
                                ),
                                VerticalDivider(
                                  // width: 10,
                                  thickness: 8,
                                ),
                                SizedBox(
                                  width: SizeConfig.screenWidth! * 0.07,
                                ),
                                Align(
                                    alignment: Alignment.bottomRight,
                                    child: Container(
                                        child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height:
                                                SizeConfig.screenHeight! * 0.06,
                                          ),
                                          Text(
                                            details_destinations_openingHours(),
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          Text(
                                            phone_number(),
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          Text(
                                            rating(),
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          SizedBox(
                                            height: 40,
                                          )
                                        ],
                                      ),
                                    ))),
                              ],
                            ),
                          ),
                        ),
                      ),
                    if (findPlace == false)
                      Positioned(
                        top: SizeConfig.screenHeight! * 0.6,
                        child: Container(
                            height: SizeConfig.screenHeight! * 0.3,
                            width: SizeConfig.screenWidth! * 1,
                            //child:Icon(detail_for_info.result.photos[0].photoReference),
                            //child:Image(image: assertIm,)
                            // child: Text(details_destinations_openingHours()),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text("Trip planner"),
                            )),
                      ),
                    //search autoconplete input
                    Positioned(
                        //search input bar
                        top: 60,
                        child: InkWell(
                          onTap: () async {
                            // log(forStart.toString());
                            var place = await PlacesAutocomplete.show(
                                context: context,
                                apiKey: googleApikey,
                                mode: Mode.overlay,
                                types: [],
                                strictbounds: false,

                                //google_map_webservice package
                                onError: (err) {
                                  print(err);
                                });

                            if (place != null) {
                              setState(() {
                                location = place.description.toString();
                              });

                              //form google_maps_webservice package
                              final plist = GoogleMapsPlaces(
                                apiKey: googleApikey,
                                apiHeaders:
                                    await GoogleApiHeaders().getHeaders(),
                                //from google_api_headers package
                              );

                              String placeid = place.placeId ?? "0";
                              final detail =
                                  await plist.getDetailsByPlaceId(placeid);
                              Photo ceva = detail.result.photos[0];
                              setState(() {
                                detail_for_info = detail;
                                findPlace = true;
                                forStart = SizeConfig.screenHeight! * 0.6;
                                log(forStart.toString());
                              });

                              final geometry = detail.result.geometry!;
                              final lat = geometry.location.lat;
                              final lang = geometry.location.lng;
                              var newlatlang = LatLng(lat, lang);
                              // setState(() {
                              trip.latitude = lat;
                              trip.longitude = lang;
                              trip.name = place.description.toString();
                              trip.visited = false;
                              if (detail.result.addressComponents[0].longName
                                  .contains(RegExp('[0-9]')))
                                trip.city =
                                    detail.result.addressComponents[2].longName;
                              else
                                trip.city =
                                    detail.result.addressComponents[1].longName;

                              var len = detail.result.addressComponents.length;
                              if (detail
                                  .result.addressComponents[len - 1].longName
                                  .contains(RegExp('[0-9]'))) {
                                trip.country = detail
                                    .result.addressComponents[len - 2].longName;
                              } else
                                trip.country = detail
                                    .result.addressComponents[len - 1].longName;

                              detail.result.addressComponents
                                  .forEach((element) {
                                log(element.longName);
                              });

                              //move map camera to selected place with animation
                              mapController?.animateCamera(
                                  CameraUpdate.newCameraPosition(CameraPosition(
                                      target: newlatlang, zoom: 18)));
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                            child: Card(
                              child: Container(
                                  //padding: EdgeInsets.all(0),
                                  width: MediaQuery.of(context).size.width - 40,
                                  child: ListTile(
                                    title: Text(
                                      location,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    trailing: Icon(Icons.search),
                                    dense: true,
                                  )),
                            ),
                          ),
                        )),
                    Positioned(
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            color: Colors.white,
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            child: Text(
                                "Find the places you want to visit then add them to your trip",
                                style: TextStyle(fontSize: 18)),
                          ),
                        ],
                      ),
                    ),

                    Positioned(
                      //search input bar
                      bottom: 40,
                      left: 38 / 100 * (MediaQuery.of(context).size.width),
                      child: Container(
                        child: FloatingActionButton.extended(
                          onPressed: () async {
                            log(trip.toString());
                            // Trip tr = trip;
                            // setState(() {
                            trips.add(Trip.clone(trip));
                            trips.forEach((element) {
                              log(element.toString());
                            });
                            //  });

                            final snackBar = SnackBar(
                              content: Builder(builder: (context) {
                                return const Text('Destination added');
                              }),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);

                            ///////////////////////////////////////////////////////////////////////////////////////////////////////////
                          },
                          icon: const Icon(Icons.add),
                          label: const Text("Add to your trip"),
                          splashColor: Colors.blue,
                        ),
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
                      ),
                    ),

                    Positioned(
                      bottom: 40,
                      left: 2 / 100 * (MediaQuery.of(context).size.width),
                      child: ElevatedButton(
                          onPressed: () {
                            if (trips.length == 0)
                              ex.showAlertDialogExceptions(context, "Info",
                                  "This trip has no destinations");
                            else {
                              _selectDate(context);
                            }
                          },
                          child: Container(
                              alignment: Alignment.center,
                              width: 50,
                              height: 30,
                              child: Text(
                                "Finish",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            elevation: 8,
                            shadowColor: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          )),
                    ),
                  ])));
  }

  //vezi ca aici daca pui aceeasi data nu arata cea de dupa

  _selectDate(BuildContext context) async {
    if (widget.index == 0) {
      final DateTime? selected = await showDatePicker(
          context: context,
          initialDate: selectedDate_to_Start,
          firstDate: DateTime(2020),
          lastDate: DateTime(2025),
          helpText: "Select the date when you start your trip");
      if (selected != null && selected != selectedDate_to_Start)
        setState(() {
          selectedDate_to_Start = selected;
          log(selectedDate_to_Start.toString());
        });
      //  final DateTime? selectedd =DateTime.now();
      log(selectedDate_to_End.toString());
      log(selectedDate_to_Start.toString());
//aici ai grija ca daca dai data curenta nu intra in while
      while (selectedDate_to_End.isBefore(selectedDate_to_Start)) {
        log("am intart");
        final DateTime? selectedd = await showDatePicker(
            context: context,
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                    primary: Color.fromRGBO(128, 196, 131, 1),
                    onPrimary: Colors.white,
                    // onSurface: Colors.black,
                  ),
                ),
                child: child!,
              );
            },
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime(2025),
            helpText: dateText);
        if (selectedd != null &&
            selectedd != selectedDate_to_End &&
            selectedd.isAfter(selectedDate_to_Start)) {
          setState(() {
            log("am facut jounrey ul");
            selectedDate_to_End = selectedd;
            journey.start_date = selectedDate_to_Start;
            journey.end_date = selectedDate_to_End;
          });
        } else
          setState(() {
            dateText = "The end date can t be before the start date";
          });
      }
      int count = 0;

      journeys.forEach((element) {
        if (element.start_date.isBefore(selectedDate_to_Start) &&
            element.end_date.isBefore(selectedDate_to_End) &&
            element.end_date.isAfter(selectedDate_to_Start)) {
          count++;
          log("if 1");
        }

        if (element.start_date.isAfter(selectedDate_to_Start) &&
            element.end_date.isBefore(selectedDate_to_End)) {
          count++;
          log("if 2");
        }

        if (element.start_date.isAfter(selectedDate_to_Start) &&
            element.end_date.isAfter(selectedDate_to_End) &&
            element.start_date.isBefore(selectedDate_to_End)) {
          log("if 3");
          count++;
        }

        if (element.start_date.isBefore(selectedDate_to_Start) &&
            element.end_date.isAfter(selectedDate_to_End)) {
          log("if 4");
          count++;
        }
      });
      if (count != 0) {
        ex.showAlertDialogExceptions(context, "Information",
            "You alerady have a trip in those dates. Please add another ones");
        setState(() {
          selectedDate_to_Start = DateTime.now();
          selectedDate_to_End = DateTime(2020);
        });
      } else {
        setState(() {
          journey.id_user = widget.user.id;
        });
        try {
          Journey j = await appRepository.addJouney(journey, trips);
          final snackBar = SnackBar(
            content: Builder(builder: (context) {
              return const Text('Trip added');
            }),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.pop(context, j);
        } catch (_) {
          log(_.toString());
          ex.showAlertDialogExceptions(
              context, "Error", "This trip cannot be saved");
          Navigator.pop(context);
        }
      }
    } else {
      trips.forEach((element) {
        element.id_journey = widget.index;
      });
      try {
        List<Trip> tr = await appRepository.addTrips(trips);

        setState(() {
          trips = tr;
          log(trips[0].id!.toString());
        });

        final snackBar = SnackBar(
          content: Builder(builder: (context) {
            return const Text('Trip added');
          }),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pop(context, trips);
      } catch (_) {
        log(_.toString());
        log("sunt in add");
      }
    }
  }

  String details_destinations_openingHours() {
    String s = "";
    var list = detail_for_info.result.openingHours;
    if (list != null) {
      s = "Program:" + "\n";
      List<OpeningHoursPeriod> li = list.periods;
      try {
        li.forEach((element) {
          if (element.open!.day == 0) {
            s = s + "Monday  ";
          }
          if (element.open!.day == 1) {
            s = s + "Tuesday  ";
          }
          if (element.open!.day == 2) {
            s = s + "Wednesday  ";
          }
          if (element.open!.day == 3) {
            s = s + "Thursday  ";
          }
          if (element.open!.day == 4) {
            s = s + "Friday  ";
          }
          if (element.open!.day == 5) {
            s = s + "Saturday  ";
          }
          if (element.open!.day == 6) {
            s = s + "Sunday  ";
          }

          s = s +
              element.open!.time[0].toString() +
              element.open!.time[1].toString() +
              ":" +
              element.open!.time[2].toString() +
              element.open!.time[3].toString();
          s = s + "-";
          s = s +
              element.close!.time[0].toString() +
              element.close!.time[1].toString() +
              ":" +
              element.close!.time[2].toString() +
              element.close!.time[3].toString();
          s = s + "\n";
        });
      } catch (_) {
        s = "Program:" + "Does not exist";
        return s;
      }
    }
    if (s == "") s = "Program:" + "Does not exist";
    return s;
  }

  String phone_number() {
    //String s = "";
    String? s = detail_for_info.result.internationalPhoneNumber;
    late String ss;
    if (s == null) {
      ss = "Phone number: - ";
    } else
      ss = "Phone number:" + s;
    return ss;
  }

  String rating() {
    String s = "Rating: ";
    var rating = detail_for_info.result.rating;
    if (rating == null) {
      s = s + " - ";
      return s;
    }
    return s + rating.toString();
  }

  String cva() {
    var rating = detail_for_info.result.photos[1].photoReference;
    log(rating.toString());
    return rating;
  }

  String buildPhotoURL(String photoReference) {
    return 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${photoReference}&key=${googleApikey}';
  }
}
