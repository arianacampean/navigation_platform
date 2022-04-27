import 'dart:developer';
import 'dart:io';

import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/database/local_database.dart';
import 'package:frontend/models/photo.dart';
import 'package:frontend/models/settings.dart';
import 'package:frontend/models/sizeConf.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/models/utility.dart';
import 'package:image_picker/image_picker.dart';

import 'custom_settings_views/theme_view.dart';

class ProfilePage extends StatefulWidget {
  Settings settings;
  User user;
  ProfilePage({Key? key, required this.settings, required this.user})
      : super(key: key);

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

  late Color col_background;
  late Color buttons_col;
  late Color color_border;
  late Color text_color;

  final first_name = TextEditingController();
  final last_name = TextEditingController();
  final email = TextEditingController();

  @override
  void initState() {
    super.initState();
    // repo = Repo.repo;
    // appRepository = AppRepository(repo);
    //var ceva=await DBProvider.db.
    setState(() => isLoading = true);
    dbHelper = DBProvider.db;
    col_background = Colors.white;
    buttons_col = Color.fromRGBO(159, 224, 172, 1);
    color_border = Colors.white;
    text_color = Colors.black;

    //getData();
    isImage();
    log("asta e numele ." + photo.photo_name);
  }

  refreshImage() {
    setState(() => {isLoading = true, verify = true});
    isImage();
  }

  Future getData() async {
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
              ? CircularProgressIndicator()
              : Container(
                  padding: EdgeInsets.fromLTRB(3, 0, 3, 0),
                  decoration: BoxDecoration(
                    color: col_background,
                  ),
                  child: ListView(
                    children: [
                      SizedBox(height: SizeConfig.blockSizeVertical! * 2),
                      verify
                          ? CircleAvatar(
                              radius: SizeConfig.screenHeight! * 0.15,
                              backgroundColor: Colors.transparent,
                              child: SizedBox(
                                  width: SizeConfig.screenHeight! * 0.23,
                                  height: SizeConfig.screenHeight! * 0.23,
                                  child: ClipOval(
                                    child: image,
                                  )))
                          : CircleAvatar(
                              radius: SizeConfig.screenHeight! * 0.15,
                              backgroundColor: Colors.transparent,
                              child: SizedBox(
                                  width: SizeConfig.screenHeight! * 0.23,
                                  height: SizeConfig.screenHeight! * 0.23,
                                  child: ClipOval(
                                      child: Image.asset(
                                          'assets/images/user.png')))),
                      TextButton(
                        onPressed: () async {
                          _showPicker(context);
                        },
                        child: Text(
                          text,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.screenHeight! * 0.04,
                      ),
                      Container(
                        width: SizeConfig.screenWidth! * 0.8,
                        height: SizeConfig.screenHeight! * 0.07,
                        alignment: Alignment.center,
                        child: Text("First name:  " + widget.user.first_name,
                            style: TextStyle(
                                color: text_color,
                                fontSize: 22,
                                fontWeight: FontWeight.w400)),
                        decoration: BoxDecoration(
                            color: buttons_col,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                      ),
                      Divider(
                        color: Colors.black,
                        height: 25,
                        thickness: 2,
                        indent: SizeConfig.screenWidth! * 0.2,
                        endIndent: SizeConfig.screenWidth! * 0.2,
                      ),
                      SizedBox(
                        height: SizeConfig.screenHeight! * 0.04,
                      ),
                      Container(
                        width: SizeConfig.screenWidth! * 0.8,
                        height: SizeConfig.screenHeight! * 0.07,
                        alignment: Alignment.center,
                        child: Text("Last name:  " + widget.user.last_name,
                            style: TextStyle(
                                color: text_color,
                                fontSize: 22,
                                fontWeight: FontWeight.w400)),
                        decoration: BoxDecoration(
                            color: buttons_col,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                      ),
                      Divider(
                        color: Colors.black,
                        height: 25,
                        thickness: 2,
                        indent: SizeConfig.screenWidth! * 0.2,
                        endIndent: SizeConfig.screenWidth! * 0.2,
                      ),
                      SizedBox(
                        height: SizeConfig.screenHeight! * 0.04,
                      ),
                      Container(
                        width: SizeConfig.screenWidth! * 0.8,
                        height: SizeConfig.screenHeight! * 0.07,
                        alignment: Alignment.center,
                        child: Text("E-mail:  " + widget.user.email,
                            style: TextStyle(
                                color: text_color,
                                fontSize: 22,
                                fontWeight: FontWeight.w400)),
                        decoration: BoxDecoration(
                            color: buttons_col,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                      ),
                      Divider(
                        color: Colors.black,
                        height: 25,
                        thickness: 2,
                        indent: SizeConfig.screenWidth! * 0.2,
                        endIndent: SizeConfig.screenWidth! * 0.2,
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  _imgFromGallery() async {
    ImagePicker.platform.pickImage(source: ImageSource.gallery).then((imgFile) {
      final file = File(imgFile!.path);
      String imgString = Utility.base64String(file.readAsBytesSync());
      //  String imgString = Utility.base64String(imgFile!.readAsBytes());
      Photo photo = Photo(id: 1, photo_name: imgString);
      if (text == "Change your profile pic") {
        dbHelper.changePhoto(photo);
      } else
        dbHelper.save(photo);
      refreshImage();
    });
  }

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

  gridView() {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        children: images.map((photo) {
          return Utility.imageFromBase64String(photo.photo_name);
        }).toList(),
      ),
    );
  }

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
