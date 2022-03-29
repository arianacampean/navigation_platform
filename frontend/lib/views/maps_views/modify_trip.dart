import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/sizeConf.dart';
import 'package:frontend/models/trip.dart';

class ModifyPage extends StatefulWidget {
  List<Trip> trips;
  ModifyPage({Key? key, required this.trips}) : super(key: key);

  @override
  _ModifyPageState createState() => _ModifyPageState();
}

class _ModifyPageState extends State<ModifyPage> {
  String dropdownValue = 'Yes';
  @override
  void initState() {
    super.initState();
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
          //   body: SingleChildScrollView(
          child: Column(children: [
            Container(
              height: SizeConfig.screenHeight! * 0.1,
              child: Text(
                "Trip settings",
                style: TextStyle(fontSize: 20),
              ),
              alignment: Alignment.center,
            ),
            Container(
              padding: EdgeInsets.all(10),
              height: SizeConfig.screenHeight! * 0.05,
              child: Text(
                "Change if you visited smth long press for delete,save after or cancel",
                style: TextStyle(fontSize: 15),
              ),
              alignment: Alignment.topLeft,
            ),
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: widget.trips.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    //leading: Image.asset('assets/images/imagess.jpg'),
                    title: Align(
                        alignment: Alignment.center,
                        child: Container(
                            child: Column(
                          children: [
                            Align(
                                alignment: Alignment.center,
                                child: Text(
                                  widget.trips[index].name,
                                  style: TextStyle(fontSize: 20),
                                )),
                            Divider(
                              color: Color.fromRGBO(159, 224, 172, 1),
                              height: 25,
                              thickness: 2,
                              indent: SizeConfig.screenWidth! * 0.2,
                              endIndent: SizeConfig.screenWidth! * 0.2,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //SizedBox(width: SizeConfig.screenWidth! * 0.22),
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Country: " + widget.trips[index].country,
                                      style: TextStyle(fontSize: 20),
                                    )),
                                SizedBox(width: SizeConfig.screenWidth! * 0.1),
                                Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "City: " + widget.trips[index].city,
                                      style: TextStyle(fontSize: 20),
                                    ))
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Visited: ",
                                    style: TextStyle(fontSize: 20)),
                                DropdownButton<String>(
                                  value: dropdown(widget.trips[index].visited),
                                  icon: const Icon(Icons.arrow_circle_down),
                                  elevation: 16,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 20),
                                  underline: Container(
                                    height: 2,
                                    color: Color.fromRGBO(159, 224, 172, 1),
                                  ),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      if (newValue == "Yes")
                                        widget.trips[index].visited = true;
                                      else
                                        widget.trips[index].visited = false;
                                    });
                                  },
                                  items: <String>[
                                    'Yes',
                                    'No',
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                )
                              ],
                            ),
                            // SizedBox(height: 20),
                            // Divider(),
                          ],
                        ))),
                    //  Text(title_for_list(widget.trips[index]),
                    //     style: TextStyle(fontSize: 20))),
                    onTap: () async {},
                    onLongPress: () {
                      showAlertDialog(context);
                    },
                    dense: false,

                    contentPadding: EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 30, bottom: 30),
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider();
                },
              ),
            )
          ])),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            elevation: 7,
            onPressed: () async {},
            label: const Text(
              " Save ",
              style: TextStyle(
                  color: Color.fromRGBO(54, 62, 74, 10),
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: Color.fromRGBO(159, 224, 172, 55),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(40))),
          ),
          SizedBox(
            height: 5,
          ),
          FloatingActionButton.extended(
            elevation: 7,
            onPressed: () async {},
            label: const Text(
              "Cancel",
              style: TextStyle(
                  color: Color.fromRGBO(54, 62, 74, 10),
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: Color.fromRGBO(159, 224, 172, 55),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(40))),
          ),
        ],
      ),
    );
  }

  String title_for_list(Trip t) {
    String s = "Name:" +
        t.name +
        "\n" +
        "Country: " +
        t.country +
        "\n" +
        "City: " +
        t.city +
        "\n" +
        "Visited: ";
    if (t.visited == false)
      s = s + "No";
    else
      s = s + "Yes";
    return s;
  }

  String dropdown(bool visited) {
    if (visited == true)
      return "Yes";
    else
      return "No";
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Nu"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
        // Navigator.pop(dialog)
      },
    );
    Widget continueButton = TextButton(child: Text("Da"), onPressed: () async {}
        //Navigator.of(context, rootNavigator: true).pop();

        // bool good = true;
        // try {
        //   appRepository.deleteAll(widget.dr, res[0], res[1]);
        // } catch (e) {
        //   good = false;
        // }
        // if (good == false) {
        //   showAlertDialogExceptions(context, 'Eroare', 'Eroare la stergere');
        // } else {
        //   Drinks drink = Drinks(
        //       nume: 'Sterge',
        //       modPreparare: 'modPreparare',
        //       categorie: 'categorie');

        // Navigator.pop(context, drink);
        // final snackBar = SnackBar(
        //   content: Builder(builder: (context) {
        //     return const Text('Bautura a fost stearsa');
        //   }),
        // );
        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
        //  }
        // },
        );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete destination"),
      content: Text(
          "Are you sure you dont't want to visit this tourist attraction anymore?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
