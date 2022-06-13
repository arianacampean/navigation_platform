import 'dart:developer';
import 'dart:io';

import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/database/local_database.dart';
import 'package:frontend/models/photo.dart';

import 'package:frontend/models/sizeConf.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/models/utility.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  // Settings settings;
  User user;
  ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<File> imageFile;
  //int idd=1;
  late Image image;
  late DBProvider dbHelper;
  Photo photo = Photo(id: 1, photo_name: "");
  bool isLoading = false;
  List<Photo> images = [];
  String text = "Add a profile pic";
  bool verify = true;

  final first_name = TextEditingController();
  final last_name = TextEditingController();
  final email = TextEditingController();

  @override
  void initState() {
    super.initState();
 
    setState(() => isLoading = true);
    dbHelper = DBProvider.db;

    isImage();
    log("asta e numele ." + photo.photo_name);
  }

  //actiualizare imagine dupa schimbare
  refreshImage() {
    setState(() => {isLoading = true, verify = true});
    isImage();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        appBar: AppBar(),
        body: WillPopScope(
          onWillPop: () async {
            Navigator.pop(context);
            return false;
          },
          child: Center(
            child: isLoading
                ? CircularProgressIndicator(
                    backgroundColor: Color.fromRGBO(221, 209, 199, 1),
                  )
                : Container(
                  
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(75, 74, 103, 1),
                    ),
                    child: ListView(children: [
                    
                      Container(
                        height: SizeConfig.screenHeight! * 0.35,
                       

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
                       
                          children: [
                            Expanded(
                              child:
                                
                                  verify
                                      ? CircleAvatar(
                                          radius:
                                              SizeConfig.screenHeight! * 0.2,
                                          backgroundColor: Colors.transparent,
                                          child: SizedBox(
                                              width: SizeConfig.screenHeight! *
                                                  0.28,
                                              height: SizeConfig.screenHeight! *
                                                  0.28,
                                              child: ClipOval(
                                                child: image,
                                              )))
                                      : CircleAvatar(
                                          radius:
                                              SizeConfig.screenHeight! * 0.2,
                                          backgroundColor: Colors.transparent,
                                          child: SizedBox(
                                              width: SizeConfig.screenHeight! *
                                                  0.28,
                                              height: SizeConfig.screenHeight! *
                                                  0.28,
                                              child: ClipOval(
                                                  child: Image.asset(
                                                      'assets/images/user.png')))),
                            ),
                          ],
                   
                        ),
                      ),

                      Container(
                        height: SizeConfig.screenHeight! * 0.55,
                        decoration: BoxDecoration(
                        
                          color: Color.fromRGBO(221, 209, 199, 1),
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          border: Border.all(
                           
                            color: Color.fromRGBO(194, 207, 178, 1),
                            width: 2,
                          ),
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                            
                              TextButton(
                                onPressed: () async {
                                  _showPicker(context);
                                },
                                child: Text(
                                  text,
                                  style: TextStyle(
                                      fontSize:
                                          SizeConfig.screenHeight! * 0.022,
                                      color: Color.fromRGBO(75, 74, 103, 1)),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: SizeConfig.screenWidth! * 0.9,
                                height: SizeConfig.screenHeight! * 0.09,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black26,
                                        offset: Offset(0, 4),
                                        blurRadius: 5.0)
                                  ],
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    stops: [0.4, 1.0],
                                    colors: [
                                      Color.fromRGBO(75, 74, 103, 1),
                                    
                                      Color.fromRGBO(141, 181, 128, 1),
                                    ],
                                  ),
                               
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Text(
                                  "First name: " + widget.user.first_name,
                                  style: TextStyle(
                                      color: Color.fromRGBO(221, 209, 199, 1),
                                      fontSize:
                                          SizeConfig.screenHeight! * 0.022),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: SizeConfig.screenWidth! * 0.9,
                                height: SizeConfig.screenHeight! * 0.09,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black26,
                                        offset: Offset(0, 4),
                                        blurRadius: 5.0)
                                  ],
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    stops: [0.4, 1.0],
                                    colors: [
                                      Color.fromRGBO(75, 74, 103, 1),
                                      //   Color.fromRGBO(126, 137, 135, 1),
                                      Color.fromRGBO(141, 181, 128, 1),
                                    ],
                                  ),
                                  // color: Colors.deepPurple.shade300,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Text(
                                  "Last name: " + widget.user.last_name,
                                  style: TextStyle(
                                      color: Color.fromRGBO(221, 209, 199, 1),
                                      fontSize:
                                          SizeConfig.screenHeight! * 0.022),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: SizeConfig.screenWidth! * 0.9,
                                height: SizeConfig.screenHeight! * 0.09,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black26,
                                        offset: Offset(0, 4),
                                        blurRadius: 5.0)
                                  ],
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    stops: [0.4, 1.0],
                                    colors: [
                                      Color.fromRGBO(75, 74, 103, 1),
                                    
                                      Color.fromRGBO(141, 181, 128, 1),
                                    ],
                                  ),
                                
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Text(
                                  "E-mail: " + widget.user.email,
                                  style: TextStyle(
                                      color: Color.fromRGBO(221, 209, 199, 1),
                                      fontSize:
                                          SizeConfig.screenHeight! * 0.022),
                                ),
                              ),

                            ]),
                      ),
                    ]),
                  ),
          ),
        ));
  }

    //functie salveaza imaginea in baza de date sau o modifica
  _imgFromGallery() async {
    ImagePicker.platform.pickImage(source: ImageSource.gallery).then((imgFile) {
      final file = File(imgFile!.path);
      String imgString = Utility.base64String(file.readAsBytesSync());
  
      Photo photo = Photo(id: 1, photo_name: imgString);
      if (text == "Change your profile pic") {
        dbHelper.changePhoto(photo);
      } else
        dbHelper.save(photo);
      refreshImage();
    });
  }

  //functie care ia functia si o decodează
  isImage() {
    dbHelper.getPhotos().then((imgs) {
      if (!imgs.isEmpty) {
        log("am gasit poze");
        setState(() {
          photo = imgs[0];

          try {
            image = Utility.imageFromBase64String(photo.photo_name);
            isLoading = false;
            text = "Change your profile pic";
            verify = true;
          } catch (_) {
            log(_.toString());
          }
        });
      } else
        setState(() {
          log("nu am gasit poze");
          isLoading = false;
          verify = false;
        });
    });
  }


   //functie pentru a aparea pop up de imagine din librarie
  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                ],
              ),
            ),
          );
        });
  }
}
