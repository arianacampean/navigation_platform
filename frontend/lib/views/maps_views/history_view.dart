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

class HistoryPage extends StatefulWidget {
  // List<Trip> trips;
  User user;

  HistoryPage({Key? key, required this.user}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String dropdownValue = 'Yes';
//  List<Trip> trips = [];
  bool isLoading = true;
  late Repo repo;
  late Exceptie ex;
  late AppRepository appRepository;
  List<Trip> trips = [];
  List<Journey> journeys = [];

  @override
  void initState() {
    super.initState();
    repo = Repo.repo;
    ex = Exceptie.ex;

    appRepository = AppRepository(repo);
    //  widget.journey.forEach((element) {
    //trips.add(element.trip);
    //  });
    isLoading = true;
    getData();
  }

  Future getData() async {
    try {
      journeys = await appRepository.getJouneysByUserId(widget.user);
      journeys.sort((a, b) => a.start_date.compareTo(b.start_date));
      trips = await appRepository.getallTrips();
    } catch (_) {
      log(_.toString());
      log("eroare la luat journeys");
    }
    setState(() {
      isLoading = false;
    });
  }

  List<Trip> getTripByJourney(int id) {
    List<Trip> trip = [];
    trips.forEach((element) {
      if (element.id_journey == id) trip.add(element);
    });
    return trip;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(),
      body: WillPopScope(
          onWillPop: () async {
            Navigator.pop(context);
            return false;
          },
          child: Center(
              child: isLoading
                  ? CircularProgressIndicator()
                  : Column(children: [
                      Container(
                        height: SizeConfig.screenHeight! * 0.1,
                        child: Text(
                          "All your trips sorted by date",
                          style: TextStyle(fontSize: 22),
                        ),
                        alignment: Alignment.center,
                      ),
                      Expanded(
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: journeys.length,
                          itemBuilder: (context, index) {
                            List<Trip> new_tr =
                                getTripByJourney(journeys[index].id!);
                            return ListTile(
                              //leading: Image.asset('assets/images/imagess.jpg'),
                              title: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                      child: Column(
                                    children: [
                                      Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Date: " +
                                                journeys[index]
                                                    .start_date
                                                    .toString()
                                                    .split(" ")[0] +
                                                " ~ " +
                                                journeys[index]
                                                    .end_date
                                                    .toString()
                                                    .split(" ")[0],
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
                                      Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            getText(new_tr),
                                            style: TextStyle(fontSize: 20),
                                            textAlign: TextAlign.center,
                                          )),
                                    ],
                                  ))),
                              //  Text(title_for_list(widget.trips[index]),
                              //     style: TextStyle(fontSize: 20))),
                              onTap: () async {},

                              dense: false,

                              contentPadding: EdgeInsets.only(
                                  left: 20.0, right: 20.0, top: 20, bottom: 20),
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
    );
  }

  String visited(bool yes) {
    if (yes == true) return 'Yes';
    return 'No';
  }

  String getText(List<Trip> list) {
    String s = "";
    list.forEach((element) {
      s = s +
          " " +
          element.name +
          " \n" +
          " visited: " +
          visited(element.visited) +
          "\n" +
          "\n";
    });
    return s;
  }
}
