import 'dart:io';

import 'package:calories/utils.dart';
import 'package:calories/widgets/text_perso.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CalculateButton extends StatefulWidget {
  final bool genre;
  final Function() callbackBody;

  CalculateButton(this.genre, this.callbackBody);

  @override
  State<StatefulWidget> createState() {
    return _CalculateButton();
  }
}

class _CalculateButton extends State<CalculateButton> {
  bool isWeb;
  bool genre;

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
        onPressed: widget.callbackBody,
        child: TextPerso(
          "Calculer les calories",
          color: Colors.white,
        ),
      );
    } else {
      return RaisedButton(
        color: setColor(genre),
        onPressed: widget.callbackBody,
        elevation: 10.0,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextPerso(
            "Calculer les calories",
            color: Colors.white,
          ),
        ),
      );
    }
  }
}
