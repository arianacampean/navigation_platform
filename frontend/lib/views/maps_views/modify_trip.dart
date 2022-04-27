import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/exceptie.dart';
import 'package:frontend/models/journey.dart';
import 'package:frontend/models/sizeConf.dart';
import 'package:frontend/models/trip.dart';
import 'package:frontend/models/tripDate.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/repository/app_repo.dart';
import 'package:frontend/repository/repo.dart';

import 'add_trip_view.dart';

class ModifyPage extends StatefulWidget {
  // List<Trip> trips;
  User user;
  Journey journey;
  List<Trip> trips;
  ModifyPage(
      {Key? key,
      required this.journey,
      required this.trips,
      required this.user})
      : super(key: key);

  @override
  _ModifyPageState createState() => _ModifyPageState();
}

class _ModifyPageState extends State<ModifyPage> {
  String dropdownValue = 'Yes';
//  List<Trip> trips = [];
  bool isLoading = true;
  late Repo repo;
  late Exceptie ex;
  late AppRepository appRepository;
  List<Trip> deletedTrips = [];
  List<Trip> addedTrips = [];
  List<TripDate> tripdate = [];

  @override
  void initState() {
    super.initState();
    repo = Repo.repo;
    ex = Exceptie.ex;

    appRepository = AppRepository(repo);
    //  widget.journey.forEach((element) {
    //trips.add(element.trip);
    //  });
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(),
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
            return false;
          },
          child: Center(
              child: isLoading
                  ? CircularProgressIndicator()
                  : Column(children: [
                      Container(
                        height: SizeConfig.screenHeight! * 0.1,
                        child: Text(
                          "Trip settings",
                          style: TextStyle(fontSize: 20),
                        ),
                        alignment: Alignment.center,
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        height: SizeConfig.screenHeight! * 0.05,
                        child: Text(
                          "Change if you visited smth long press for delete,save after or cancel",
                          style: TextStyle(fontSize: 18),
                        ),
                        alignment: Alignment.center,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Start date: " +
                                widget.journey.start_date
                                    .toString()
                                    .split(" ")[0],
                            style: TextStyle(fontSize: 18),
                          ),
                          TextButton(
                              onPressed: () {
                                _selectDate(context, "start");
                              },
                              child: Text("Change",
                                  style: TextStyle(fontSize: 18))),
                          // DatePickerDialog(
                          //     initialDate: widget.journey[0].start,
                          //     firstDate: DateTime.now(),
                          //     lastDate: DateTime(2025)),
                          Text(
                              "End date: " +
                                  widget.journey.end_date
                                      .toString()
                                      .split(" ")[0],
                              style: TextStyle(fontSize: 18)),
                          TextButton(
                              onPressed: () {
                                _selectDate(context, "end");
                              },
                              child: Text("Change",
                                  style: TextStyle(fontSize: 18))),
                          // SizedBox(
                          //   height: 15,
                          // )
                        ],
                      ),
                      Expanded(
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: widget.trips.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              //leading: Image.asset('assets/images/imagess.jpg'),
                              title: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                      child: Column(
                                    children: [
                                      Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            widget.trips[index].name,
                                            style: TextStyle(fontSize: 20),
                                          )),
                                      Divider(
                                        color: Color.fromRGBO(159, 224, 172, 1),
                                        height: 25,
                                        thickness: 2,
                                        indent: SizeConfig.screenWidth! * 0.2,
                                        endIndent:
                                            SizeConfig.screenWidth! * 0.2,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          //SizedBox(width: SizeConfig.screenWidth! * 0.22),
                                          Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "Country: " +
                                                    widget
                                                        .trips[index].country +
                                                    "    ",
                                                style: TextStyle(fontSize: 20),
                                              )),
                                          // SizedBox(
                                          //     width: SizeConfig.screenWidth! *
                                          //         0.1),
                                          Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                "City: " +
                                                    widget.trips[index].city,
                                                style: TextStyle(fontSize: 20),
                                              ))
                                        ],
                                      ),
                                      SingleChildScrollView(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text("Visited: ",
                                                style: TextStyle(fontSize: 20)),
                                            Padding(
                                                padding: EdgeInsets.all(10),
                                                child:
                                                    DropdownButtonHideUnderline(
                                                        child: DropdownButton<
                                                            String>(
                                                  value: dropdown(widget
                                                      .trips[index].visited),
                                                  icon: const Icon(
                                                      Icons.arrow_circle_down),
                                                  elevation: 16,
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20),
                                                  underline: Container(
                                                    height: 2,
                                                    color: Color.fromRGBO(
                                                        159, 224, 172, 1),
                                                  ),
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      if (newValue == "Yes")
                                                        widget.trips[index]
                                                            .visited = true;
                                                      else
                                                        widget.trips[index]
                                                            .visited = false;
                                                    });
                                                  },
                                                  items: <String>[
                                                    'Yes',
                                                    'No',
                                                  ].map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                      (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),
                                                )))
                                          ],
                                        ),
                                      )
                                      // SizedBox(height: 20),
                                      // Divider(),
                                    ],
                                  ))),
                              //  Text(title_for_list(widget.trips[index]),
                              //     style: TextStyle(fontSize: 20))),
                              onTap: () async {},
                              onLongPress: () {
                                showAlertDialog(
                                    context,
                                    "Delete destination",
                                    "Are you sure you dont't want to visit this tourist attraction anymore?",
                                    widget.trips[index].id!);
                              },
                              dense: false,

                              contentPadding: EdgeInsets.only(
                                  left: 10.0, right: 10.0, top: 35, bottom: 55),
                              visualDensity:
                                  VisualDensity.adaptivePlatformDensity,
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider();
                          },
                        ),
                      )
                    ]))),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            // elevation: 7,
            onPressed: () {
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
            },
            child: Container(
              alignment: Alignment.center,
              height: 40,
              width: SizeConfig.screenWidth! * 0.15,
              child: const Text(
                "Cancel",
                style: TextStyle(
                    color: Color.fromRGBO(54, 62, 74, 10),
                    fontWeight: FontWeight.bold),
              ),
            ),
            style: ElevatedButton.styleFrom(
                primary: Color.fromRGBO(159, 224, 172, 55),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
          ),
          ElevatedButton(
            // elevation: 7,
            onPressed: () async {
              try {
                addedTrips = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddTrip(
                              user: widget.user,
                              index: widget.journey.id!,
                            )));

                setState(() {
                  addedTrips.forEach((element) {
                    log(element.id!.toString());
                  });
                  log("nu e gol");
                  widget.trips.addAll(addedTrips);
                });
              } catch (_) {
                log("nu am trimis inapoi nimic de la add");
              }
            },
            child: Container(
              alignment: Alignment.center,
              height: 40,
              width: SizeConfig.screenWidth! * 0.15,
              child: const Text(
                "Add",
                style: TextStyle(
                    color: Color.fromRGBO(54, 62, 74, 10),
                    fontWeight: FontWeight.bold),
              ),
            ),
            style: ElevatedButton.styleFrom(
                primary: Color.fromRGBO(159, 224, 172, 55),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
          ),
          ElevatedButton(
            // elevation: 7,
            onPressed: () async {
              showAlertDialog(context, "Delete Trip",
                  "Are you sure you want to delete this trip?", 0);
            },
            child: Container(
              alignment: Alignment.center,
              height: 40,
              width: SizeConfig.screenWidth! * 0.15,
              child: const Text(
                "Delete trip",
                style: TextStyle(
                    color: Color.fromRGBO(54, 62, 74, 10),
                    fontWeight: FontWeight.bold),
              ),
            ),
            style: ElevatedButton.styleFrom(
                primary: Color.fromRGBO(159, 224, 172, 55),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
          ),
          ElevatedButton(
            // elevation: 7,
            onPressed: () async {
              try {
                if (widget.trips.length != 0) {
                  await appRepository.updateJouneyandTrips(
                      widget.journey, widget.trips);
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
              } catch (_) {
                log(_.toString());
              }
            },
            child: Container(
              alignment: Alignment.center,
              height: 40,
              width: SizeConfig.screenWidth! * 0.15,
              child: const Text(
                "Save changes",
                style: TextStyle(
                    color: Color.fromRGBO(54, 62, 74, 10),
                    fontWeight: FontWeight.bold),
              ),
            ),
            style: ElevatedButton.styleFrom(
                primary: Color.fromRGBO(159, 224, 172, 55),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
          ),
        ],
      ),
    );
  }

  String title_for_list(Trip t) {
    String s = "Name:" +
        t.name +
        "\n" +
        "Country: " +
        t.country +
        "\n" +
        "City: " +
        t.city +
        "\n" +
        "Visited: ";
    if (t.visited == false)
      s = s + "No";
    else
      s = s + "Yes";
    return s;
  }

  String dropdown(bool visited) {
    if (visited == true)
      return "Yes";
    else
      return "No";
  }

  showAlertDialog(BuildContext context, String title, String content, int nr) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
        // Navigator.pop(dialog)
      },
    );
    Widget continueButton = TextButton(
        child: Text("Yes"),
        onPressed: () async {
          //sterg tot
          if (nr == 0) {
            try {
              Navigator.of(context, rootNavigator: true).pop();
              widget.trips.forEach((element) {
                appRepository.deleteTrip(element.id!);
              });

              appRepository.deleteJourney(widget.journey.id!);
              final snackBar = SnackBar(
                content: Builder(builder: (context) {
                  return const Text('Trip deleted');
                }),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              List<TripDate> tr = [];
              TripDate delete = TripDate(name: "delete");
              Navigator.pop(context, tr);
              //Navigator.pop(context);
            } catch (_) {
              log(_.toString());
            }
          } else {
            Navigator.of(context, rootNavigator: true).pop();
            //  await appRepository.deleteTrip(nr);

            int ind = 0;
            for (int i = 0; i < widget.trips.length; i++) {
              if (widget.trips[i].id == nr) {
                // deletedTrips.add(Trip.clone(widget.trips[i]));

                await appRepository.deleteTrip(nr);

                ind = i;
              }
            }

            log(ind.toString());
            setState(() {
              log("sunt in setState");
              widget.trips.removeAt(ind);
            });
            final snackBar = SnackBar(
              content: Builder(builder: (context) {
                return const Text('Destination deleted');
              }),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        });

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _selectDate(BuildContext context, String st) async {
    DateTime date;
    DateTime firstdate;
    DateTime lastDate;
    if (st == 'start') {
      date = widget.journey.start_date;
      firstdate = DateTime(2020);
      lastDate = DateTime.now();
    } else {
      date = widget.journey.end_date;
      firstdate = DateTime.now();
      lastDate = DateTime(2025);
    }

    final DateTime? selected = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: firstdate,
        lastDate: lastDate,
        helpText: "Select the date when you start your trip");
    if (selected != null)
      setState(() {
        if (st == "start") {
          widget.journey.start_date = selected;
        } else
          widget.journey.end_date = selected;
      });
  }
}
