import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/settings.dart';
import 'package:frontend/models/sizeConf.dart';

enum Theme { light, dark }

class ThemePage extends StatefulWidget {
  Settings settings;
  ThemePage({Key? key, required this.settings}) : super(key: key);

  @override
  _ThemePageState createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  late Color col_background;
  late Color buttons_col;
  late Color color_border;
  late Color text_color;
  late Theme _theme;

  @override
  void initState() {
    super.initState();
    // appRepository = AppRepository(repo);
    getData();
  }

  Future getData() async {
    // log("iau datele de pe server pt prima pagina");
    // setState(() => isLoading = true);
    // try {
    //   settings = await appRepository.getSettingsForUser(widget.user.id!);
    // } catch (_) {
    //   log("nu gas setarea");

    //   //  exceptie.showAlertDialogExceptions(
    //   //context, "Eroare", "Nu se gasesc obiectele");
    // }
    if (widget.settings.theme == "light") {
      col_background = Colors.white;
      buttons_col = Color.fromRGBO(159, 224, 172, 1);
      color_border = Colors.white;
      text_color = Colors.black;
      _theme = Theme.light;
    } else {
      col_background = Color.fromRGBO(38, 41, 40, 1);
      buttons_col = Color.fromRGBO(38, 41, 40, 1);
      color_border = Colors.black;
      text_color = Color.fromRGBO(159, 224, 172, 1);
      _theme = Theme.dark;
    }

    // setState(() => isLoading = false);
  }

  // Color col_background = Colors.white;
  // Color buttons_col = Color.fromRGBO(159, 224, 172, 1);
  // Color color_border = Colors.white;
  // Color text_color = Colors.black;

  //dark
  // Color col_background = Color.fromRGBO(38, 41, 40, 1);
  // Color buttons_col = Color.fromRGBO(38, 41, 40, 1);
  // Color color_border = Colors.black;
  // Color text_color = Color.fromRGBO(159, 224, 172, 1);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Theme"),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, widget.settings);
          return false;
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(3, 0, 3, 0),
          decoration: BoxDecoration(
            color: col_background,
          ),
          child: Column(
            children: <Widget>[
              SizedBox(height: SizeConfig.blockSizeVertical! * 2),
              Container(
                child: Container(
                    width: SizeConfig.screenWidth!,
                    height: SizeConfig.screenHeight! * 0.06,
                    // padding: EdgeInsets.fromLTRB(3, 10, 0, 3),
                    //alignment: AlignmentGeometry.lerp(a, b, t),
                    child: ListTile(
                      title: Text(
                        "Light",
                        style: TextStyle(color: text_color, fontSize: 20),
                        //textAlign: TextAlign.left,
                      ),
                      leading: Radio(
                        value: Theme.light,
                        groupValue: _theme,
                        onChanged: (Theme? value) {
                          setState(() {
                            widget.settings.theme = "light";
                            _theme = value!;
                            col_background = Colors.white;
                            buttons_col = Color.fromRGBO(159, 224, 172, 1);
                            color_border = Colors.white;
                            text_color = Colors.black;
                          });
                        },
                        activeColor: text_color,
                      ),
                    ),
                    decoration: BoxDecoration(
                        color: buttons_col,
                        border: Border.all(color: color_border, width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(12)))),
              ),
              Container(
                child: Container(
                    width: SizeConfig.screenWidth!,
                    height: SizeConfig.screenHeight! * 0.06,
                    // padding: EdgeInsets.fromLTRB(3, 10, 0, 3),
                    //alignment: AlignmentGeometry.lerp(a, b, t),
                    child: ListTile(
                      title: Text(
                        "Dark",
                        style: TextStyle(color: text_color, fontSize: 20),
                        //textAlign: TextAlign.left,
                      ),
                      leading: Radio(
                          value: Theme.dark,
                          groupValue: _theme,
                          onChanged: (Theme? value) {
                            setState(() {
                              widget.settings.theme = "dark";
                              _theme = value!;
                              col_background = Color.fromRGBO(38, 41, 40, 1);
                              buttons_col = Color.fromRGBO(38, 41, 40, 1);
                              color_border = Colors.black;
                              text_color = Color.fromRGBO(159, 224, 172, 1);
                            });
                          },
                          activeColor: text_color),
                    ),
                    decoration: BoxDecoration(
                        color: buttons_col,
                        border: Border.all(color: color_border, width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(12)))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
