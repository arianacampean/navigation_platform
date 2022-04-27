import 'dart:developer';
import 'dart:io';

import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/settings.dart';
import 'package:frontend/models/sizeConf.dart';
import 'package:frontend/models/user.dart';
import 'package:image_picker/image_picker.dart';

class SecurityPage extends StatefulWidget {
  // Settings settings;
  User user;
  SecurityPage({Key? key, required this.user}) : super(key: key);

  @override
  _SecurityPageState createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  String goodInfo = "";
  late Color col_background;
  late Color buttons_col;
  late Color color_border;
  late Color text_color;
  late Color hover_color;

  final _formKey = GlobalKey<FormState>();
  final old_pass = TextEditingController();
  final new_pass = TextEditingController();
  final new_pass2 = TextEditingController();

  @override
  void initState() {
    super.initState();
    // repo = Repo.repo;
    // appRepository = AppRepository(repo);
    //getData();
    col_background = Colors.white;
    buttons_col = Color.fromRGBO(159, 224, 172, 1);
    color_border = Colors.white;
    text_color = Colors.black;
    hover_color = Color.fromRGBO(170, 224, 172, 1);
  }

  // Future getData() async {
  //   if (widget.settings.theme == "light") {
  //     col_background = Colors.white;
  //     buttons_col = Color.fromRGBO(159, 224, 172, 1);
  //     color_border = Colors.white;
  //     text_color = Colors.black;
  //     hover_color = Color.fromRGBO(170, 224, 172, 1);
  //   } else {
  //     col_background = Color.fromRGBO(38, 41, 40, 1);
  //     buttons_col = Color.fromRGBO(38, 41, 40, 1);
  //     color_border = Colors.black;
  //     text_color = Color.fromRGBO(159, 224, 172, 1);
  //     hover_color = Color.fromRGBO(138, 150, 142, 100000);
  //   }

  //   // setState(() => isLoading = false);
  // }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Security"),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return false;
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(3, 0, 3, 0),
          decoration: BoxDecoration(
            color: col_background,
          ),
          child: Form(
            key: _formKey,
            child: Container(
                child: ListView(children: [
              SizedBox(height: SizeConfig.blockSizeVertical! * 8),
              Text(
                "Change your password",
                textAlign: TextAlign.center,
                style: TextStyle(color: text_color, fontSize: 22),

                //color:text_color,
              ),
              Divider(
                color: Colors.black,
                height: 25,
                thickness: 2,
                indent: SizeConfig.screenWidth! * 0.07,
                endIndent: SizeConfig.screenWidth! * 0.07,
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.fromLTRB(5, 10, 0, 3),
                  child: Text(
                    "Fill in the fields below",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  )),
              SizedBox(
                height: 20,
              ),
              Container(
                  alignment: Alignment.center,
                  width: SizeConfig.screenWidth! * 0.3,
                  padding: EdgeInsets.fromLTRB(3, 10, 0, 3),
                  child: TextFormField(
                    validator: (old_pass) {
                      if (old_pass == null || old_pass.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    controller: old_pass,
                    obscureText: true,
                    decoration: InputDecoration(
                        fillColor: buttons_col,
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: color_border, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: color_border),
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        hintText: "Old password",
                        // focusColor: Color.fromRGBO(0, 115, 255, 100),
                        hoverColor: hover_color,
                        hintStyle: TextStyle(
                          color: text_color,
                          fontSize: 20,
                        )),
                    style: TextStyle(
                        fontSize: SizeConfig.screenHeight! * 0.025,
                        color: Colors.black),
                  )),
              Container(
                  alignment: Alignment.center,
                  width: SizeConfig.screenWidth! * 0.3,
                  padding: EdgeInsets.fromLTRB(3, 10, 0, 3),
                  child: TextFormField(
                    validator: (new_pass) {
                      if (new_pass == null || new_pass.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    obscureText: true,
                    controller: new_pass,
                    decoration: InputDecoration(
                      fillColor: buttons_col,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: color_border, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: color_border),
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      hintText: "New password",
                      // focusColor: Color.fromRGBO(0, 115, 255, 100),
                      hoverColor: hover_color,
                      hintStyle: TextStyle(
                        color: text_color,
                        fontSize: 20,
                      ),
                    ),
                    style: TextStyle(
                        fontSize: SizeConfig.screenHeight! * 0.025,
                        color: Colors.black),
                  )),
              Container(
                  alignment: Alignment.center,
                  width: SizeConfig.screenWidth! * 0.3,
                  padding: EdgeInsets.fromLTRB(3, 10, 0, 3),
                  child: TextFormField(
                    validator: (new_pass2) {
                      if (new_pass2 == null || new_pass2.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    obscureText: true,
                    controller: new_pass2,
                    decoration: InputDecoration(
                        fillColor: buttons_col,
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: color_border, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: color_border),
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        hintText: "Repeat new password",
                        // focusColor: Color.fromRGBO(0, 115, 255, 100),
                        hoverColor: hover_color,
                        hintStyle: TextStyle(
                          color: text_color,
                          fontSize: 20,
                        )),
                    style: TextStyle(
                        fontSize: SizeConfig.screenHeight! * 0.025,
                        color: Colors.black),
                  )),
              Container(
                alignment: Alignment.topLeft,
                //  / width: SizeConfig.screenWidth! * 0.3,
                padding: EdgeInsets.fromLTRB(5, 0, 0, 5),
                child: Text(goodInfo,
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: SizeConfig.screenHeight! * 0.02)),
              ),
              TextButton(
                onPressed: () async {
                  bool? verify = _formKey.currentState?.validate();
                  if (verify == true) {
                    try {
                      if (widget.user.password != old_pass.text) {
                        setState(() {
                          goodInfo = "The old password is not a match";
                        });
                      } else {
                        if (new_pass.text != new_pass2.text) {
                          setState(() {
                            goodInfo = "The passwords are not the same";
                          });
                        } else {
                          widget.user.password = new_pass.text;
                          Navigator.pop(context, widget.user);
                          final snackBar = SnackBar(
                            content: Builder(builder: (context) {
                              return const Text('Your changes are saved');
                            }),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      }
                    } catch (_) {
                      setState(() {
                        goodInfo = "This email is already signed up";
                      });
                    }
                  }
                },
                child: Text(
                  "Save changes",
                  style: TextStyle(fontSize: 20, color: text_color),
                ),
              ),
            ])),
          ),
        ),
      ),
    );
  }
}
