import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/models/sizeConf.dart';
import 'package:frontend/repository/app_repo.dart';

import 'package:frontend/views/register_view.dart';

import 'maps_views/principal_page_view.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late User user;

  late AppRepository appRepository;
  String goodCredentials = "";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    appRepository = AppRepository();
  }

  final email = TextEditingController();
  final pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromRGBO(141, 181, 128, 1),
            Color.fromRGBO(194, 207, 178, 1),
            Color.fromRGBO(221, 209, 199, 1),
          ],
        )),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 100,
              child: Container(
                  alignment: Alignment.center,
                  height: SizeConfig.screenHeight! * 0.55,
                  width: SizeConfig.screenWidth! * 0.9,

                  //  margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(221, 209, 199, 1),
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    border: Border.all(
                      //color: Color.fromRGBO(126, 137, 135, 1),
                      color: Color.fromRGBO(103, 112, 110, 1),
                      width: 1,
                    ),
                  ),
                  child: SingleChildScrollView(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/images/login.png',
                          width: SizeConfig.screenHeight! * 0.15,
                        ),
                      ),
                      Container(
                          alignment: Alignment.center,
                          child: Text(
                            "Welcome",
                            style: TextStyle(
                                fontSize: 25,
                                color: Color.fromRGBO(75, 74, 103, 1),
                                fontWeight: FontWeight.w500),
                          )),
                      Container(
                          child: Text(
                        "Sign in",
                        style: TextStyle(fontSize: 23, color: Colors.black),
                      )),
                      Container(
                          // alignment: Alignment.topLeft,
                          child: Text(
                        goodCredentials,
                        style: TextStyle(fontSize: 15, color: Colors.red),
                      )),
                      Container(
                          padding: EdgeInsets.fromLTRB(
                              SizeConfig.screenWidth! * 0.07,
                              SizeConfig.screenHeight! * 0.025,
                              SizeConfig.screenWidth! * 0.07,
                              SizeConfig.screenHeight! * 0.013),
                          child: TextFormField(
                            validator: (email) {
                              if (email == null || email.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                            controller: email,
                            decoration: const InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(103, 112, 110, 1),
                                    width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(75, 74, 103, 1)),
                              ),
                              labelText: "Email",
                              labelStyle: TextStyle(color: Colors.black),
                            ),
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          )),
                      Container(
                          padding: EdgeInsets.fromLTRB(
                              SizeConfig.screenWidth! * 0.07,
                              SizeConfig.screenHeight! * 0.025,
                              SizeConfig.screenWidth! * 0.07,
                              SizeConfig.screenHeight! * 0.013),
                          child: TextFormField(
                            validator: (pass) {
                              if (pass == null || pass.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                            obscureText: true,
                            controller: pass,
                            decoration: const InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(103, 112, 110, 1),
                                    width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(75, 74, 103, 1)),
                              ),
                              labelText: "Password",
                              labelStyle: TextStyle(color: Colors.black),
                            ),
                            style: TextStyle(fontSize: 20),
                          )),
                      Container(
                        alignment: Alignment.center,
                        child: SizedBox(
                          //  height: 100.0,
                          width: SizeConfig.screenHeight! * 0.10,
                          child: FittedBox(
                            child: FloatingActionButton.extended(
                              onPressed: () async {
                                try {
                                  List<User> us = await appRepository
                                      .getOneUser(email.text);
                                  user = us[0];
                                  if (user.password == pass.text) {
                                    //
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PrincipalPage(
                                                  user: user,
                                                )));
                                  } else {
                                    setState(() {
                                      goodCredentials =
                                          "Email or password incorect";
                                    });
                                  }
                                } catch (_) {
                                  setState(() {
                                    goodCredentials =
                                        "Email or password incorect";
                                  });
                                }
                              },
                              backgroundColor: Color.fromRGBO(75, 74, 103, 1),
                              icon: const Icon(
                                Icons.login,
                                color: Color.fromRGBO(221, 209, 199, 1),
                              ),
                              label: const Text("Login",
                                  style: TextStyle(
                                      color: Color.fromRGBO(221, 209, 199, 1))),
                            ),
                          ),
                        ),
                      ),
                      Container(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "You don't have an account?",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black),
                              ),
                              TextButton(
                                onPressed: () async {
                                  email.clear();
                                  pass.clear();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RegisterForm()));
                                },
                                child: Text(
                                  "Sign up",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Color.fromRGBO(75, 74, 103, 1)),
                                ),
                              )
                            ],
                          )),
                    ],
                  ))),
            ),
            Positioned(
              top: 830,
              child: Container(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/logo.png',
                  width: SizeConfig.screenHeight! * 0.2,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
