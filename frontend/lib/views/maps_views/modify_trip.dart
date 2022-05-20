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
  List<Journey> journeys = [];
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    repo = Repo.repo;
    ex = Exceptie.ex;

    appRepository = AppRepository(repo);
    //  widget.journey.forEach((element) {
    //trips.add(element.trip);
    //  });

    getData();
    isLoading = false;
  }

  Future getData() async {
    try {
      journeys = await appRepository.getJouneysByUserId(widget.user);
      setState(() {
        isLoading = false;
      });
    } catch (_) {
      log(_.toString());
      log("eroare la luat journeys");
    }
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
                ? CircularProgressIndicator(
                    backgroundColor: Color.fromRGBO(221, 209, 199, 1),
                  )
                : Container(
                    // padding: EdgeInsets.fromLTRB(3, 0, 3, 0),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(75, 74, 103, 1),
                    ),
                    child: ListView(children: [
                      // SizedBox(
                      //   height: SizeConfig.screenHeight! * 0.15,
                      // ),
                      Container(
                        height: SizeConfig.screenHeight! * 0.25,
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

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                "Trip settings ",
                                style: TextStyle(
                                    fontSize: 25,
                                    color: Color.fromRGBO(221, 209, 199, 1)),
                              ),
                            ),
                            Flexible(
                              child: Divider(
                                color: Color.fromRGBO(221, 209, 199, 1),
                                height: 10,
                                thickness: 1,
                                indent: SizeConfig.screenWidth! * 0.4,
                                endIndent: SizeConfig.screenWidth! * 0.4,
                              ),
                            ),
                            Flexible(
                              child: SizedBox(
                                height: 20,
                              ),
                            ),

                            // Container(
                            //   padding: EdgeInsets.all(10),
                            //   height: SizeConfig.screenHeight! * 0.05,
                            //   child: Text(
                            //     "Change if you visited smth long press for delete,save after or cancel",
                            //     style: TextStyle(fontSize: 18),
                            //   ),
                            //   alignment: Alignment.center,
                            // ),
                            Flexible(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Start date: " +
                                          widget.journey.start_date
                                              .toString()
                                              .split(" ")[0],
                                      style: TextStyle(
                                          fontSize: 25,
                                          color:
                                              Color.fromRGBO(221, 209, 199, 1)),
                                    ),
                                    Flexible(
                                      child: TextButton(
                                          onPressed: () {
                                            _selectDate(context, "start");
                                          },
                                          child: Text("Change",
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  color: Color.fromRGBO(
                                                      194, 207, 178, 1)))),
                                    ),
                                  ]),
                            ),
                            // DatePickerDialog(
                            //     initialDate: widget.journey[0].start,
                            //     firstDate: DateTime.now(),
                            //     lastDate: DateTime(2025)),
                            Flexible(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                        "End date: " +
                                            widget.journey.end_date
                                                .toString()
                                                .split(" ")[0],
                                        style: TextStyle(
                                            fontSize: 25,
                                            color: Color.fromRGBO(
                                                221, 209, 199, 1))),
                                    Flexible(
                                      child: TextButton(
                                          onPressed: () {
                                            _selectDate(context, "end");
                                          },
                                          child: Text("Change",
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  color: Color.fromRGBO(
                                                      194, 207, 178, 1)))),
                                    ),
                                  ]),
                            ),
                            Flexible(
                              child: SizedBox(
                                height: 20,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                "Long press on the destination if you want to delete it",
                                style: TextStyle(
                                    fontSize: 23,
                                    color: Color.fromRGBO(221, 209, 199, 1)),
                              ),
                            ),
                            // SizedBox(
                            //   height: 15,
                            // )
                            //   ],
                            // ),

                            // Text(
                            //   "Here are a couple of recommendations that are in the same country as your trip",
                            //   style: TextStyle(
                            //       fontSize: 20,
                            //       color: Color.fromRGBO(221, 209, 199, 1)),
                            // ),
                          ],
                        ),
                        alignment: Alignment.centerLeft,
                      ),

                      Container(
                        height: SizeConfig.screenHeight! * 0.60,
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
                        // Center(
                        //     child: isLoading
                        //         ? CircularProgressIndicator()
                        //         : Column(children: [
                        //             Container(
                        //               height: SizeConfig.screenHeight! * 0.1,
                        //               child: Text(
                        //                 "Trip settings",
                        //                 style: TextStyle(fontSize: 20),
                        //               ),
                        //               alignment: Alignment.center,
                        //             ),
                        //             Container(
                        //               padding: EdgeInsets.all(10),
                        //               height: SizeConfig.screenHeight! * 0.05,
                        //               child: Text(
                        //                 "Change if you visited smth long press for delete,save after or cancel",
                        //                 style: TextStyle(fontSize: 18),
                        //               ),
                        //               alignment: Alignment.center,
                        //             ),
                        //             Row(
                        //               mainAxisAlignment: MainAxisAlignment.center,
                        //               children: [
                        //                 Text(
                        //                   "Start date: " +
                        //                       widget.journey.start_date
                        //                           .toString()
                        //                           .split(" ")[0],
                        //                   style: TextStyle(fontSize: 18),
                        //                 ),
                        //                 TextButton(
                        //                     onPressed: () {
                        //                       _selectDate(context, "start");
                        //                     },
                        //                     child: Text("Change",
                        //                         style: TextStyle(fontSize: 18))),
                        //                 // DatePickerDialog(
                        //                 //     initialDate: widget.journey[0].start,
                        //                 //     firstDate: DateTime.now(),
                        //                 //     lastDate: DateTime(2025)),
                        //                 Text(
                        //                     "End date: " +
                        //                         widget.journey.end_date
                        //                             .toString()
                        //                             .split(" ")[0],
                        //                     style: TextStyle(fontSize: 18)),
                        //                 TextButton(
                        //                     onPressed: () {
                        //                       _selectDate(context, "end");
                        //                     },
                        //                     child: Text("Change",
                        //                         style: TextStyle(fontSize: 18))),
                        //                 // SizedBox(
                        //                 //   height: 15,
                        //                 // )
                        //               ],
                        //             ),
                        // child: Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.trips.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              //leading: Image.asset('assets/images/imagess.jpg'),
                              title: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Column(children: [
                                    Container(
                                        // alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Color.fromRGBO(75, 74, 103, 1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50)),
                                        ),
                                        width: SizeConfig.screenWidth! * 0.9,
                                        height: SizeConfig.screenHeight! * 0.15,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Flexible(
                                                child: Text(
                                                    widget.trips[index].name,
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color: Color.fromRGBO(
                                                          221, 209, 199, 1),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ))),
                                            Divider(
                                              color: Color.fromRGBO(
                                                  141, 181, 128, 1),
                                              height: 10,
                                              thickness: 1,
                                              indent: SizeConfig.screenWidth! *
                                                  0.02,
                                              endIndent:
                                                  SizeConfig.screenWidth! *
                                                      0.02,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                // Align(
                                                //     alignment:
                                                //         Alignment.centerLeft,
                                                //   child:
                                                Text(
                                                  "Country: " +
                                                      widget.trips[index]
                                                          .country +
                                                      "    ",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: Color.fromRGBO(
                                                          221, 209, 199, 1)),
                                                ),

                                                // Align(
                                                //     alignment:
                                                //         Alignment.centerRight,
                                                //     child:
                                                Text(
                                                  "City: " +
                                                      widget.trips[index].city,
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: Color.fromRGBO(
                                                          221, 209, 199, 1)),
                                                  // )
                                                )
                                              ],
                                            ),
                                            SingleChildScrollView(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text("Visited: ",
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color: Color.fromRGBO(
                                                              221,
                                                              209,
                                                              199,
                                                              1))),
                                                  Align(
                                                      alignment:
                                                          Alignment.center,
                                                      // padding: EdgeInsets.all(10),
                                                      child:
                                                          DropdownButtonHideUnderline(
                                                              child: new Theme(
                                                                  data: Theme.of(
                                                                          context)
                                                                      .copyWith(
                                                                    canvasColor:
                                                                        Color.fromRGBO(
                                                                            103,
                                                                            112,
                                                                            110,
                                                                            1),
                                                                  ),
                                                                  child:
                                                                      DropdownButton<
                                                                          String>(
                                                                    value: dropdown(widget
                                                                        .trips[
                                                                            index]
                                                                        .visited),
                                                                    icon: const Icon(
                                                                        Icons
                                                                            .arrow_circle_down,
                                                                        color: Color.fromRGBO(
                                                                            221,
                                                                            209,
                                                                            199,
                                                                            1)),
                                                                    elevation:
                                                                        16,
                                                                    style: const TextStyle(
                                                                        color: Color.fromRGBO(
                                                                          221,
                                                                          209,
                                                                          199,
                                                                          1,
                                                                        ),
                                                                        fontSize: 20),
                                                                    underline:
                                                                        Container(
                                                                      height: 2,
                                                                      color: Color.fromRGBO(
                                                                          221,
                                                                          209,
                                                                          199,
                                                                          1),
                                                                    ),
                                                                    onChanged:
                                                                        (String?
                                                                            newValue) {
                                                                      setState(
                                                                          () {
                                                                        if (newValue ==
                                                                            "Yes")
                                                                          widget
                                                                              .trips[index]
                                                                              .visited = true;
                                                                        else
                                                                          widget
                                                                              .trips[index]
                                                                              .visited = false;
                                                                      });
                                                                    },
                                                                    items: <
                                                                        String>[
                                                                      'Yes',
                                                                      'No',
                                                                    ].map<
                                                                        DropdownMenuItem<
                                                                            String>>((String
                                                                        value) {
                                                                      return DropdownMenuItem<
                                                                          String>(
                                                                        value:
                                                                            value,
                                                                        child: Text(
                                                                            value),
                                                                      );
                                                                    }).toList(),
                                                                  ))))
                                                ],
                                              ),
                                            )
                                          ],
                                        )),
                                  ]),
                                ),
                              ),
                              //  Text(title_for_list(widget.trips[index]),
                              //     style: TextStyle(fontSize: 20))),
                              onTap: () async {},
                              onLongPress: () {
                                showAlertDialog(
                                    context,
                                    "Delete destination",
                                    "Are you sure you don't want to visit this tourist attraction anymore?",
                                    widget.trips[index].id!);
                              },
                              dense: false,

                              contentPadding: EdgeInsets.only(
                                  left: 20.0, right: 20.0, top: 10, bottom: 10),
                              visualDensity:
                                  VisualDensity.adaptivePlatformDensity,
                            );
                          },

                          // ),
                          //  ),
                        ),
                        //),
                      ),
                    ]))),
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
            icon: Icon(Icons.add),
            label: 'Add destination',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.delete),
            label: 'Delete trip',
            // backgroundColor: Color.fromRGBO(194, 207, 178, 1),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.save),
            label: 'Save changes',
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
        log("eraore la add in modify");
      }
    }
    if (_selectedIndex == 1) {
      showAlertDialog(context, "Delete Trip",
          "Are you sure you want to delete this trip?", 0);
    }
    if (_selectedIndex == 2) {
      try {
        if (verifyDate(widget.journey.start_date, widget.journey.end_date) ==
            true) {
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
        }
      } catch (_) {
        log(_.toString());
      }
    }
    log(_selectedIndex.toString());
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
              tr.add(delete);
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
      backgroundColor: Color.fromRGBO(221, 209, 199, 1),
      title: Text(title,
          style:
              TextStyle(fontSize: 23, color: Color.fromRGBO(75, 74, 103, 1))),
      content: Text(content,
          style:
              TextStyle(fontSize: 23, color: Color.fromRGBO(75, 74, 103, 1))),
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
    String helpText = "";
    if (st == 'start') {
      date = widget.journey.start_date;
      firstdate = DateTime(2020);
      lastDate = DateTime.now();
      helpText = "Select the date when you start your trip";
    } else {
      date = widget.journey.end_date;
      firstdate = DateTime.now();
      lastDate = DateTime(2025);
      helpText = "Select the date when you end your trip";
    }

    final DateTime? selected = await showDatePicker(
        context: context,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Color.fromRGBO(103, 112, 110, 1),
                onPrimary: Color.fromRGBO(221, 209, 199, 1),
                //   onPrimary: Color.fromRGBO(103, 112, 110, 1),
                // secondary: Color.fromRGBO(221, 209, 199, 1),
                // onSurface: Colors.black,
              ),
              dialogBackgroundColor: Color.fromRGBO(221, 209, 199, 1),
            ),
            child: child!,
          );
        },
        initialDate: date,
        firstDate: firstdate,
        lastDate: lastDate,
        helpText: helpText);

    if (selected != null)
      setState(() {
        if (st == "start") {
          widget.journey.start_date = selected;
        } else
          widget.journey.end_date = selected;
      });
  }

  bool verifyDate(
      DateTime selectedDate_to_Start, DateTime selectedDate_to_End) {
    int count = 0;
    bool same = false;

    journeys.forEach((element) {
      if (element.start_date.day == selectedDate_to_Start.day &&
          element.start_date.month == selectedDate_to_Start.month &&
          element.start_date.year == selectedDate_to_Start.year &&
          element.end_date.day == selectedDate_to_End.day &&
          element.end_date.month == selectedDate_to_End.month &&
          element.end_date.year == selectedDate_to_End.year) same = true;

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
    if (same == true) return true;
    if (count != 0) {
      ex.showAlertDialogExceptions(context, "Information",
          "You alerady have a trip in those dates. Please add another ones");
      return false;
    }
    return true;
  }
}
