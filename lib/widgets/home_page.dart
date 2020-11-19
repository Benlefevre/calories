import 'dart:io';

import 'package:calories/utils.dart';
import 'package:calories/widgets/body.dart';
import 'package:calories/widgets/text_perso.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final String title;

  Home(this.title);

  @override
  State<StatefulWidget> createState() {
    return _Home();
  }
}

class _Home extends State<Home> {
  bool isWeb;
  bool genre = false;

  @override
  void initState() {
    isWeb = kIsWeb;
    super.initState();
  }

  callback(bool) {
    setState(() {
      genre = bool;
    });
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.title;
    Widget homepage;
    if (!isWeb && Platform.isIOS) {
      homepage = GestureDetector(
          onTap: (() => FocusScope.of(context).requestFocus(FocusNode())),
          child: CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              backgroundColor: setColor(genre),
              middle: TextPerso(title,fontSize: 24.0),
            ),
            backgroundColor: Colors.grey[700],
            child: Body(genre, callback),
          ));
    } else {
      homepage = Scaffold(
        backgroundColor: Colors.grey[700],
        appBar: AppBar(
          title: TextPerso(title, fontSize: 24.0),
          centerTitle: true,
          backgroundColor: setColor(genre),
        ),
        body: Body(genre, callback),
      );
    }
    return homepage;
  }
}
