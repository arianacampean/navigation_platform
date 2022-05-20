import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/exceptie.dart';
import 'package:frontend/models/journey.dart';
import 'package:frontend/models/sizeConf.dart';
import 'package:frontend/models/trip.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/repository/app_repo.dart';
import 'package:frontend/repository/repo.dart';

class RecommendationsPage extends StatefulWidget {
  User user;
  RecommendationsPage({Key? key, required this.user}) : super(key: key);

  @override
  _RecommendationsPageState createState() => _RecommendationsPageState();
}

class _RecommendationsPageState extends State<RecommendationsPage> {
  //late User user;
  late Exceptie ex;
  late Repo repo;
  late AppRepository appRepository;
  String goodCredentials = "";
  bool isLoading = false;

  List<Journey> journeys = [];
  DateTime currentdate = DateTime.now();
  Journey currentJourney =
      Journey(start_date: DateTime(2019), end_date: DateTime(2019));
  List<Trip> trips = [];
  List<Trip> recomm = [];
  int index = 0;
  List<String> countrys = [];

  // late Color col_background;
  // late Color buttons_col;
  // late Color color_border;
  // late Color text_color;

  @override
  void initState() {
    super.initState();
    repo = Repo.repo;
    ex = Exceptie.ex;

    appRepository = AppRepository(repo);
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
          trips = await appRepository.getTripsByJouneyId(currentJourney);
          recomm = (await getTripsByCountry())!;

          recomm.sort((a, b) => a.country.compareTo(b.country));
          index++;
        } else {
          index++;
        }
      });
    } catch (_) {
      log(_.toString());
    }

    try {
      log("sunt in try");
      if (index == journeys.length || journeys.length == 0) {
        //sleep(Duration(seconds: 2));
        log("sunt in if");
        Trip t = Trip(
            latitude: 0,
            longitude: 0,
            city: "",
            country: "",
            name:
                "You don't have a current trip so we can't recommend you any destinations",
            visited: false);
        recomm.add(t);
        setState(() => isLoading = false);
        log(isLoading.toString());
      }
    } catch (_) {
      log("functie");
    }
  }

  Future<List<Trip>?> getTripsByCountry() async {
    log("sunt in functie");
    List<Trip> re = [];
    trips.forEach((element) {
      if (!countrys.contains(element.country)) {
        log(element.country + "asta am adugat");
        countrys.add(element.country);
      }
    });

    try {
      countrys.forEach((element) async {
        log("am adugat");
        List<Trip> reco = await appRepository.getTripsByCountry(element);

        reco.forEach((element) {
          int nr = 0;
          log(element.name);
          re.forEach((element2) {
            if (element2.name == element.name) nr = 1;
          });
          if (nr == 0) {
            trips.forEach((element3) {
              if (element3.name == element.name) nr = 1;
            });
          }
          if (nr == 0) {
            re.add(element);
          }
        });

        setState(() => isLoading = false);
        //recomm.addAll(reco);
      });

      log("am luat tripurile");
      return re;
    } catch (_) {
      log(_.toString());
      log("erare la getTripsBuJ");
    }
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
                                                recomm[index].name,
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
                            // separatorBuilder:
                            //     (BuildContext context, int index) {
                            //   return Divider();
                            // },
                          ),
                          // Center(
                          //     child: isLoading
                          //         ? CircularProgressIndicator()
                          //         : Container(
                          //             child: Column(
                          //               children: [
                          //                 SizedBox(
                          //                   height: SizeConfig.screenHeight! * 0.03,
                          //                 ),
                          //                 Text("Recommendations for your trip",
                          //                     style: TextStyle(fontSize: 22)),
                          //                 SizedBox(
                          //                   height: SizeConfig.screenHeight! * 0.03,
                          //                 ),
                          //                 Text(
                          //                     "Here are a couple of recommendations that are in the same country as your trip",
                          //                     style: TextStyle(fontSize: 18)),
                          //                 SizedBox(
                          //                   height: SizeConfig.screenHeight! * 0.03,
                          //                 ),
                          //                 if (currentJourney.start_date == DateTime(2019))
                          //                   Text(
                          //                       "Right now you don't have a current trip so we can't recommend anything to you",
                          //                       style: TextStyle(fontSize: 20)),
                          //                 // if (recomm.length == 0)
                          //                 //   Text("no recommendations",
                          //                 //       style: TextStyle(fontSize: 20)),
                          //                 if (recomm.length != 0)
                          //                   Expanded(
                          //                     child: ListView.separated(
                          //                       scrollDirection: Axis.vertical,
                          //                       addAutomaticKeepAlives: false,
                          //                       addSemanticIndexes: false,
                          //                       addRepaintBoundaries: false,
                          //                       shrinkWrap: true,
                          //                       itemCount: recomm.length,
                          //                       itemBuilder: (context, index) {
                          //                         return ListTile(
                          //                           title: Align(
                          //                               alignment: Alignment.center,
                          //                               child: Container(
                          //                                   child: Column(
                          //                                 children: [
                          //                                   Align(
                          //                                       alignment: Alignment.center,
                          //                                       child: Text(
                          //                                         recomm[index].name,
                          //                                         style: TextStyle(fontSize: 20),
                          //                                         textAlign: TextAlign.center,
                          //                                       )),
                          //                                 ],
                          //                               ))),
                          //                           onTap: () async {},
                          //                           dense: false,
                          //                           contentPadding: EdgeInsets.only(
                          //                               left: 20.0,
                          //                               right: 20.0,
                          //                               top: 10,
                          //                               bottom: 10),
                          //                           visualDensity:
                          //                               VisualDensity.adaptivePlatformDensity,
                          //                         );
                          //                       },
                          //                       // separatorBuilder:
                          //                       //     (BuildContext context, int index) {
                          //                       //   return Divider();
                          //                       // },
                          //                       separatorBuilder:
                          //                           (BuildContext context, int index) {
                          //                         return Divider(
                          //                           color: Color.fromRGBO(159, 224, 172, 1),
                          //                           height: 25,
                          //                           thickness: 2,
                          //                           indent: SizeConfig.screenWidth! * 0.2,
                          //                           endIndent: SizeConfig.screenWidth! * 0.2,
                          //                         );
                          //                       },
                          //   ),
                        )
                      ],
                    ),
                  )));
  }
}
