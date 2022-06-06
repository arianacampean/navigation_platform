import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'package:simple_cluster/src/dbscan.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/exceptie.dart';
import 'package:frontend/models/journey.dart';
import 'package:frontend/models/sizeConf.dart';
import 'package:frontend/models/trip.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/repository/app_repo.dart';
import 'package:kmeans/kmeans.dart';

class RecommendationsPage extends StatefulWidget {
  User user;
  RecommendationsPage({Key? key, required this.user}) : super(key: key);

  @override
  _RecommendationsPageState createState() => _RecommendationsPageState();
}

class _RecommendationsPageState extends State<RecommendationsPage> {
  //late User user;
  late Exceptie ex;
  List<String> cluster = [
    "Cathedral",
    "Museum",
    "Palce",
    "Square",
    "Gallery",
    "Zoo",
    "Tower",
    "Park"
  ];
  Map<String, List<int>> categories = {};

  late AppRepository appRepository;
  String goodCredentials = "";
  bool isLoading = false;

  List<Journey> journeys = [];
  List<Journey> all_journeys = [];
  DateTime currentdate = DateTime.now();
  Journey currentJourney =
      Journey(start_date: DateTime(2019), end_date: DateTime(2019));
  List<Trip> trips = [];
  List<Trip> all_trips = [];
  List<String> recomm = [];
  int index = 0;
  List<String> countries = [];

  @override
  void initState() {
    super.initState();

    ex = Exceptie.ex;

    appRepository = AppRepository();
    getData();
  }

