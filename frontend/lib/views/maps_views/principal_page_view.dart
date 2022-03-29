import 'dart:developer';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/settings.dart';
import 'package:frontend/models/sizeConf.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/repository/app_repo.dart';
import 'package:frontend/repository/repo.dart';
import 'package:frontend/views/profile_view.dart';
import 'package:frontend/views/settings_view.dart';

class PrincipalPage extends StatefulWidget {
  //User user;
  PrincipalPage({
    Key? key,
    //required this.user
  }) : super(key: key);

  @override
  _PrincipalPageState createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {
  CarouselController buttonCarouselController = CarouselController();
  //late User user;
  late Repo repo;
  late AppRepository appRepository;
  String goodCredentials = "";
  bool isLoading = false;
  late Settings settings;

  // late Color col_background;
  // late Color buttons_col;
  // late Color color_border;
  // late Color text_color;

  @override
  void initState() {
    super.initState();
    repo = Repo.repo;
    appRepository = AppRepository(repo);
    // col_background = Colors.white;
    // buttons_col = Color.fromRGBO(159, 224, 172, 1);
    // color_border = Colors.white;
    // text_color = Colors.black;
    // getData();
  }

  // Future getSettings() async {
  //   if (settings.theme == "light") {
  //     col_background = Colors.white;
  //     buttons_col = Color.fromRGBO(159, 224, 172, 1);
  //     color_border = Colors.white;
  //     text_color = Colors.black;
  //   } else {
  //     col_background = Color.fromRGBO(38, 41, 40, 1);
  //     buttons_col = Color.fromRGBO(38, 41, 40, 1);
  //     color_border = Colors.black;
  //     text_color = Color.fromRGBO(159, 224, 172, 1);
  //   }
  // }

  // Future getData() async {
  //   // log("iau datele de pe server pt prima pagina");
  //   setState(() => isLoading = true);
  //   try {
  //     settings = await appRepository.getSettingsForUser(widget.user.id!);
  //   } catch (_) {
  //     log(_.toString());

  //     //  exceptie.showAlertDialogExceptions(
  //     //context, "Eroare", "Nu se gasesc obiectele");
  //   }
  //   getSettings();
  //   setState(() => isLoading = false);
  // }

  //dark theme

  // Color col_background = Color.fromRGBO(38, 41, 40, 1);
  // Color buttons_col = Color.fromRGBO(38, 41, 40, 1);
  // Color color_border = Colors.black;
  // Color text_color = Color.fromRGBO(159, 224, 172, 1);

  //light theme

  Color col_background = Colors.white;
  Color buttons_col = Color.fromRGBO(159, 224, 172, 1);
  Color color_border = Colors.white;
  Color text_color = Colors.black;

  //trebuie sa iei tabelul de setari si sa trimiti la celelalte-Userul,thema momentan
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("GFG Slider"),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : Container(
                // padding: EdgeInsets.fromLTRB(3, 0, 3, 0),
                decoration: BoxDecoration(
                  color: col_background,
                ),
                child: ListView(
                  children: [
                    SizedBox(
                      height: SizeConfig.screenHeight! * 0.15,
                    ),
                    Container(
                      child: Text(
                        "aici o sa fie current tripul",
                      ),
                      alignment: Alignment.center,
                    ),

                    SizedBox(
                      height: SizeConfig.screenHeight! * 0.18,
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(
                          0, 0, 0, SizeConfig.screenHeight! * 0.02),
                      height: SizeConfig.screenHeight! * 0.07,
                      child: Text("My Trips",
                          style: TextStyle(
                            color: Colors.black,
                          )),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        border: Border.all(color: color_border),
                        //  borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    // SizedBox(
                    //   height: SizeConfig.screenHeight! * 0.05,
                    // ),

                    SizedBox(width: SizeConfig.screenWidth! * 0.02),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: ElevatedButton(
                          onPressed: () {},
                          child: Column(
                              // width: SizeConfig.screenWidth! * 0.1,
                              // height: SizeConfig.screenHeight! * 0.1,
                              children: [
                                Container(
                                    padding: EdgeInsets.all(10),
                                    width: SizeConfig.screenWidth! * 0.35,
                                    height: SizeConfig.screenHeight! * 0.15,
                                    child:
                                        Image.asset('assets/images/add.png')),
                                Container(
                                    padding: EdgeInsets.fromLTRB(3, 0, 3, 3),
                                    child: Text(
                                      "Add a new trip",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize:
                                              SizeConfig.screenHeight! * 0.018),
                                    )),
                              ]),
                          style: ElevatedButton.styleFrom(
                              primary: Color.fromRGBO(159, 224, 172, 10),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0)))),
                    ),
                    SizedBox(width: SizeConfig.screenWidth! * 0.01),
                    SizedBox(width: SizeConfig.screenWidth! * 0.01),

                    Container(
                      padding: EdgeInsets.all(10),
                      child: ElevatedButton(
                          onPressed: () {},
                          child: Column(
                              // width: SizeConfig.screenWidth! * 0.1,
                              // height: SizeConfig.screenHeight! * 0.1,
                              children: [
                                Container(
                                    padding: EdgeInsets.all(10),
                                    width: SizeConfig.screenWidth! * 0.35,
                                    height: SizeConfig.screenHeight! * 0.15,
                                    child: Image.asset(
                                        'assets/images/history.png')),
                                Container(
                                    padding: EdgeInsets.fromLTRB(3, 0, 3, 3),
                                    child: Text(
                                      "History",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize:
                                              SizeConfig.screenHeight! * 0.018),
                                    )),
                              ]),
                          style: ElevatedButton.styleFrom(
                              primary: Color.fromRGBO(0, 115, 255, 150),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0)))),
                    ),
                    SizedBox(width: SizeConfig.screenWidth! * 0.02)
                    //  height: SizeConfig.screenHeight! * 0.08,
                    // ),

                    // SizedBox(height: SizeConfig.screenHeight! * 0.02),

                    // Wrap(alignment: WrapAlignment.center, children: [
                    //   SizedBox(width: SizeConfig.screenWidth! * 0.02),
                    //   ElevatedButton(
                    //       onPressed: () async {
                    //         try {
                    //           await Navigator.push(
                    //               context,
                    //               MaterialPageRoute(
                    //                   builder: (context) => ProfilePage(
                    //                         settings: settings,
                    //                         user: widget.user,
                    //                       )));
                    //           setState(() {
                    //             // settings = setting;
                    //             // getSettings();
                    //           });
                    //         } catch (_) {
                    //           log(_.toString());
                    //         }
                    //       },
                    //       child: Column(
                    //           // width: SizeConfig.screenWidth! * 0.1,
                    //           // height: SizeConfig.screenHeight! * 0.1,
                    //           children: [
                    //             Container(
                    //                 padding: EdgeInsets.all(10),
                    //                 width: SizeConfig.screenWidth! * 0.35,
                    //                 height: SizeConfig.screenHeight! * 0.15,
                    //                 child:
                    //                     Image.asset('assets/images/user.png')),
                    //             Container(
                    //                 padding: EdgeInsets.fromLTRB(3, 0, 3, 3),
                    //                 child: Text(
                    //                   "Profile",
                    //                   style: TextStyle(
                    //                       color: Colors.black, fontSize: 10),
                    //                 )),
                    //           ]),
                    //       style: ElevatedButton.styleFrom(
                    //           primary: Color.fromRGBO(0, 115, 255, 100),
                    //           shape: RoundedRectangleBorder(
                    //               borderRadius: BorderRadius.circular(0)))),
                    //   SizedBox(width: SizeConfig.screenWidth! * 0.01),
                    //   SizedBox(width: SizeConfig.screenWidth! * 0.01),
                    //   ElevatedButton(
                    //       onPressed: () async {
                    //         try {
                    //           Settings setting = await Navigator.push(
                    //               context,
                    //               MaterialPageRoute(
                    //                   builder: (context) => SettingsPage(
                    //                       settings: settings,
                    //                       user: widget.user)));
                    //           setState(() {
                    //             settings = setting;
                    //             getSettings();
                    //           });
                    //         } catch (_) {
                    //           log(_.toString());
                    //         }
                    //       },
                    //       child: Column(
                    //           // width: SizeConfig.screenWidth! * 0.1,
                    //           // height: SizeConfig.screenHeight! * 0.1,
                    //           children: [
                    //             Container(
                    //                 padding: EdgeInsets.all(10),
                    //                 width: SizeConfig.screenWidth! * 0.35,
                    //                 height: SizeConfig.screenHeight! * 0.15,
                    //                 child: Image.asset(
                    //                     'assets/images/settings.png')),
                    //             Container(
                    //                 padding: EdgeInsets.fromLTRB(3, 0, 3, 3),
                    //                 child: Text(
                    //                   "Settings",
                    //                   style: TextStyle(
                    //                       color: Colors.black, fontSize: 10),
                    //                 )),
                    //           ]),
                    //       style: ElevatedButton.styleFrom(
                    //           primary: Color.fromRGBO(0, 115, 255, 150),
                    //           shape: RoundedRectangleBorder(
                    //               borderRadius: BorderRadius.circular(0)))),
                    //   SizedBox(width: SizeConfig.screenWidth! * 0.02)
                    //   //  height: SizeConfig.screenHeight! * 0.08,
                    // ])
                  ],
                ),
              ),
      ),
    );
  }
}
