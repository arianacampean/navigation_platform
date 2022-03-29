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
  //Image image = Image.asset('assets/images/user.png');
  // late  File _image;
  // File _image = NetworkImage(
  //         "https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?b=1&k=20&m=1300845620&s=170667a&w=0&h=JbOeyFgAc6-3jmptv6mzXpGcAd_8xqkQa_oUK2viFr8=")
  //     as File;

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
    first_name.text = widget.user.first_name;
    last_name.text = widget.user.last_name;
    email.text = widget.user.email;
    getData();
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
                      Container(
                          padding: EdgeInsets.fromLTRB(
                              0, SizeConfig.screenHeight! * 0.05, 0, 0),
                          child: Text("First name:",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400))),
                      Container(
                          width: SizeConfig.screenWidth!,
                          height: SizeConfig.screenHeight! * 0.08,
                          alignment: Alignment.center,
                          child: TextField(
                              textAlignVertical: TextAlignVertical.top,
                              textAlign: TextAlign.center,
                              readOnly: true,
                              controller: first_name,
                              decoration: InputDecoration(
                                fillColor: buttons_col,
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: color_border),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: color_border),
                                ),
                                labelStyle: TextStyle(color: Colors.black),
                              ),
                              style: TextStyle(
                                  color: text_color,
                                  fontWeight: FontWeight.w400))),
                      Divider(
                        color: Colors.black,
                        height: 25,
                        thickness: 2,
                        indent: SizeConfig.screenWidth! * 0.05,
                        endIndent: SizeConfig.screenWidth! * 0.05,
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(
                              0, SizeConfig.screenHeight! * 0.02, 0, 0),
                          child: Text("Last name:",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400))),
                      Container(
                          width: SizeConfig.screenWidth!,
                          height: SizeConfig.screenHeight! * 0.08,
                          alignment: Alignment.center,
                          child: TextField(
                              textAlignVertical: TextAlignVertical.top,
                              textAlign: TextAlign.center,
                              readOnly: true,
                              controller: last_name,
                              decoration: InputDecoration(
                                fillColor: buttons_col,
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: color_border),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: color_border),
                                ),
                                labelStyle: TextStyle(color: Colors.black),
                              ),
                              style: TextStyle(
                                  color: text_color,
                                  fontWeight: FontWeight.w400))),
                      Divider(
                        color: Colors.black,
                        height: 25,
                        thickness: 2,
                        indent: SizeConfig.screenWidth! * 0.05,
                        endIndent: SizeConfig.screenWidth! * 0.05,
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(
                              0, SizeConfig.screenHeight! * 0.02, 0, 0),
                          child: Text("E-mail:",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400))),
                      Container(
                          width: SizeConfig.screenWidth!,
                          height: SizeConfig.screenHeight! * 0.08,
                          alignment: Alignment.center,
                          child: TextField(
                              textAlignVertical: TextAlignVertical.top,
                              textAlign: TextAlign.center,
                              readOnly: true,
                              controller: email,
                              decoration: InputDecoration(
                                fillColor: buttons_col,
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: color_border),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: color_border),
                                ),
                                labelStyle: TextStyle(color: Colors.black),
                              ),
                              style: TextStyle(
                                  color: text_color,
                                  fontWeight: FontWeight.w400))),
                      Divider(
                        color: Colors.black,
                        height: 25,
                        thickness: 2,
                        indent: SizeConfig.screenWidth! * 0.05,
                        endIndent: SizeConfig.screenWidth! * 0.05,
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