  Future getData() async {
    // log("iau datele de pe server pt prima pagina");
    setState(() => isLoading = true);
    int index = 0;
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
          try {
            trips = await appRepository.getTripsByJouneyId(currentJourney);

            index++;
            all_journeys = (await getAllJourneys())!;
            all_trips = (await getAllTrips())!;
            recomm = getSimilarity();

            setState(() {
              isLoading = false;
            });
          } catch (_) {
            log(_.toString());
            ex.showAlertDialogExceptions(context, "Error",
                "Something went wrong. We couldn't find any recommendations");
            Navigator.pop(context);
            //Navigator.pop();
          }
        } else {
          index++;
        }
      });
    } catch (_) {
      ex.showAlertDialogExceptions(context, "Error",
          "Something went wrong. We couldn't find any recommendations");
      Navigator.pop(context);
    }

    try {
      log("sunt in try");
      if (index == journeys.length || journeys.length == 0) {
        //sleep(Duration(seconds: 2));
        log("sunt in if");
        String t =
            "You don't have a current trip so we can't recommend you any destinations";

        recomm.add(t);
        setState(() => isLoading = false);
        log(isLoading.toString());
      }
    } catch (_) {
      log("functie");
      ex.showAlertDialogExceptions(context, "Error",
          "Something went wrong. We couldn't find any recommendations");
      Navigator.pop(context);
    }
  }

  Future<List<Trip>?> getAllTrips() async {
    try {
      all_trips = await appRepository.getallTrips();
      return all_trips;
    } catch (_) {
      log("ex la date dupa tara");
      ex.showAlertDialogExceptions(context, "Error",
          "Something went wrong. We couldn't find any recommendations");
      Navigator.pop(context);
    }
  }

  List<String> getTripsRecom(List<int> similarity) {
    // all_trips = await appRepository.getallTrips();
    log("sunt in functie la recom");
    List<Trip> re = [];
    trips.forEach((element) {
      if (!countries.contains(element.country)) {
        countries.add(element.country);
      }
    });
    List<String> reco = [];
    all_trips.forEach((element) {
      countries.forEach((coun) {
        if (element.country == coun) {
          similarity.forEach((simi) {
            if (element.id_journey == simi) {
              if (!reco.contains(element.name)) reco.add(element.name);
            }
          });
        }
      });
    });
    List<String> ind = [];
    for (int i = 0; i < reco.length; i++) {
      trips.forEach((element) {
        if (reco[i] == element.name) ind.add(element.name);
      });
    }
    ind.forEach((element) {
      reco.remove(element);
    });

    return reco;
  }

  List<String> getSimilarity() {
    log("sunt in functie");
    Map<int, int> map = getUserId();
    int index = 0;

    cluster.forEach((element_cat) {
      all_trips.forEach((element) {
        String name = element.name.split(",")[0];
        element_cat = element_cat.toLowerCase();
        name = name.toLowerCase();
        if (name.contains(element_cat)) {
          int? id = map[element.id_journey];
          if (categories.containsKey(element_cat)) {
            List<int>? li = categories[element_cat];
            if (!li!.contains(id!)) li.add(id);
            final entries = <String, List<int>>{element_cat: li};
            categories.addEntries(entries.entries);
            index++;
          } else {
            List<int> li = [];
            li.add(id!);
            final entries = <String, List<int>>{element_cat: li};
            categories.addEntries(entries.entries);
            index++;
          }
        }
        if (index == 0) {
          int? id = map[element.id_journey];
          if (categories.containsKey("other")) {
            List<int>? li = categories["other"];
            if (!li!.contains(id)) li.add(id!);
            final entries = <String, List<int>>{"other": li};
            categories.addEntries(entries.entries);
            index++;
          } else {
            List<int> li = [];
            li.add(id!);
            final entries = <String, List<int>>{"other": li};
            categories.addEntries(entries.entries);
            index++;
          }
        }
        index = 0;
      });
    });
    List<int> similarity = FindSimilarity();
    List<int> good_id = [];
    all_journeys.forEach((element) {
      similarity.forEach((element_sim) {
        if (element.id_user == element_sim) {
          log(element.id!.toString());
          good_id.add(element.id!);
        }
        ;
      });
    });
    List<String> tr = getTripsRecom(good_id);
    if (tr.length == 0) {
      String t =
          "You don't have a current trip so we can't recommend you any destinations";
      tr.add(t);
    }

    return tr;
  }

  List<int> FindSimilarity() {
    Map<int, int> simi = {};
    categories.forEach((key, value) {
      if (value.contains(widget.user.id)) {
        List<int>? values = categories[key];
        values!.forEach((element) {
          if (simi.containsKey(element)) {
            int? nr = simi[element];
            int new_nr = nr! + 1;
            final entries = <int, int>{element: new_nr};
            simi.addEntries(entries.entries);
          } else {
            final entries = <int, int>{element: 1};
            simi.addEntries(entries.entries);
          }
        });
      }
    });
    List<int> good_ids = [];
    simi.forEach((key, value) {
      if (value >= 3 && key != widget.user.id) good_ids.add(key);
    });
    return good_ids;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Recommendations"),
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
                              Text(
                                "Recommendations for your current trip ",
                                style: TextStyle(
                                    fontSize: 25,
                                    color: Color.fromRGBO(221, 209, 199, 1)),
                              ),
                              Divider(
                                color: Color.fromRGBO(221, 209, 199, 1),
                                height: 10,
                                thickness: 1,
                                indent: SizeConfig.screenWidth! * 0.22,
                                endIndent: SizeConfig.screenWidth! * 0.22,
                              ),
                              // SizedBox(
                              //   height: 20,
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
                          height: SizeConfig.screenHeight! * 0.65,
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

                          //   child: Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            addAutomaticKeepAlives: false,
                            addSemanticIndexes: false,
                            addRepaintBoundaries: false,
                            shrinkWrap: true,
                            itemCount: recomm.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Align(
                                    alignment: Alignment.center,
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
                                            // color:
                                            //     Color.fromRGBO(75, 74, 103, 1),
                                            width: 2,
                                          ),
                                        ),
                                        width: SizeConfig.screenWidth! * 0.9,
                                        height: SizeConfig.screenHeight! * 0.07,
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                // alignment: Alignment.topLeft,
                                                width: SizeConfig.screenWidth! *
                                                    0.108,
                                                height:
                                                    SizeConfig.screenHeight! *
                                                        0.07,
                                                decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      194, 207, 178, 1),
                                                  //      borderRadius: BorderRadius.all(
                                                  // Radius.circular(50)),
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
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Container(
                                                    width: SizeConfig
                                                            .screenWidth! *
                                                        0.094,
                                                    height: SizeConfig
                                                            .screenHeight! *
                                                        0.063,
                                                    decoration: BoxDecoration(
                                                      //color: Colors.red,
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
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Flexible(
                                                  child: Text(
                                                recomm[index],
                                                style: TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    fontSize: 23,
                                                    color: Colors.black),
                                                textAlign: TextAlign.center,
                                              ))
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
                      ],
                    ),
                  )));
  }

  Map<int, int> getUserId() {
    Map<int, int> map = {};
    List<int> list = [];

    all_journeys.forEach((element) {
      {
        int id = element.id!;
        final newEntries = <int, int>{id: element.id_user!};
        map.addEntries(newEntries.entries);
      }
    });
    return map;
  }

  Future<List<Journey>?> getAllJourneys() async {
    try {
      return await appRepository.getJouneys();
    } catch (_) {
      log("ex la date dupa all jouneys");
      ex.showAlertDialogExceptions(context, "Error",
          "Something went wrong. We couldn't find any recommendations");
      Navigator.pop(context);
    }
  }
}
