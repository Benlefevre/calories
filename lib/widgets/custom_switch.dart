import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomSwitch extends StatelessWidget{
  final Function(bool) callback;
  bool genre;

  CustomSwitch(this.callback,this.genre);

  @override
  Widget build(BuildContext context) {
    var isWeb = kIsWeb;
    if (!isWeb && Platform.isIOS) {
      return CupertinoSwitch(
        value: genre,
        trackColor: Colors.pink,
        activeColor: Colors.blue,
        onChanged: (bool b) {
          genre = b;
          callback(genre);
        },
      );
    } else {
      return Switch(
        value: genre,
        activeColor: Colors.blue,
        inactiveTrackColor: Colors.pink,
        onChanged: (bool b) {
            genre = b;
            callback(genre);
        },
      );
    }
  }

}