import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/settings.dart';
import 'package:frontend/models/sizeConf.dart';
import 'package:frontend/models/user.dart';

import 'custom_settings_views/security_view.dart';
import 'custom_settings_views/theme_view.dart';

class SettingsPage extends StatefulWidget {
  Settings settings;
  User user;
  SettingsPage({Key? key, required this.settings, required this.user})
      : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late Color col_background;
  late Color buttons_col;
  late Color color_border;
  late Color text_color;

  @override
  void initState() {
    super.initState();
    // repo = Repo.repo;
    // appRepository = AppRepository(repo);
    getData();
  }

  Future getData() async {
    // log("iau datele de pe server pt prima pagina");
    // setState(() => isLoading = true);
    // try {
    //   settings = await appRepository.getSettingsForUser(widget.user.id!);
    // } catch (_) {
    //   log("nu gas setarea");

    //   //  exceptie.showAlertDialogExceptions(
    //   //context, "Eroare", "Nu se gasesc obiectele");
    // }
    if (widget.settings.theme == "light") {
      col_background = Colors.white;
      buttons_col = Color.fromRGBO(159, 224, 172, 1);
      color_border = Colors.white;
      text_color = Colors.black;
    } else {
      col_background = Color.fromRGBO(38, 41, 40, 1);
      buttons_col = Color.fromRGBO(38, 41, 40, 1);
      color_border = Colors.black;
      text_color = Color.fromRGBO(159, 224, 172, 1);
    }

    // setState(() => isLoading = false);
  }
  //dark theme

  // Color col_background = Color.fromRGBO(38, 41, 40, 1);
  // Color buttons_col = Color.fromRGBO(38, 41, 40, 1);
  // Color color_border = Colors.black;
  // Color text_color = Color.fromRGBO(159, 224, 172, 1);

  //light theme

  // Color col_background = Colors.white;
  // Color buttons_col = Color.fromRGBO(159, 224, 172, 1);
  // Color color_border = Colors.white;
  // Color text_color = Colors.black;
  // @override
  // void initState() {
  //   super.initState();
  //   // repo = Repo.repo;
  //   //  appRepository = AppRepository(repo);
  // }

  final email = TextEditingController();
  final pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        appBar: AppBar(),
        body: WillPopScope(
            onWillPop: () async {
              Navigator.pop(context, widget.settings);
              return false;
            },
            child: Container(
                padding: EdgeInsets.fromLTRB(3, 0, 3, 0),
                decoration: BoxDecoration(
                  color: col_background,
                ),
                child: ListView(
                  children: [
                    SizedBox(height: SizeConfig.blockSizeVertical! * 2),
                    ElevatedButton(
                        onPressed: () async {
                          try {
                            Settings sett = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ThemePage(
                                          settings: widget.settings,
                                        )));
                            setState(() {
                              widget.settings = sett;
                              getData();
                            });
                          } catch (_) {
                            log(_.toString());
                          }
                        },
                        child: Container(
                          width: SizeConfig.screenWidth!,
                          height: SizeConfig.screenHeight! * 0.09,
                          padding: EdgeInsets.fromLTRB(3, 10, 0, 3),
                          //alignment: AlignmentGeometry.lerp(a, b, t),
                          child: Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Theme",
                                  style: TextStyle(
                                      color: text_color,
                                      fontSize:
                                          SizeConfig.screenHeight! * 0.03),
                                  //textAlign: TextAlign.left,
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: text_color,
                                  size: SizeConfig.screenHeight! * 0.035,
                                )
                              ]),
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: buttons_col,
                            onPrimary: Colors.white,
                            side: BorderSide(
                              width: 1,
                              color: color_border,
                            ),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)))),
                    ElevatedButton(
                        onPressed: () async {
                          try {
                            User userr = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SecurityPage(
                                        settings: widget.settings,
                                        user: widget.user)));
                            log(userr.password!);
                            setState(() {
                              widget.user = userr;
                              getData();
                            });
                          } catch (_) {
                            log(_.toString());
                          }
                        },
                        child: Container(
                          width: SizeConfig.screenWidth!,
                          height: SizeConfig.screenHeight! * 0.09,
                          padding: EdgeInsets.fromLTRB(3, 10, 0, 3),
                          //alignment: AlignmentGeometry.lerp(a, b, t),
                          child: Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Security",
                                  style: TextStyle(
                                      color: text_color,
                                      fontSize:
                                          SizeConfig.screenHeight! * 0.03),
                                  //textAlign: TextAlign.left,
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: text_color,
                                  size: SizeConfig.screenHeight! * 0.035,
                                )
                              ]),
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: buttons_col,
                            onPrimary: Colors.white,
                            side: BorderSide(
                              width: 1,
                              color: color_border,
                            ),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)))),
                    ElevatedButton(
                        onPressed: () {},
                        child: Container(
                          width: SizeConfig.screenWidth!,
                          height: SizeConfig.screenHeight! * 0.09,
                          padding: EdgeInsets.fromLTRB(3, 10, 0, 3),
                          //alignment: AlignmentGeometry.lerp(a, b, t),
                          child: Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Altceva",
                                  style: TextStyle(
                                      color: text_color,
                                      fontSize:
                                          SizeConfig.screenHeight! * 0.03),
                                  //textAlign: TextAlign.left,
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: text_color,
                                  size: SizeConfig.screenHeight! * 0.035,
                                )
                              ]),
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: buttons_col,
                            onPrimary: Colors.white,
                            side: BorderSide(
                              width: 1,
                              color: color_border,
                            ),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)))),
                    ElevatedButton(
                        onPressed: () {},
                        child: Container(
                          width: SizeConfig.screenWidth!,
                          height: SizeConfig.screenHeight! * 0.09,
                          padding: EdgeInsets.fromLTRB(3, 10, 0, 3),
                          //alignment: AlignmentGeometry.lerp(a, b, t),
                          child: Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Altceva",
                                  style: TextStyle(
                                      color: text_color,
                                      fontSize:
                                          SizeConfig.screenHeight! * 0.03),
                                  //textAlign: TextAlign.left,
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: text_color,
                                  size: SizeConfig.screenHeight! * 0.035,
                                )
                              ]),
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: buttons_col,
                            onPrimary: Colors.white,
                            side: BorderSide(
                              width: 1,
                              color: color_border,
                            ),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)))),
                    ElevatedButton(
                        onPressed: () {},
                        child: Container(
                          width: SizeConfig.screenWidth!,
                          height: SizeConfig.screenHeight! * 0.09,
                          padding: EdgeInsets.fromLTRB(3, 10, 0, 3),
                          //alignment: AlignmentGeometry.lerp(a, b, t),
                          child: Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Altceva",
                                  style: TextStyle(
                                      color: text_color,
                                      fontSize:
                                          SizeConfig.screenHeight! * 0.03),
                                  //textAlign: TextAlign.left,
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: text_color,
                                  size: SizeConfig.screenHeight! * 0.035,
                                )
                              ]),
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: buttons_col,
                            onPrimary: Colors.white,
                            side: BorderSide(
                              width: 1,
                              color: color_border,
                            ),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)))),
                  ],
                ))));
  }
}
