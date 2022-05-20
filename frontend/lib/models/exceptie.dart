import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Exceptie {
  Exceptie() {}
  static final Exceptie ex = Exceptie();

  showAlertDialogExceptions(BuildContext context, String tittl, String mes) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
        "Ok",
        style: TextStyle(fontSize: 20, color: Color.fromRGBO(75, 74, 103, 1)),
      ),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
        // Navigator.pop(dialog)
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Color.fromRGBO(221, 209, 199, 1),
      elevation: 8,
      title: Text(tittl,
          style:
              TextStyle(fontSize: 23, color: Color.fromRGBO(75, 74, 103, 1))),
      content: Text(mes,
          style:
              TextStyle(fontSize: 23, color: Color.fromRGBO(75, 74, 103, 1))),
      actions: [
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      // barrierColor: Color.fromRGBO(221, 209, 199, 1),
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
