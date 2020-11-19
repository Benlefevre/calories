import 'dart:io';

import 'package:calories/utils.dart';
import 'package:calories/widgets/text_perso.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AgeButton extends StatefulWidget {
  final bool genre;
  final Function(double) callbackAge;

  AgeButton(this.genre, this.callbackAge);

  @override
  State<StatefulWidget> createState() {
    return _AgeButton();
  }
}

class _AgeButton extends State<AgeButton> {
  bool isWeb;
  bool genre;
  double age;

  @override
  void initState() {
    isWeb = kIsWeb;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    genre = widget.genre;
    if (!isWeb && Platform.isIOS) {
      return CupertinoButton(
        color: setColor(genre),
        onPressed: openPickerDate,
        child: TextPerso(
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
        elevation: 10.0,
        color: setColor(genre),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: TextPerso(
              (age == null)
                  ? "Entrer votre date de naissance"
                  : "Votre âge est de : ${age.toInt()}",
              color: Colors.white),
        ),
      );
    }
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
                    widget.callbackAge(age);
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
        initialDatePickerMode: DatePickerMode.year,
        initialEntryMode:
            isWeb ? DatePickerEntryMode.input : DatePickerEntryMode.calendar,
      );
      if (picked != null) {
        var diff = DateTime.now().difference(picked);
        var days = diff.inDays;
        var years = (days / 365);
        setState(() {
          age = years;
        });
        widget.callbackAge(age);
      }
    }
  }
}
