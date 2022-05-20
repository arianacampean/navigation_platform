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
        appBar: AppBar(title: Text("Register")
            //shadowColor: Colors.black,
            ),
        body: Form(
            key: _formKey,
            child: Container(
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
              child: Stack(alignment: Alignment.center, children: [
                Positioned(
                    top: 100,
                    child: Container(
                        alignment: Alignment.center,
                        height: SizeConfig.screenHeight! * 0.7,
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
                          // image: DecorationImage(
                          //     fit: BoxFit.cover,
                          //     image: AssetImage('assets/images/map.png'),
                          //     colorFilter: ColorFilter.mode(
                          //       Colors.white.withOpacity(0.12),
                          //       BlendMode.modulate,
                          //     )),
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
                                  "Create a new account",
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: Color.fromRGBO(75, 74, 103, 1),
                                      fontWeight: FontWeight.w500),
                                )),
                            // Container(
                            //     alignment: Alignment.center,
                            //     child: Text(
                            //       "Create a new account",
                            //       style: TextStyle(
                            //           fontSize:
                            //               SizeConfig.screenHeight! * 0.020,
                            //           color: Color.fromRGBO(75, 74, 103, 1)),
                            //     )),
                            Container(
                                // alignment: Alignment.centerLeft,
                                child: Text(
                              "Fill in the fields below",
                              style: TextStyle(fontSize: 20),
                            )),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.fromLTRB(
                                    SizeConfig.screenWidth! * 0.07,
                                    SizeConfig.screenHeight! * 0.012,
                                    SizeConfig.screenWidth! * 0.07,
                                    SizeConfig.screenHeight! * 0.013),
                                child: TextFormField(
                                  validator: (first_name) {
                                    if (first_name == null ||
                                        first_name.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                  controller: first_name,
                                  decoration: const InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(103, 112, 110, 1),
                                          width: 2.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color.fromRGBO(75, 74, 103, 1),
                                      ),
                                    ),
                                    labelText: "First name",
                                    labelStyle: TextStyle(color: Colors.black),
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
                                  validator: (last_name) {
                                    if (last_name == null ||
                                        last_name.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                  controller: last_name,
                                  decoration: const InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(103, 112, 110, 1),
                                          width: 2.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color.fromRGBO(75, 74, 103, 1),
                                      ),
                                    ),
                                    labelText: "Last name",
                                    labelStyle: TextStyle(color: Colors.black),
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
                                          color:
                                              Color.fromRGBO(103, 112, 110, 1),
                                          width: 2.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color.fromRGBO(75, 74, 103, 1),
                                      ),
                                    ),
                                    labelText: "Email",
                                    labelStyle: TextStyle(color: Colors.black),
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
                                  controller: pass,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(103, 112, 110, 1),
                                          width: 2.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color.fromRGBO(75, 74, 103, 1),
                                      ),
                                    ),
                                    labelText: "Password",
                                    labelStyle: TextStyle(color: Colors.black),
                                  ),
                                  style: TextStyle(fontSize: 20),
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
                                  controller: pass2,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(103, 112, 110, 1),
                                          width: 2.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(75, 74, 103, 1)),
                                    ),
                                    labelText: "Repeat password",
                                    labelStyle: TextStyle(color: Colors.black),
                                  ),
                                  style: TextStyle(fontSize: 20),
                                )),
                            Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.fromLTRB(
                                    SizeConfig.screenWidth! * 0.07,
                                    SizeConfig.screenHeight! * 0.0005,
                                    SizeConfig.screenWidth! * 0.07,
                                    SizeConfig.screenHeight! * 0.005),
                                child: Text(
                                  goodPass,
                                  style: TextStyle(
                                      fontSize:
                                          SizeConfig.screenHeight! * 0.015,
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
                                      bool? verify =
                                          _formKey.currentState?.validate();
                                      if (verify == true) {
                                        try {
                                          if (pass.text != pass2.text) {
                                            setState(() {
                                              goodPass =
                                                  "The passwords are not the same";
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
                                              content:
                                                  Builder(builder: (context) {
                                                return const Text(
                                                    'You have an account now :)');
                                              }),
                                            );
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                          }
                                        } catch (_) {
                                          setState(() {
                                            goodPass =
                                                "This email is already signed up";
                                          });
                                        }
                                      }
                                    },
                                    backgroundColor:
                                        Color.fromRGBO(75, 74, 103, 1),
                                    icon: const Icon(
                                      Icons.app_registration,
                                      color: Color.fromRGBO(221, 209, 199, 1),
                                    ),
                                    label: const Text("Register",
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                221, 209, 199, 1))),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ))))

                // child: ListView(
                //   children: [
                //     SizedBox(height: SizeConfig.blockSizeVertical! * 8),
                //     Container(
                //         alignment: Alignment.center,
                //         padding: EdgeInsets.fromLTRB(
                //             SizeConfig.screenWidth! * 0.07,
                //             SizeConfig.screenHeight! * 0.025,
                //             SizeConfig.screenWidth! * 0.07,
                //             SizeConfig.screenHeight! * 0.025),
                //         decoration: BoxDecoration(
                //             border: Border.all(
                //               color: Colors.white,
                //             ),
                //             color: Colors.white,
                //             borderRadius: const BorderRadius.only(
                //                 topLeft: Radius.circular(20),
                //                 topRight: Radius.circular(20))),
                //         child: Text(
                //           "Create a new account",
                //           style:
                //               TextStyle(fontSize: SizeConfig.screenHeight! * 0.020),
                //         )),
                //     Container(
                //         alignment: Alignment.centerLeft,
                //         padding: EdgeInsets.fromLTRB(
                //             SizeConfig.screenWidth! * 0.07,
                //             SizeConfig.screenHeight! * 0.005,
                //             SizeConfig.screenWidth! * 0.07,
                //             SizeConfig.screenHeight! * 0.005),
                //         decoration: BoxDecoration(
                //           color: Colors.white,
                //           border: Border.all(
                //             color: Colors.white,
                //           ),
                //         ),
                //         child: Text(
                //           "Fill in the fields below",
                //           style:
                //               TextStyle(fontSize: SizeConfig.screenHeight! * 0.015),
                //         )),
                //     Container(
                //         alignment: Alignment.center,
                //         decoration: BoxDecoration(
                //           color: Colors.white,
                //           border: Border.all(
                //             color: Colors.white,
                //           ),
                //         ),
                //         padding: EdgeInsets.fromLTRB(
                //             SizeConfig.screenWidth! * 0.07,
                //             SizeConfig.screenHeight! * 0.012,
                //             SizeConfig.screenWidth! * 0.07,
                //             SizeConfig.screenHeight! * 0.013),
                //         child: TextFormField(
                //           validator: (first_name) {
                //             if (first_name == null || first_name.isEmpty) {
                //               return 'Please enter some text';
                //             }
                //             return null;
                //           },
                //           controller: first_name,
                //           decoration: const InputDecoration(
                //             focusedBorder: OutlineInputBorder(
                //               borderSide: BorderSide(
                //                   color: Color.fromRGBO(0, 115, 255, 1),
                //                   width: 2.0),
                //             ),
                //             enabledBorder: OutlineInputBorder(
                //               borderSide: BorderSide(color: Colors.black),
                //             ),
                //             labelText: "First name",
                //             labelStyle: TextStyle(color: Colors.black),
                //           ),
                //           style: TextStyle(
                //               fontSize: SizeConfig.screenHeight! * 0.016,
                //               color: Colors.black),
                //         )),
                //     Container(
                //         alignment: Alignment.center,
                //         decoration: BoxDecoration(
                //           color: Colors.white,
                //           border: Border.all(
                //             color: Colors.white,
                //           ),
                //         ),
                //         padding: EdgeInsets.fromLTRB(
                //             SizeConfig.screenWidth! * 0.07,
                //             SizeConfig.screenHeight! * 0.012,
                //             SizeConfig.screenWidth! * 0.07,
                //             SizeConfig.screenHeight! * 0.013),
                //         child: TextFormField(
                //           validator: (last_name) {
                //             if (last_name == null || last_name.isEmpty) {
                //               return 'Please enter some text';
                //             }
                //             return null;
                //           },
                //           controller: last_name,
                //           decoration: const InputDecoration(
                //             focusedBorder: OutlineInputBorder(
                //               borderSide: BorderSide(
                //                   color: Color.fromRGBO(0, 115, 255, 1),
                //                   width: 2.0),
                //             ),
                //             enabledBorder: OutlineInputBorder(
                //               borderSide: BorderSide(color: Colors.black),
                //             ),
                //             labelText: "Last name",
                //             labelStyle: TextStyle(color: Colors.black),
                //           ),
                //           style: TextStyle(
                //               fontSize: SizeConfig.screenHeight! * 0.016,
                //               color: Colors.black),
                //         )),
                //     Container(
                //         alignment: Alignment.center,
                //         decoration: BoxDecoration(
                //           color: Colors.white,
                //           border: Border.all(
                //             color: Colors.white,
                //           ),
                //         ),
                //         padding: EdgeInsets.fromLTRB(
                //             SizeConfig.screenWidth! * 0.07,
                //             SizeConfig.screenHeight! * 0.012,
                //             SizeConfig.screenWidth! * 0.07,
                //             SizeConfig.screenHeight! * 0.013),
                //         child: TextFormField(
                //           validator: (email) {
                //             if (email == null || email.isEmpty) {
                //               return 'Please enter some text';
                //             }
                //             if (email.contains("@yahoo.com"))
                //               return null;
                //             else if (email.contains("@gmail.com"))
                //               return null;
                //             else
                //               return 'This email is incorrect';
                //           },
                //           controller: email,
                //           decoration: const InputDecoration(
                //             focusedBorder: OutlineInputBorder(
                //               borderSide: BorderSide(
                //                   color: Color.fromRGBO(0, 115, 255, 1),
                //                   width: 2.0),
                //             ),
                //             enabledBorder: OutlineInputBorder(
                //               borderSide: BorderSide(color: Colors.black),
                //             ),
                //             labelText: "Email",
                //             labelStyle: TextStyle(color: Colors.black),
                //           ),
                //           style: TextStyle(
                //               fontSize: SizeConfig.screenHeight! * 0.016,
                //               color: Colors.black),
                //         )),
                //     Container(
                //         alignment: Alignment.center,
                //         decoration: BoxDecoration(
                //           color: Colors.white,
                //           border: Border.all(
                //             color: Colors.white,
                //           ),
                //         ),
                //         padding: EdgeInsets.fromLTRB(
                //             SizeConfig.screenWidth! * 0.07,
                //             SizeConfig.screenHeight! * 0.012,
                //             SizeConfig.screenWidth! * 0.07,
                //             SizeConfig.screenHeight! * 0.013),
                //         child: TextFormField(
                //           validator: (pass) {
                //             if (pass == null || pass.isEmpty) {
                //               return 'Please enter some text';
                //             } else if (pass.length < 4) {
                //               return 'The password must be at least 5 letters';
                //             }

                //             return null;
                //           },
                //           controller: pass,
                //           obscureText: true,
                //           decoration: const InputDecoration(
                //             focusedBorder: OutlineInputBorder(
                //               borderSide: BorderSide(
                //                   color: Color.fromRGBO(0, 115, 255, 1),
                //                   width: 2.0),
                //             ),
                //             enabledBorder: OutlineInputBorder(
                //               borderSide: BorderSide(color: Colors.black),
                //             ),
                //             labelText: "Password",
                //             labelStyle: TextStyle(color: Colors.black),
                //           ),
                //           style:
                //               TextStyle(fontSize: SizeConfig.screenHeight! * 0.016),
                //         )),
                //     Container(
                //         alignment: Alignment.center,
                //         decoration: BoxDecoration(
                //           color: Colors.white,
                //           border: Border.all(
                //             color: Colors.white,
                //           ),
                //         ),
                //         padding: EdgeInsets.fromLTRB(
                //             SizeConfig.screenWidth! * 0.07,
                //             SizeConfig.screenHeight! * 0.012,
                //             SizeConfig.screenWidth! * 0.07,
                //             SizeConfig.screenHeight! * 0.013),
                //         child: TextFormField(
                //           validator: (pass) {
                //             if (pass == null || pass.isEmpty) {
                //               return 'Please enter some text';
                //             } else if (pass.length < 4) {
                //               return 'The password must be at least 5 letters';
                //             }

                //             return null;
                //           },
                //           controller: pass2,
                //           obscureText: true,
                //           decoration: const InputDecoration(
                //             focusedBorder: OutlineInputBorder(
                //               borderSide: BorderSide(
                //                   color: Color.fromRGBO(0, 115, 255, 1),
                //                   width: 2.0),
                //             ),
                //             enabledBorder: OutlineInputBorder(
                //               borderSide: BorderSide(color: Colors.black),
                //             ),
                //             labelText: "Repeat password",
                //             labelStyle: TextStyle(color: Colors.black),
                //           ),
                //           style:
                //               TextStyle(fontSize: SizeConfig.screenHeight! * 0.016),
                //         )),
                //     Container(
                //         alignment: Alignment.centerLeft,
                //         padding: EdgeInsets.fromLTRB(
                //             SizeConfig.screenWidth! * 0.07,
                //             SizeConfig.screenHeight! * 0.0005,
                //             SizeConfig.screenWidth! * 0.07,
                //             SizeConfig.screenHeight! * 0.005),
                //         decoration: BoxDecoration(
                //           color: Colors.white,
                //           border: Border.all(
                //             color: Colors.white,
                //           ),
                //         ),
                //         child: Text(
                //           goodPass,
                //           style: TextStyle(
                //               fontSize: SizeConfig.screenHeight! * 0.015,
                //               color: Colors.red),
                //         )),
                //     Container(
                //       alignment: Alignment.center,
                //       padding: EdgeInsets.fromLTRB(
                //           SizeConfig.screenWidth! * 0.08,
                //           SizeConfig.screenHeight! * 0.004,
                //           SizeConfig.screenWidth! * 0.08,
                //           SizeConfig.screenHeight! * 0.03),
                //       decoration: BoxDecoration(
                //         color: Colors.white,
                //         border: Border.all(
                //           color: Colors.white,
                //         ),
                //         borderRadius: const BorderRadius.only(
                //             bottomLeft: Radius.circular(20),
                //             bottomRight: Radius.circular(20)),
                //       ),
                //       child: SizedBox(
                //         //  height: 100.0,
                //         width: SizeConfig.screenHeight! * 0.12,
                //         child: FittedBox(
                //           child: FloatingActionButton.extended(
                //             onPressed: () async {
                //               ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                //               bool? verify = _formKey.currentState?.validate();
                //               if (verify == true) {
                //                 try {
                //                   if (pass.text != pass2.text) {
                //                     setState(() {
                //                       goodPass = "The passwords are not the same";
                //                     });
                //                   } else {
                //                     User us = User(
                //                         first_name: first_name.text,
                //                         last_name: last_name.text,
                //                         email: email.text,
                //                         password: pass.text);
                //                     await appRepository.addUser(us);
                //                     Navigator.pop(context);
                //                     final snackBar = SnackBar(
                //                       content: Builder(builder: (context) {
                //                         return const Text(
                //                             'You have an account now :)');
                //                       }),
                //                     );
                //                     ScaffoldMessenger.of(context)
                //                         .showSnackBar(snackBar);
                //                   }
                //                 } catch (_) {
                //                   setState(() {
                //                     goodPass = "This email is already signed up";
                //                   });
                //                 }
                //               }
                //             },
                //             icon: const Icon(Icons.login),
                //             label: const Text("Register"),
                //             splashColor: Colors.blue,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
              ]),
            )));
  }
}
