import 'dart:io';

import 'package:calories/utils.dart';
import 'package:calories/widgets/age_button.dart';
import 'package:calories/widgets/calculate_button.dart';
import 'package:calories/widgets/custom_radio.dart';
import 'package:calories/widgets/custom_slider.dart';
import 'package:calories/widgets/custom_switch.dart';
import 'package:calories/widgets/text_perso.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  final bool genre;
  final Function(bool) callbackHome;

  Body(this.genre, this.callbackHome);

  @override
  State<StatefulWidget> createState() {
    return _Body();
  }
}

class _Body extends State<Body> {
  bool isWeb;
  bool genre;
  double taille = 170;
  double poids;
  double age;

  var caloriesActivite;
  var caloriesBase;
  var selectedRadio;

  @override
  void initState() {
    isWeb = kIsWeb;
    super.initState();
  }

  callbackGenre(bool) {
    setState(() {
      genre = bool;
    });
    widget.callbackHome(genre);
  }

  callbackTaille(height) {
    setState(() {
      taille = height;
    });
  }

  callbackAge(double) {
    setState(() {
      age = double;
    });
  }

  callbackRadio(int) {
    setState(() {
      selectedRadio = int;
    });
  }

  callbackCalculate() {
    calculateCalories();
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
            title: TextPerso(
              "Votre besoin en calories",
              color: setColor(genre),
            ),
            contentPadding: EdgeInsets.all(12),
            children: [
              TextPerso(
                "Votre besoin de base est de : $caloriesBase",
                color: Colors.black,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: TextPerso(
                  "Votre besoin avec activité sportive est de : $caloriesActivite",
                  color: Colors.black,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: RaisedButton(
                  onPressed: () {
                    Navigator.pop(buildContext);
                  },
                  color: setColor(genre),
                  child: TextPerso('Ok'),
                ),
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
              title: TextPerso(
                "Erreur",
                color: Colors.black,
              ),
              content: TextPerso(
                "Tous les champs ne sont pas remplis",
                color: Colors.black,
              ),
              actions: [
                CupertinoButton(
                  onPressed: () {
                    Navigator.pop(buildContext);
                  },
                  child: TextPerso(
                    "Ok",
                    color: Colors.black,
                  ),
                )
              ],
            );
          } else {
            return AlertDialog(
              title: TextPerso(
                "Erreur",
                color: Colors.black,
              ),
              content: TextPerso(
                "Tous les champs ne sont pas remplis",
                color: Colors.black,
              ),
              actions: [
                FlatButton(
                  color: setColor(genre),
                  onPressed: () {
                    Navigator.pop(buildContext);
                  },
                  child: TextPerso(
                    "Ok",
                  ),
                ),
              ],
            );
          }
        });
  }

  Widget getTextField() {
    return TextField(
      keyboardType: TextInputType.number,
      onChanged: (String input) {
        setState(() {
          poids = double.tryParse(input);
        });
      },
      cursorColor: setColor(genre),
      decoration: InputDecoration(
          labelText: "Entrez votre poids en kilos",
          border: OutlineInputBorder(
              borderSide: BorderSide(color: setColor(genre))),
          labelStyle: TextStyle(
            color: setColor(genre),
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: setColor(genre)))),
    );
  }

  @override
  Widget build(BuildContext context) {
    genre = widget.genre;
    return SingleChildScrollView(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 25.0),
            child: TextPerso(
                "Remplissez tous les champs pour obtenir votre besoin journalier",
                color: Colors.white),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, top: 25.0),
            child: Card(
              elevation: 10,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextPerso("Femme", color: Colors.pink),
                        CustomSwitch(callbackGenre, genre),
                        TextPerso("Homme", color: Colors.blue)
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: AgeButton(genre, callbackAge),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: TextPerso(
                        "Votre taille est de : ${taille.toInt()} cm",
                        color: setColor(genre)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: CustomSlider(genre, callbackTaille),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 12, right: 12, top: 25.0),
                    child: isWeb
                        ? Center(
                            child: SizedBox(
                              width: 350,
                              child: getTextField(),
                            ),
                          )
                        : getTextField(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: TextPerso("Quelle est votre activitée sportive ?",
                        color: setColor(genre)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0, bottom: 25.0),
                    child: CustomRadio(genre, callbackRadio),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: CalculateButton(genre, callbackCalculate),
          ),
        ],
      ),
    );
  }
}
