import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TextPerso extends StatelessWidget {
  final String data;
  final Color color;
  final double fontSize;

  TextPerso(this.data,
      {this.color = Colors.white, this.fontSize = 15.0});

  @override
  Widget build(BuildContext context) {
    var isWeb = kIsWeb;
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
}
