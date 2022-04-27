import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/sizeConf.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/repository/app_repo.dart';
import 'package:frontend/repository/repo.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  late User user;
  late Repo repo;
  late AppRepository appRepository;
  String goodPass = "";
  @override
  void initState() {
    super.initState();
    repo = Repo.repo;
    appRepository = AppRepository(repo);
  }

  final _formKey = GlobalKey<FormState>();
  final first_name = TextEditingController();
  final last_name = TextEditingController();
  final email = TextEditingController();
  final pass = TextEditingController();
  final pass2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        appBar: AppBar(
            //shadowColor: Colors.black,
            ),
        body: Form(
          key: _formKey,
          child: Container(
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
                Color.fromRGBO(0, 115, 255, 1),
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
                        SizeConfig.screenHeight! * 0.025),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                        ),
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    child: Text(
                      "Create a new account",
                      style:
                          TextStyle(fontSize: SizeConfig.screenHeight! * 0.020),
                    )),
                Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.fromLTRB(
                        SizeConfig.screenWidth! * 0.07,
                        SizeConfig.screenHeight! * 0.005,
                        SizeConfig.screenWidth! * 0.07,
                        SizeConfig.screenHeight! * 0.005),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.white,
                      ),
                    ),
                    child: Text(
                      "Fill in the fields below",
                      style:
                          TextStyle(fontSize: SizeConfig.screenHeight! * 0.015),
                    )),
                Container(
                    alignment: Alignment.center,
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
                        SizeConfig.screenHeight! * 0.013),
                    child: TextFormField(
                      validator: (first_name) {
                        if (first_name == null || first_name.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      controller: first_name,
                      decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(0, 115, 255, 1),
                              width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        labelText: "First name",
                        labelStyle: TextStyle(color: Colors.black),
                      ),
                      style: TextStyle(
                          fontSize: SizeConfig.screenHeight! * 0.016,
                          color: Colors.black),
                    )),
                Container(
                    alignment: Alignment.center,
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
                        SizeConfig.screenHeight! * 0.013),
                    child: TextFormField(
                      validator: (last_name) {
                        if (last_name == null || last_name.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      controller: last_name,
                      decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(0, 115, 255, 1),
                              width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        labelText: "Last name",
                        labelStyle: TextStyle(color: Colors.black),
                      ),
                      style: TextStyle(
                          fontSize: SizeConfig.screenHeight! * 0.016,
                          color: Colors.black),
                    )),
                Container(
                    alignment: Alignment.center,
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
                        SizeConfig.screenHeight! * 0.013),
                    child: TextFormField(
                      validator: (email) {
                        if (email == null || email.isEmpty) {
                          return 'Please enter some text';
                        }
                        if (email.contains("@yahoo.com"))
                          return null;
                        else if (email.contains("@gmail.com"))
                          return null;
                        else
                          return 'This email is incorrect';
                      },
                      controller: email,
                      decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(0, 115, 255, 1),
                              width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        labelText: "Email",
                        labelStyle: TextStyle(color: Colors.black),
                      ),
                      style: TextStyle(
                          fontSize: SizeConfig.screenHeight! * 0.016,
                          color: Colors.black),
                    )),
                Container(
                    alignment: Alignment.center,
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
                      controller: pass,
                      obscureText: true,
                      decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(0, 115, 255, 1),
                              width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        labelText: "Password",
                        labelStyle: TextStyle(color: Colors.black),
                      ),
                      style:
                          TextStyle(fontSize: SizeConfig.screenHeight! * 0.016),
                    )),
                Container(
                    alignment: Alignment.center,
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
                      controller: pass2,
                      obscureText: true,
                      decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(0, 115, 255, 1),
                              width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        labelText: "Repeat password",
                        labelStyle: TextStyle(color: Colors.black),
                      ),
                      style:
                          TextStyle(fontSize: SizeConfig.screenHeight! * 0.016),
                    )),
                Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.fromLTRB(
                        SizeConfig.screenWidth! * 0.07,
                        SizeConfig.screenHeight! * 0.0005,
                        SizeConfig.screenWidth! * 0.07,
                        SizeConfig.screenHeight! * 0.005),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.white,
                      ),
                    ),
                    child: Text(
                      goodPass,
                      style: TextStyle(
                          fontSize: SizeConfig.screenHeight! * 0.015,
                          color: Colors.red),
                    )),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.fromLTRB(
                      SizeConfig.screenWidth! * 0.08,
                      SizeConfig.screenHeight! * 0.004,
                      SizeConfig.screenWidth! * 0.08,
                      SizeConfig.screenHeight! * 0.03),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.white,
                    ),
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                  ),
                  child: SizedBox(
                    //  height: 100.0,
                    width: SizeConfig.screenHeight! * 0.12,
                    child: FittedBox(
                      child: FloatingActionButton.extended(
                        onPressed: () async {
                          ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                          bool? verify = _formKey.currentState?.validate();
                          if (verify == true) {
                            try {
                              if (pass.text != pass2.text) {
                                setState(() {
                                  goodPass = "The passwords are not the same";
                                });
                              } else {
                                User us = User(
                                    first_name: first_name.text,
                                    last_name: last_name.text,
                                    email: email.text,
                                    password: pass.text);
                                await appRepository.addUser(us);
                                Navigator.pop(context);
                                final snackBar = SnackBar(
                                  content: Builder(builder: (context) {
                                    return const Text(
                                        'You have an account now :)');
                                  }),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            } catch (_) {
                              setState(() {
                                goodPass = "This email is already signed up";
                              });
                            }
                          }
                        },
                        icon: const Icon(Icons.login),
                        label: const Text("Register"),
                        splashColor: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
