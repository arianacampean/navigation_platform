import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/models/sizeConf.dart';
import 'package:frontend/repository/app_repo.dart';
import 'package:frontend/repository/repo.dart';

import 'package:frontend/views/register_view.dart';

import 'home_view.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late User user;
  late Repo repo;
  late AppRepository appRepository;
  String goodCredentials = "";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    repo = Repo.repo;
    appRepository = AppRepository(repo);
  }

  final email = TextEditingController();
  final pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.fromLTRB(
            SizeConfig.screenWidth! * 0.03,
            SizeConfig.screenHeight! * 0.001,
            SizeConfig.screenWidth! * 0.03,
            SizeConfig.screenHeight! * 0.02),
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromRGBO(128, 196, 131, 1),
            Color.fromRGBO(159, 224, 172, 1),
            Color.fromRGBO(0, 115, 255, 100),
          ],
        )),
        child: ListView(
          children: [
            SizedBox(height: SizeConfig.blockSizeVertical! * 8),
            Container(
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(
                    SizeConfig.screenWidth! * 0.07,
                    SizeConfig.screenHeight! * 0.025,
                    SizeConfig.screenWidth! * 0.07,
                    SizeConfig.screenHeight! * 0.010),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                    ),
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))
                    //),
                    ),
                child: Text(
                  "Welcome",
                  style: TextStyle(fontSize: SizeConfig.screenHeight! * 0.025),
                )),
            Container(
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(
                    SizeConfig.screenWidth! * 0.07,
                    SizeConfig.screenHeight! * 0.005,
                    SizeConfig.screenWidth! * 0.07,
                    SizeConfig.screenHeight! * 0.006),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.white,
                  ),
                ),
                child: Text(
                  "Sign in",
                  style: TextStyle(fontSize: SizeConfig.screenHeight! * 0.018),
                )),
            Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.fromLTRB(
                    SizeConfig.screenWidth! * 0.07,
                    SizeConfig.screenHeight! * 0.005,
                    SizeConfig.screenWidth! * 0.07,
                    SizeConfig.screenHeight! * 0.0002),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.white,
                  ),
                ),
                child: Text(
                  goodCredentials,
                  style: TextStyle(
                      fontSize: SizeConfig.screenHeight! * 0.018,
                      color: Colors.red),
                )),
            Container(
                alignment: Alignment.center,
                // width: SizeConfig.screenWidth! * 0.05,
                height: SizeConfig.screenHeight! * 0.13,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.white,
                  ),
                ),
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
                          color: Color.fromRGBO(0, 115, 255, 1), width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    labelText: "Email",
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                  style: TextStyle(
                    fontSize: SizeConfig.screenHeight! * 0.02,
                    color: Colors.black,
                  ),
                )),
            Container(
                alignment: Alignment.center,
                height: SizeConfig.screenHeight! * 0.11,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.white,
                  ),
                ),
                padding: EdgeInsets.fromLTRB(
                    SizeConfig.screenWidth! * 0.07,
                    SizeConfig.screenHeight! * 0.012,
                    SizeConfig.screenWidth! * 0.07,
                    SizeConfig.screenHeight! * 0.002),
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
                          color: Color.fromRGBO(0, 115, 255, 1), width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    labelText: "Password",
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                  style: TextStyle(fontSize: SizeConfig.screenHeight! * 0.02),
                )),
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.fromLTRB(
                    SizeConfig.screenWidth! * 0.07,
                    SizeConfig.screenHeight! * 0,
                    SizeConfig.screenWidth! * 0.07,
                    SizeConfig.screenHeight! * 0.000),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                  ),
                  color: Colors.white,
                ),
                child: TextButton(
                  onPressed: () async {},
                  child: Text(
                    "Forgot password?",
                    style:
                        TextStyle(fontSize: SizeConfig.screenHeight! * 0.015),
                  ),
                )),
            Container(
              alignment: Alignment.center,
              //  width: 100,
              //  height: SizeConfig.screenWidth! * 0.1,
              padding: EdgeInsets.fromLTRB(
                  SizeConfig.screenWidth! * 0.08,
                  SizeConfig.screenHeight! * 0.01,
                  SizeConfig.screenWidth! * 0.08,
                  SizeConfig.screenHeight! * 0.02),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.white,
                ),
              ),
              child: SizedBox(
                //  height: 100.0,
                width: SizeConfig.screenHeight! * 0.15,
                child: FittedBox(
                  child: FloatingActionButton.extended(
                    onPressed: () async {
                      ///////////////////////////////////////////////////////////////////////////////////////////////////////////
                      try {
                        List<User> us =
                            await appRepository.getOneUser(email.text);
                        user = us[0];
                        if (user.password == pass.text) {
                          //
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage(
                                        user: user,
                                      )));
                        } else {
                          setState(() {
                            goodCredentials = "Email or password incorect";
                          });
                        }
                      } catch (_) {
                        setState(() {
                          goodCredentials = "Email or password incorect";
                        });
                      }
                    },
                    icon: const Icon(Icons.login),
                    label: const Text("Login"),
                    splashColor: Colors.blue,
                  ),
                ),
              ),
            ),

            // FloatingActionButton.extended(
            //   elevation: 0.0,
            //   //               shape: const RoundedRectangleBorder(
            //   //   borderRadius: BorderRadius.all(Radius.circular(2)),

            //   // ) ,
            //   onPressed: () async {
            //     ///////////////////////////////////////////////////////////////////////////////////////////////////////////
            //     try {
            //       List<User> us = await appRepository.getOneUser(email.text);
            //       user = us[0];
            //       if (user.password == pass.text) {
            //         //
            //         log("yeyyyyy esti logat");
            //       } else {
            //         setState(() {
            //           goodCredentials = "Email or password incorect";
            //         });
            //       }
            //     } catch (_) {
            //       setState(() {
            //         goodCredentials = "Email or password incorect";
            //       });
            //     }
            //   },
            //   icon: const Icon(Icons.login),
            //   label: const Text("Login"),
            //   splashColor: Colors.blue,
            // ),
            //   ),
            Container(
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(
                    SizeConfig.screenWidth! * 0.08,
                    SizeConfig.screenHeight! * 0.003,
                    SizeConfig.screenWidth! * 0.08,
                    SizeConfig.screenHeight! * 0.03),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.white,
                    ),
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "You don't have an acoount?",
                      style:
                          TextStyle(fontSize: SizeConfig.screenHeight! * 0.015),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterForm()));
                      },
                      child: Text(
                        "Sign up",
                        style: TextStyle(
                            fontSize: SizeConfig.screenHeight! * 0.015),
                      ),
                    )
                  ],
                )),
            SizedBox(height: SizeConfig.blockSizeVertical! * 13),
            Container(
              alignment: Alignment.center,

              // decoration: BoxDecoration(
              //   color: Colors.white,
              //   border: Border.all(
              //     color: Colors.white,
              //   ),
              // ),
              // child: FloatingActionButton.extended(
              //   onPressed: () {},
              //   icon: const Icon(Icons.login),
              //   label: const Text("Login"),
              //   splashColor: Colors.blue,
              //   ),
              // child: Image.asset(
              //   'assets/images/luggage.png',
              //   width: SizeConfig.screenHeight! * 0.15,
              // ),
            ),
          ],
        ),
      ),
    );
  }
}
