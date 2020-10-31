import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calories',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Calories'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double poids;
  double age;
  double taille = 170;
  bool genre = false;
  int selectedRadio;
  Map mapActivity = {0: "Faible", 1: "Modérée", 2: "Forte"};
  int caloriesBase;
  int caloriesActivite;
  bool isWeb = false;

  @override
  Widget build(BuildContext context) {
    Widget homepage;
    if (kIsWeb) {
      isWeb = true;
      print("IWeb");
      homepage = Scaffold(
        backgroundColor: Colors.grey[700],
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: setColor(),
        ),
        body: body(),
      );
    } else if (Platform.isIOS) {
      print("IOS");
      homepage = GestureDetector(
          onTap: (() => FocusScope.of(context).requestFocus(FocusNode())),
          child: CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              backgroundColor: setColor(),
              middle: textWithStyle("Calories"),
            ),
            backgroundColor: Colors.grey[700],
            child: body(),
          ));
    } else {
      print("Android");
      homepage = Scaffold(
        backgroundColor: Colors.grey[700],
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: setColor(),
        ),
        body: body(),
      );
    }
    return homepage;
  }

  SingleChildScrollView body() {
    return SingleChildScrollView(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          setPadding(),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: textWithStyle(
                "Remplissez tous les champs pour obtenir votre besoin journalier",
                color: Colors.white),
          ),
          setPadding(),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: Card(
              elevation: 10,
              child: Column(
                children: [
                  setPadding(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      textWithStyle("Femme", color: Colors.pink),
                      getSwitch(),
                      textWithStyle("Homme", color: Colors.blue)
                    ],
                  ),
                  setPadding(),
                  birthButton(),
                  setPadding(),
                  textWithStyle("Votre taille est de : ${taille.toInt()} cm",
                      color: setColor()),
                  setPadding(),
                  getSlider(),
                  setPadding(),
                  Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (String input) {
                        setState(() {
                          poids = double.tryParse(input);
                        });
                      },
                      cursorColor: setColor(),
                      decoration: InputDecoration(
                          labelText: "Entrez votre poids en kilos",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: setColor())),
                          labelStyle: TextStyle(
                            color: setColor(),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: setColor()))),
                    ),
                  ),
                  setPadding(),
                  textWithStyle("Quelle est votre activitée sportive ?",
                      color: setColor()),
                  setPadding(),
                  rowRadio(),
                  setPadding(),
                ],
              ),
            ),
          ),
          setPadding(),
          calButton(),
        ],
      ),
    );
  }

  openPickerDate() async {
    if (!isWeb && Platform.isIOS) {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext buildContext) {
            return Container(
              height: MediaQuery.of(context).size.height / 3,
              color: Colors.white,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: DateTime.now(),
                minimumDate: DateTime(1900),
                maximumDate: DateTime.now(),
                onDateTimeChanged: (picked) {
                  if (picked != null) {
                    var diff = DateTime.now().difference(picked);
                    var days = diff.inDays;
                    var years = (days / 365);
                    setState(() {
                      age = years;
                    });
                  }
                },
              ),
            );
          });
    } else {
      DateTime picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          initialDatePickerMode: DatePickerMode.year);
      if (picked != null) {
        var diff = DateTime.now().difference(picked);
        var days = diff.inDays;
        var years = (days / 365);
        setState(() {
          age = years;
        });
      }
    }
  }

  Padding setPadding() {
    return Padding(padding: EdgeInsets.only(top: 25));
  }

  Color setColor() {
    if (genre) {
      return Colors.blue;
    } else {
      return Colors.pink;
    }
  }

  Widget birthButton() {
    if (!isWeb && Platform.isIOS) {
      return CupertinoButton(
        color: setColor(),
        onPressed: openPickerDate,
        child: textWithStyle(
            (age == null)
                ? "Entrer votre date de naissance"
                : "Votre âge est de : ${age.toInt()}",
            color: Colors.white),
      );
    } else {
      return RaisedButton(
        onPressed: () {
          openPickerDate();
        },
        color: setColor(),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: textWithStyle(
              (age == null)
                  ? "Entrer votre date de naissance"
                  : "Votre âge est de : ${age.toInt()}",
              color: Colors.white),
        ),
      );
    }
  }

  Widget calButton() {
    if (!isWeb && Platform.isIOS) {
      return CupertinoButton(
        color: setColor(),
        onPressed: calculateCalories,
        child: textWithStyle("Calculer les calories", color: Colors.white),
      );
    } else {
      return RaisedButton(
        color: setColor(),
        onPressed: calculateCalories,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: textWithStyle("Calculer les calories", color: Colors.white),
        ),
      );
    }
  }

  Widget getSlider() {
    if (!isWeb && Platform.isIOS) {
      // if (Platform.isIOS) {
      return CupertinoSlider(
        value: taille,
        min: 90,
        max: 220,
        activeColor: setColor(),
        onChanged: (double d) {
          setState(() {
            taille = d;
          });
        },
      );
    } else {
      return Slider(
          value: taille,
          min: 90,
          max: 220,
          activeColor: setColor(),
          inactiveColor: Colors.grey[400],
          onChanged: (double d) {
            setState(() {
              taille = d;
            });
          });
    }
  }

  Widget getSwitch() {
    if (!isWeb && Platform.isIOS) {
      return CupertinoSwitch(
        value: genre,
        trackColor: Colors.pink,
        activeColor: Colors.blue,
        onChanged: (bool b) {
          setState(() {
            genre = b;
          });
        },
      );
    } else {
      return Switch(
        value: genre,
        activeColor: Colors.blue,
        inactiveTrackColor: Colors.pink,
        onChanged: (bool b) {
          setState(() {
            genre = b;
          });
        },
      );
    }
  }

  Widget textWithStyle(String data, {color: Colors.white, fontSize: 15.0}) {
    if (!isWeb && Platform.isIOS) {
      return DefaultTextStyle(
        style: TextStyle(color: color, fontSize: fontSize),
        child: Text(
          data,
          textAlign: TextAlign.center,
        ),
      );
    } else {
      return Text(data,
          textAlign: TextAlign.center,
          style: TextStyle(color: color, fontSize: fontSize));
    }
  }

  Row rowRadio() {
    List<Widget> widgets = [];
    mapActivity.forEach((key, value) {
      Column column = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Radio(
              activeColor: setColor(),
              value: key,
              groupValue: selectedRadio,
              onChanged: (Object i) {
                setState(() {
                  selectedRadio = i;
                });
              }),
          textWithStyle(value, color: setColor())
        ],
      );
      widgets.add(column);
    });
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: widgets,
    );
  }

  void calculateCalories() {
    if (age != null && poids != null && selectedRadio != null) {
      if (genre) {
        caloriesBase =
            (66.4730 + (13.7516 * poids) + (5.0033 * taille) - (6.7550 * age))
                .toInt();
      } else {
        caloriesBase =
            (655.0955 + (9.5634 * poids) + (1.8496 * taille) - (4.6756 * age))
                .toInt();
      }
      switch (selectedRadio) {
        case 0:
          caloriesActivite = (caloriesBase * 1.2).toInt();
          break;
        case 1:
          caloriesActivite = (caloriesBase * 1.5).toInt();
          break;
        case 2:
          caloriesActivite = (caloriesBase * 1.8).toInt();
          break;
      }
      setState(() {
        showCalories();
      });
    } else {
      alert();
    }
  }

  showCalories() async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext buildContext) {
          return SimpleDialog(
            title: textWithStyle("Votre besoin en calories", color: setColor()),
            contentPadding: EdgeInsets.all(12),
            children: [
              textWithStyle("Votre besoin de base est de : $caloriesBase",
                  color: Colors.black),
              setPadding(),
              textWithStyle(
                  "Votre activité avec activité sportive est de : $caloriesActivite",
                  color: Colors.black),
              setPadding(),
              RaisedButton(
                onPressed: () {
                  Navigator.pop(buildContext);
                },
                color: setColor(),
                child: textWithStyle('Ok'),
              )
            ],
          );
        });
  }

  alert() async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext buildContext) {
          if (!isWeb && Platform.isIOS) {
            return CupertinoAlertDialog(
              title: textWithStyle("Erreur", color: Colors.black),
              content: textWithStyle("Tous les champs ne sont pas remplis",
                  color: Colors.black),
              actions: [
                CupertinoButton(
                  onPressed: () {
                    Navigator.pop(buildContext);
                  },
                  child: textWithStyle("Ok", color: Colors.black),
                )
              ],
            );
          } else {
            return AlertDialog(
              title: textWithStyle("Erreur", color: Colors.black),
              content: textWithStyle("Tous les champs ne sont pas remplis",
                  color: Colors.black),
              actions: [
                FlatButton(
                  onPressed: () {
                    Navigator.pop(buildContext);
                  },
                  child: textWithStyle("Ok", color: Colors.black),
                ),
              ],
            );
          }
        });
  }
}
