import 'dart:io';

import 'package:calories/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomSlider extends StatefulWidget {
  final bool genre;
  final Function(double) callbackBody;

  CustomSlider(this.genre, this.callbackBody);

  @override
  State<StatefulWidget> createState() {
    return _CustomSlider();
  }
}

class _CustomSlider extends State<CustomSlider> {
  bool isWeb;
  bool genre;
  double taille = 170;

  @override
  void initState() {
    isWeb = kIsWeb;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    genre = widget.genre;
    if (!isWeb && Platform.isIOS) {
      return CupertinoSlider(
        value: taille,
        min: 90,
        max: 220,
        activeColor: setColor(genre),
        onChanged: (double d) {
          setState(() {
            taille = d;
          });
          widget.callbackBody(taille);
        },
      );
    } else {
      if (isWeb) {
        return Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.50,
            child: getMaterialSlider(),
          ),
        );
      } else {
        return getMaterialSlider();
      }
    }
  }

  Widget getMaterialSlider() {
    return Slider(
        value: taille,
        min: 90,
        max: 220,
        activeColor: setColor(genre),
        inactiveColor: Colors.grey[400],
        onChanged: (double d) {
          setState(() {
            taille = d;
          });
          widget.callbackBody(taille);
        });
  }
}
