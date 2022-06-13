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

import 'add_trip_view.dart';

class HistoryPage extends StatefulWidget {

  User user;
  HistoryPage({Key? key, required this.user}) : super(key: key);
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String dropdownValue = 'Yes';
  bool isLoading = true;
  late Exceptie ex;
  late AppRepository appRepository;
  List<Trip> trips = [];
  List<Journey> journeys = [];

  @override
  void initState() {
    super.initState();
    ex = Exceptie.ex;
    appRepository = AppRepository();
    isLoading = true;
    getData();
  }

  //ia toate jouney-urile userlui si toate tripurile
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

  //face filtrarea tripurilor in functie de un id si le returneaza
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
                  ? CircularProgressIndicator(
                      backgroundColor: Color.fromRGBO(221, 209, 199, 1),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(75, 74, 103, 1),
                      ),
                      child: ListView(children: [
                    
                        Container(
                          height: SizeConfig.screenHeight! * 0.25,
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
                              Text(
                                "All your trips sorted by date",
                                style: TextStyle(
                                    fontSize: 25,
                                    color: Color.fromRGBO(221, 209, 199, 1)),
                              ),
                              Divider(
                                color: Color.fromRGBO(221, 209, 199, 1),
                                height: 10,
                                thickness: 1,
                                indent: SizeConfig.screenWidth! * 0.30,
                                endIndent: SizeConfig.screenWidth! * 0.30,
                              ),
                            ],
                          ),
                          alignment: Alignment.centerLeft,
                        ),

                        Container(
                          height: SizeConfig.screenHeight! * 0.65,
                          decoration: BoxDecoration(
                          
                            color: Color.fromRGBO(221, 209, 199, 1),
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            border: Border.all(
                            
                              color: Color.fromRGBO(194, 207, 178, 1),
                              width: 2,
                            ),

                          ),
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            addAutomaticKeepAlives: false,
                            addSemanticIndexes: false,
                            addRepaintBoundaries: false,
                            shrinkWrap: true,
                            itemCount: journeys.length,
                            itemBuilder: (context, index) {
                              List<Trip> new_tr =
                                  getTripByJourney(journeys[index].id!);
                              return ListTile(
                                title: Align(
                                    //  alignment: Alignment.center,
                                    child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(221, 209, 199, 1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50)),
                                          border: Border.all(
                                            color: Color.fromRGBO(
                                                141, 181, 128, 1),
                                           
                                            width: 2,
                                          ),
                                        ),
                                        width: SizeConfig.screenWidth! * 0.9,
                                      
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                alignment: Alignment.topLeft,
                                                width: SizeConfig.screenWidth! *
                                                    0.108,
                                                height:
                                                    SizeConfig.screenHeight! *
                                                        0.07,
                                                decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      194, 207, 178, 1),
                                               
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  70),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  70),
                                                          topLeft:
                                                              Radius.circular(
                                                                  70),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  70)),
                                                ),
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    width: SizeConfig
                                                            .screenWidth! *
                                                        0.094,
                                                    height: SizeConfig
                                                            .screenHeight! *
                                                        0.063,
                                                    decoration: BoxDecoration(
                                                     
                                                      color: Color.fromRGBO(
                                                          141, 181, 128, 1),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topRight:
                                                                  Radius
                                                                      .circular(
                                                                          100),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          100),
                                                              topLeft: Radius
                                                                  .circular(
                                                                      100),
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      100)),
                                                    ),
                                                    child: Icon(
                                                      Icons.list_alt_outlined,
                                                      color: Color.fromRGBO(
                                                          103, 112, 110, 1),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Flexible(
                                                  child: Text(
                                                "\n" +
                                                    "Date: " +
                                                    journeys[index]
                                                        .start_date
                                                        .toString()
                                                        .split(" ")[0] +
                                                    " ~ " +
                                                    journeys[index]
                                                        .end_date
                                                        .toString()
                                                        .split(" ")[0] +
                                                    "\n" +
                                                    "\n" +
                                                    getText(new_tr),
                                                style: TextStyle(
                                                    overflow: TextOverflow.clip,
                                                    fontSize: 23,
                                                    color: Colors.black),
                                                textAlign: TextAlign.center,
                                              )),
                                              SizedBox(
                                                width: 55,
                                              ),
                                            ]))),
                                onTap: () async {},
                                dense: false,
                                contentPadding: EdgeInsets.only(
                                    left: 20.0,
                                    right: 20.0,
                                    top: 10,
                                    bottom: 10),
                                visualDensity:
                                    VisualDensity.adaptivePlatformDensity,
                              );
                            },
                           
                          ),
                        )
                      ])))),
    );
  }

  //retruneaza un boolean in functie daca destinatia a fost sau nu vizitata
  String visited(bool yes) {
    if (yes == true) return 'Yes';
    return 'No';
  }

  //combina datele unei destinatii si returneaza un strig cu toate
  String getText(List<Trip> list) {
    String s = "";
    list.forEach((element) {
      s = s +
          " " +
          element.name +
          " \n" +
          " visited: " +
          visited(element.visited) +
          "\n";
    });
    return s;
  }
}
