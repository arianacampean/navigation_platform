// import 'dart:developer';

// import 'package:flutter/material.dart';

// import 'package:frontend/database/local_database.dart';
// import 'package:frontend/models/photo.dart';
// import 'package:frontend/models/utility.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';

// import 'dart:async';

// class SaveImageDemoSQLite extends StatefulWidget {
//   //
//   SaveImageDemoSQLite() : super();

//   final String title = "Flutter Save Image";

//   @override
//   _SaveImageDemoSQLiteState createState() => _SaveImageDemoSQLiteState();
// }

// class _SaveImageDemoSQLiteState extends State<SaveImageDemoSQLite> {
//   //
//   int id = 1;
//   late Future<File> imageFile;
//   late Image image;
//   late DBProvider dbHelper;
//   List<Photo> images = [];

//   @override
//   void initState() {
//     super.initState();
//     images = [];
//     dbHelper = DBProvider.db;
//     refreshImages();
//     ceva();
//   }

//   ceva() async {
//     List<Photo> ph = await dbHelper.getPhotos();
//     ph.forEach((element) {
//       //log(element.id.toString());
//     });
//   }

//   refreshImages() {
//     dbHelper.getPhotos().then((imgs) {
//       setState(() {
//         images.clear();
//         images.addAll(imgs);
//       });
//     });
//   }

//   pickImageFromGallery() async {
//     ImagePicker.platform.pickImage(source: ImageSource.gallery).then((imgFile) {
//       final file = File(imgFile!.path);
//       String imgString = Utility.base64String(file.readAsBytesSync());
//       //  String imgString = Utility.base64String(imgFile!.readAsBytes());
//       Photo photo = Photo(photo_name: imgString);
//       id++;
//       log(id.toString());
//       // log(imgString);
//       dbHelper.save(photo);
//       refreshImages();
//     });
//   }

//   gridView() {
//     return Padding(
//       padding: EdgeInsets.all(5.0),
//       child: GridView.count(
//         crossAxisCount: 2,
//         childAspectRatio: 1.0,
//         mainAxisSpacing: 4.0,
//         crossAxisSpacing: 4.0,
//         children: images.map((photo) {
//           return Utility.imageFromBase64String(photo.photo_name);
//         }).toList(),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//         actions: <Widget>[],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: <Widget>[
//             IconButton(
//               icon: Icon(Icons.add),
//               onPressed: () async {
//                 pickImageFromGallery();
//                 List<Photo> list = await dbHelper.getPhotos();
//                 list.forEach((element) {
//                   log(element.photo_name);
//                 });
//               },
//             ),
//             Flexible(
//               child: gridView(),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
