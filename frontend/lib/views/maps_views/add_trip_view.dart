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
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:google_maps_webservice/places.dart';


class AddTrip extends StatefulWidget {
  User user;
  int index;
  AddTrip({Key? key, required this.user, required this.index})
      : super(key: key);
  @override
  _AddTripState createState() => _AddTripState();
}

class _AddTripState extends State<AddTrip> {
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
  bool noInfo = false;

  @override
  void initState() {
    super.initState();
    ex = Exceptie.ex;
    appRepository = AppRepository();
    getData();
  }

  //functia ia toate jouney-urile utilizatorului care este logat
  //acestea sunt utilzate la compararea date lor de incepere si terminare pentru jouney-ul adaugat
  Future getData() async {
    try {
      journeys = await appRepository.getJouneysByUserId(widget.user);
    } catch (_) {
      log(_.toString());
      log("la luat jouneys");
      ex.showAlertDialogExceptions(context, "Error", "Something went wrong");
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
          title: Text("Add trip"),
         
        ),
        body: Center(
            child: isLoading
                ? CircularProgressIndicator()
                : Stack(children: [
                    Container(
                      height: SizeConfig.screenHeight! * 0.6,
                      child: GoogleMap(
                        zoomGesturesEnabled: true,
                        zoomControlsEnabled: false,
                        initialCameraPosition: CameraPosition(                        
                          target: startLocation, //initial position
                          zoom: 14.0, //initial zoom level
                        ),
                        mapType: MapType.hybrid, //map type
                        onMapCreated: (controller) {
                         
                          setState(() {
                            mapController = controller;
                          });
                        },
                      ),
                    ),

                    if (findPlace != false)
                      Positioned(
                        top: SizeConfig.screenHeight! * 0.55,
                        child: Container(
                          alignment: Alignment.center,
                          height: SizeConfig.screenHeight! * 0.35,
                          width: SizeConfig.screenWidth! * 1,
                          decoration: BoxDecoration(
                           
                            color: Color.fromRGBO(221, 209, 199, 1),
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            border: Border.all(
                            
                              color: Color.fromRGBO(194, 207, 178, 1),
                              width: 2,
                            ),
                          ),
                        
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              if (noInfo == false)
                                SingleChildScrollView(
                                    child: Column(children: [
                                  Container(
                                    alignment: Alignment.topLeft,
                                    width: SizeConfig.screenWidth! * 0.40,
                                    height: SizeConfig.screenHeight! * 0.23,
                                    decoration: BoxDecoration(
                                        color:
                                            Color.fromRGBO(141, 181, 128, 1)),
                                    child: Align(
                                     
                                      child: Container(
                                        alignment: Alignment.topCenter,
                                        width: SizeConfig.screenWidth! * 0.38,
                                        height: SizeConfig.screenHeight! * 0.21,
                                        decoration: BoxDecoration(
                                        
                                          image: DecorationImage(
                                            image: NetworkImage(buildPhotoURL(
                                                detail_for_info.result.photos[0]
                                                    .photoReference)),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 40,
                                  )
                                ])),
                              Container(
                                  alignment: Alignment.topCenter,
                                  child: SingleChildScrollView(
                                      child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(
                                        height: SizeConfig.screenHeight! * 0.04,
                                      ),
                                      Text(
                                        details_destinations_openingHours(),
                                        style: TextStyle(
                                            fontSize: 23, color: Colors.black),
                                      ),
                                      Text(
                                        phone_number(),
                                        style: TextStyle(
                                            fontSize: 23, color: Colors.black),
                                      ),
                                      Text(
                                        rating(),
                                        style: TextStyle(
                                            fontSize: 23, color: Colors.black),
                                      ),
                                    ],
                                  ))),
                            ],
                          ),
                          //  ),
                        ),
                      ),
                    if (findPlace == false)
                      Positioned(
                        top: SizeConfig.screenHeight! * 0.55,
                        child: Container(
                          height: SizeConfig.screenHeight! * 0.35,
                          width: SizeConfig.screenWidth! * 1,
                          decoration: BoxDecoration(
                           
                            color: Color.fromRGBO(221, 209, 199, 1),
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            border: Border.all(
                             
                              color: Color.fromRGBO(194, 207, 178, 1),
                              width: 2,
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              alignment: Alignment.center,
                              child: Image.asset(
                                'assets/images/logo.png',
                                width: SizeConfig.screenHeight! * 0.2,
                              ),
                            ),
                          ),
                        ),
                      ),
                   
                    Positioned(
                      
                        top: 60,
                        child: InkWell(
                          onTap: () async {
                         
                            var place = await PlacesAutocomplete.show(
                                context: context,
                                textStyle: TextStyle(color: Colors.black),
                                cursorColor: Color.fromRGBO(221, 209, 199, 1),
                                textDecoration: InputDecoration(
                                    fillColor: Color.fromRGBO(221, 209, 199, 1),
                                    focusColor:
                                        Color.fromRGBO(221, 209, 199, 1)),
                                apiKey: googleApikey,
                                mode: Mode.overlay,
                                types: [],
                                strictbounds: false,
                                onError: (err) {
                                  print(err);
                                });

                            if (place != null) {
                              setState(() {
                                location = place.description.toString();
                              });

                           
                              final plist = GoogleMapsPlaces(
                                apiKey: googleApikey,
                                apiHeaders:
                                    await GoogleApiHeaders().getHeaders(),
                      
                              );

                              String placeid = place.placeId ?? "0";
                              final detail =
                                  await plist.getDetailsByPlaceId(placeid);
                              try {
                                Photo ceva = detail.result.photos[0];
                                noInfo = false;
                              } catch (_) {
                                noInfo = true;
                              }
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

                              mapController?.animateCamera(
                                  CameraUpdate.newCameraPosition(CameraPosition(
                                      target: newlatlang, zoom: 18)));
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(221, 209, 199, 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                 
                                  width: MediaQuery.of(context).size.width - 40,
                                  child: ListTile(
                                    title: Text(
                                      location,
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.black),
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
                            height: SizeConfig.screenHeight! * 0.05,
                            width: MediaQuery.of(context).size.width,
                          
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(75, 74, 103, 1),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage('assets/images/map.png'),
                                    colorFilter: ColorFilter.mode(
                                      Colors.white.withOpacity(0.12),
                                      BlendMode.modulate,
                                    )),
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(50),
                                    bottomRight: Radius.circular(50))),
                            child: Text(
                                "Find the places you want to visit then add them to your trip",
                                style: TextStyle(
                                    fontSize: 23,
                                    color: Color.fromRGBO(221, 209, 199, 1))),
                          ),
                        ],
                      ),
                    ),

                    Positioned(
                     
                      bottom: 55,
                      left: 55 / 100 * (MediaQuery.of(context).size.width),
                      child: Container(
                        width: SizeConfig.screenWidth! * 0.35,
                        height: SizeConfig.screenHeight! * 0.045,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, 8),
                                blurRadius: 5.0)
                          ],
                          color: Color.fromRGBO(141, 181, 128, 1),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            stops: [0.4, 1.0],
                            colors: [
                              Color.fromRGBO(75, 74, 103, 1),
                
                              Color.fromRGBO(141, 181, 128, 1),
                            ],
                          ),
                        
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: ElevatedButton(
                          onPressed: () async {
                            log(trip.toString());
                            if (trip.name != "") {
                              trips.add(Trip.clone(trip));
                              trips.forEach((element) {
                                log(element.toString());
                              });

                              final snackBar = SnackBar(
                                content: Builder(builder: (context) {
                                  return const Text('Destination added');
                                }),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {
                              ex.showAlertDialogExceptions(
                                  context,
                                  'Information',
                                  'You need to select a destination before you add it');
                            }
                          },
                          child: Container(
                              alignment: Alignment.center,
                              width: SizeConfig.screenWidth! * 0.5,
                              height: SizeConfig.screenHeight! * 0.05,
                              padding: EdgeInsets.fromLTRB(3, 0, 3, 3),
                              child: Text(
                                "Add destination",
                                style: TextStyle(
                                    color: Color.fromRGBO(221, 209, 199, 1),
                                    fontSize: SizeConfig.screenHeight! * 0.022),
                              )),
                          style: ButtonStyle(
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
                            backgroundColor:
                                MaterialStateProperty.all(Colors.transparent),
                           
                            shadowColor:
                                MaterialStateProperty.all(Colors.transparent),
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 55,
                      left: 10 / 100 * (MediaQuery.of(context).size.width),
                      child: Container(
                        width: SizeConfig.screenWidth! * 0.35,
                        height: SizeConfig.screenHeight! * 0.045,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, 8),
                                blurRadius: 5.0)
                          ],
                          color: Color.fromRGBO(141, 181, 128, 1),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            stops: [0.0, 0.58],
                            colors: [
                            
                              Color.fromRGBO(141, 181, 128, 1),
                              Color.fromRGBO(75, 74, 103, 1),
                            ],
                          ),
                       
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (trips.length == 0)
                              ex.showAlertDialogExceptions(context, "Info",
                                  "This trip has no destinations");
                            else {
                              _selectDate(context);
                            }
                          },
                          child: Container(
                              alignment: Alignment.center,
                              width: SizeConfig.screenWidth! * 0.5,
                              height: SizeConfig.screenHeight! * 0.05,
                              padding: EdgeInsets.fromLTRB(3, 0, 3, 3),
                              child: Text(
                                "Finish the trip",
                                style: TextStyle(
                                    color: Color.fromRGBO(221, 209, 199, 1),
                                    fontSize: SizeConfig.screenHeight! * 0.022),
                              )),
                          style: ButtonStyle(
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
                            backgroundColor:
                                MaterialStateProperty.all(Colors.transparent),
                            // elevation: MaterialStateProperty.all(3),
                            shadowColor:
                                MaterialStateProperty.all(Colors.transparent),
                          ),
                        ),
                      ),
                    ),
                  ])));
  }

  //functia pentru a aparea pe ecran datePickerul
  //daca acesta este apelata din eranul de adaugare o sa apara pentru a putea alege datele pentru excurie
  //in caz ca e apelata din ecranul de modificari acestea nu vor aparea pe ecan
  //modificarile unui journey sau adaugarea acestuia sunt realizate aici de asemenea
  _selectDate(BuildContext context) async {
    if (widget.index == 0) {
      final DateTime? selected = await showDatePicker(
          context: context,
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: Color.fromRGBO(75, 74, 103, 1),
                  onPrimary: Color.fromRGBO(221, 209, 199, 1),
                  // onSurface: Colors.black,
                ),
                dialogBackgroundColor: Color.fromRGBO(221, 209, 199, 1),
              ),
              child: child!,
            );
          },
          initialDate: selectedDate_to_Start,
          firstDate: DateTime(2020),
          lastDate: DateTime(2025),
          helpText: "Select the date when you start your trip");
      if (selected != null && selected != selectedDate_to_Start)
        setState(() {
          selectedDate_to_Start = selected;
          log(selectedDate_to_Start.toString());
        });

      log(selected.toString());
      log(selectedDate_to_End.toString());
      log(selectedDate_to_Start.toString());
      log(selected.toString());
      int good = 0;
      if (selected != null) {
        while (selectedDate_to_End.isBefore(selectedDate_to_Start)) {
          final DateTime? selectedd = await showDatePicker(
              context: context,
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: Color.fromRGBO(103, 112, 110, 1),
                      onPrimary: Color.fromRGBO(221, 209, 199, 1),
                    ),
                    dialogBackgroundColor: Color.fromRGBO(221, 209, 199, 1),
                  ),
                  child: child!,
                );
              },
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2025),
              helpText: dateText);
          if (selectedd == null) {
            log("am intrat");
            good = 1;
            break;
          }
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
        if (good != 1) {
          log("sunt in good dif de 1");
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
        ex.showAlertDialogExceptions(
            context, "Error", "This destination cannot be added");
      }
    }
  }

  //functie pentru a afla orele de deschidere a obiectivelor turistice
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

  // aflarea numarului de telefon pentru obiectivele turistice
  String phone_number() {
    String? s = detail_for_info.result.internationalPhoneNumber;
    late String ss;
    if (s == null) {
      ss = "Phone number: - ";
    } else
      ss = "Phone number:" + s;
    return ss;
  }

  //aflarea rating-ului
  String rating() {
    String s = "Rating: ";
    var rating = detail_for_info.result.rating;
    if (rating == null) {
      s = s + " - ";
      return s;
    }
    return s + rating.toString();
  }

  //functie pentru a putea vedea fotografia obiectivului turistic
  String buildPhotoURL(String photoReference) {
    return 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${photoReference}&key=${googleApikey}';
  }
}
