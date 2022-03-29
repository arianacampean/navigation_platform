import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsTest extends StatefulWidget {
  const GoogleMapsTest({Key? key}) : super(key: key);

  @override
  _GoogleMapsTestState createState() => _GoogleMapsTestState();
}

class _GoogleMapsTestState extends State<GoogleMapsTest> {
  @override
  void initState() {}

  final email = TextEditingController();
  final pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //SizeConfig().init(context);
    return Scaffold(
      body: GoogleMap(
          initialCameraPosition: CameraPosition(
              target: LatLng(37.773972, -122.431297), zoom: 11.5)),
    );
  }
}
