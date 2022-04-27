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
    try {
      journeys = await appRepository.getJouneysByUserId(widget.user);
      journeys.forEach((element) async {
        if (element.start_date.isBefore(currentdate) &&
            element.end_date.isAfter(currentdate)) {
          currentJourney = element;
          log("avem!!!!");
          trips = await appRepository.getTripsByJouneyId(currentJourney);
          recomm = (await getTripsByCountry())!;
          recomm.sort((a, b) => a.country.compareTo(b.country));
        }
      });
    } catch (_) {
      log(_.toString());

      //  exceptie.showAlertDialogExceptions(
      //context, "Eroare", "Nu se gasesc obiectele");
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

  Color col_background = Colors.white;
  Color buttons_col = Color.fromRGBO(159, 224, 172, 1);
  Color color_border = Colors.white;
  Color text_color = Colors.black;

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
                ? CircularProgressIndicator()
                : Container(
                    child: Column(
                      children: [
                        SizedBox(
                          height: SizeConfig.screenHeight! * 0.03,
                        ),
                        Text("Recommendations for your trip",
                            style: TextStyle(fontSize: 22)),
                        SizedBox(
                          height: SizeConfig.screenHeight! * 0.03,
                        ),
                        Text(
                            "Here are a couple of recommendations that are in the same country as your trip",
                            style: TextStyle(fontSize: 18)),
                        SizedBox(
                          height: SizeConfig.screenHeight! * 0.03,
                        ),
                        if (currentJourney.start_date == DateTime(2019))
                          Text("Right now you don't have a current trip",
                              style: TextStyle(fontSize: 20)),
                        if (recomm.length == 0)
                          Text("no recommendations",
                              style: TextStyle(fontSize: 20)),
                        if (recomm.length != 0)
                          Expanded(
                            child: ListView.separated(
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
                                          child: Column(
                                        children: [
                                          Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                recomm[index].name,
                                                style: TextStyle(fontSize: 20),
                                                textAlign: TextAlign.center,
                                              )),
                                        ],
                                      ))),
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
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return Divider(
                                  color: Color.fromRGBO(159, 224, 172, 1),
                                  height: 25,
                                  thickness: 2,
                                  indent: SizeConfig.screenWidth! * 0.2,
                                  endIndent: SizeConfig.screenWidth! * 0.2,
                                );
                              },
                            ),
                          )
                      ],
                    ),
                  )));
  }
}
