
import 'package:flutter/material.dart';

Color setColor(bool genre) {
  if (genre) {
    return Colors.blue;
  } else {
    return Colors.pink;
  }
}

Padding setPadding(){
  return Padding(padding: EdgeInsets.only(top: 25));
}