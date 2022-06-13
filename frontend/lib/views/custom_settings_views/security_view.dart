import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:frontend/models/sizeConf.dart';
import 'package:frontend/models/user.dart';
import '../../models/exceptie.dart';
import '../../repository/app_repo.dart';

class SecurityPage extends StatefulWidget {
  User user;
  SecurityPage({Key? key, required this.user}) : super(key: key);

  @override
  _SecurityPageState createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  String goodInfo = "";
  late Exceptie ex;
  late AppRepository appRepository;

  final _formKey = GlobalKey<FormState>();
  final old_pass = TextEditingController();
  final new_pass = TextEditingController();
  final new_pass2 = TextEditingController();

  @override
  void initState() {
    super.initState();
    appRepository = AppRepository();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Security"),
        ),
        body: WillPopScope(
            onWillPop: () async {
              Navigator.pop(context, widget.user);
              return false;
            },
            child: Stack(children: [
              Container(
                  // padding: EdgeInsets.fromLTRB(3, 0, 3, 0),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(75, 74, 103, 1),
                  ),
                  child: ListView(children: [
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
                            "Change your password",
                            style: TextStyle(
                                fontSize: 25,
                                color: Color.fromRGBO(221, 209, 199, 1)),
                          ),
                          Divider(
                            color: Color.fromRGBO(221, 209, 199, 1),
                            height: 10,
                            thickness: 1,
                            indent: SizeConfig.screenWidth! * 0.32,
                            endIndent: SizeConfig.screenWidth! * 0.32,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            widget.user.first_name +
                                " " +
                                widget.user.last_name,
                            style: TextStyle(
                                fontSize: 25,
                                color: Color.fromRGBO(221, 209, 199, 1)),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                    Container(
                      height: SizeConfig.screenHeight! * 0.58,
                      decoration: BoxDecoration(
                        //color: Color.fromRGBO(221, 209, 199, 1),
                        color: Color.fromRGBO(221, 209, 199, 1),
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        border: Border.all(
                          //color: Color.fromRGBO(126, 137, 135, 1),
                          color: Color.fromRGBO(194, 207, 178, 1),
                          width: 2,
                        ),
                      ),
                      child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                              Container(
                                alignment: Alignment.center,
                                child: Image.asset(
                                  'assets/images/passw.png',
                                  width: SizeConfig.screenHeight! * 0.2,
                                ),
                              ),
                              Container(
                                  // alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.fromLTRB(5, 10, 0, 3),
                                  child: Text(
                                    "Fill in the fields below",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                                  )),
                              Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.fromLTRB(
                                      SizeConfig.screenWidth! * 0.07,
                                      SizeConfig.screenHeight! * 0.012,
                                      SizeConfig.screenWidth! * 0.07,
                                      SizeConfig.screenHeight! * 0.013),
                                  child: TextFormField(
                                    validator: (old_pass) {
                                      if (old_pass == null ||
                                          old_pass.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                    controller: old_pass,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromRGBO(
                                                103, 112, 110, 1),
                                            width: 2.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color.fromRGBO(75, 74, 103, 1),
                                        ),
                                      ),
                                      labelText: "Old password",
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                    ),
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black),
                                  )),
                              Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.fromLTRB(
                                      SizeConfig.screenWidth! * 0.07,
                                      SizeConfig.screenHeight! * 0.012,
                                      SizeConfig.screenWidth! * 0.07,
                                      SizeConfig.screenHeight! * 0.013),
                                  child: TextFormField(
                                    validator: (pass) {
                                      if (pass == null || pass.isEmpty) {
                                        return 'Please enter some text';
                                      } else if (pass.length < 4) {
                                        return 'The password must be at least 5 letters';
                                      }

                                      return null;
                                    },
                                    obscureText: true,
                                    controller: new_pass,
                                    decoration: const InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromRGBO(
                                                103, 112, 110, 1),
                                            width: 2.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color.fromRGBO(75, 74, 103, 1),
                                        ),
                                      ),
                                      labelText: "New password",
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                    ),
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black),
                                  )),
                              Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.fromLTRB(
                                      SizeConfig.screenWidth! * 0.07,
                                      SizeConfig.screenHeight! * 0.012,
                                      SizeConfig.screenWidth! * 0.07,
                                      SizeConfig.screenHeight! * 0.013),
                                  child: TextFormField(
                                    validator: (pass) {
                                      if (pass == null || pass.isEmpty) {
                                        return 'Please enter some text';
                                      } else if (pass.length < 4) {
                                        return 'The password must be at least 5 letters';
                                      }

                                      return null;
                                    },
                                    obscureText: true,
                                    controller: new_pass2,
                                    decoration: const InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromRGBO(
                                                103, 112, 110, 1),
                                            width: 2.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color.fromRGBO(75, 74, 103, 1),
                                        ),
                                      ),
                                      labelText: "Repeat new password",
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                    ),
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black),
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                child: Text(goodInfo,
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 20)),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: 250,
                                height: SizeConfig.screenHeight! * 0.046,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black26,
                                        offset: Offset(0, 8),
                                        blurRadius: 5.0)
                                  ],
                                  color: Color.fromRGBO(141, 181, 128, 1),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    stops: [0.0, 0.58],
                                    colors: [
                                      Color.fromRGBO(75, 74, 103, 1),
                                      Color.fromRGBO(75, 74, 103, 1),
                                    ],
                                  ),
                                  //  color: Colors.deepPurple.shade300,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    bool? verify =
                                        _formKey.currentState?.validate();
                                    if (verify == true) {
                                      try {
                                        if (widget.user.password !=
                                            old_pass.text) {
                                          setState(() {
                                            goodInfo =
                                                "The old password is not a match";
                                          });
                                        } else {
                                          if (new_pass.text != new_pass2.text) {
                                            setState(() {
                                              goodInfo =
                                                  "The passwords are not the same";
                                            });
                                          } else {
                                            setState(() {
                                              widget.user.password =
                                                  new_pass.text;
                                            });
                                            try {
                                              await appRepository
                                                  .updateUser(widget.user);
                                            } catch (_) {
                                              log(_.toString());
                                              ex.showAlertDialogExceptions(
                                                  context,
                                                  "Error",
                                                  "The password could not be saved.");
                                            }

                                            Navigator.pop(context, widget.user);
                                            final snackBar = SnackBar(
                                              content:
                                                  Builder(builder: (context) {
                                                return const Text(
                                                    'Your changes are saved');
                                              }),
                                            );
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                          }
                                        }
                                      } catch (_) {
                                        setState(() {
                                          goodInfo =
                                              "This email is already signed up";
                                        });
                                      }
                                    }
                                  },
                                  child: Container(
                                      alignment: Alignment.center,
                                      width: SizeConfig.screenWidth! * 0.5,
                                      height: SizeConfig.screenHeight! * 0.05,
                                      padding: EdgeInsets.fromLTRB(3, 0, 3, 3),
                                      child: Text(
                                        "Save changes",
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                221, 209, 199, 1),
                                            fontSize: SizeConfig.screenHeight! *
                                                0.022),
                                      )),
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                      ),
                                    ),
                                    minimumSize: MaterialStateProperty.all(Size(
                                      SizeConfig.screenWidth! * 0.9,
                                      SizeConfig.screenHeight! * 0.09,
                                    )),
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.transparent),
                                    // elevation: MaterialStateProperty.all(3),
                                    shadowColor: MaterialStateProperty.all(
                                        Colors.transparent),
                                  ),
                                ),
                              ),
                            ])),
                      ),
                    )
                  ])),
              Positioned(
                top: 1070,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: SizeConfig.screenHeight! * 0.07,
                      width: MediaQuery.of(context).size.width,
                      //  margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(141, 181, 128, 1),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage('assets/images/map.png'),
                              colorFilter: ColorFilter.mode(
                                Colors.white.withOpacity(0.2),
                                BlendMode.modulate,
                              )),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50),
                              topRight: Radius.circular(50))),
                    ),
                  ],
                ),
              ),
            ])));
  }
}
