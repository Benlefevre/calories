import 'package:calories/utils.dart';
import 'package:calories/widgets/text_perso.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomRadio extends StatefulWidget {
  final bool genre;
  final Function(int) callbackRadio;

  CustomRadio(this.genre, this.callbackRadio);

  @override
  State<StatefulWidget> createState() {
    return _CustomRadio();
  }
}

class _CustomRadio extends State<CustomRadio> {
  bool isWeb;
  bool genre;
  int selectedRadio;
  Map mapActivity = {0: "Faible", 1: "Modérée", 2: "Forte"};

  @override
  void initState() {
    isWeb = kIsWeb;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    genre = widget.genre;
    List<Widget> widgets = [];
    mapActivity.forEach((key, value) {
      Column column = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Radio(
              activeColor: setColor(genre),
              value: key,
              groupValue: selectedRadio,
              onChanged: (Object i) {
                setState(() {
                  selectedRadio = i;
                });
                widget.callbackRadio(selectedRadio);
              }),
          TextPerso(
            value,
            color: setColor(genre),
          )
        ],
      );
      widgets.add(column);
    });
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: widgets,
    );
  }
}
