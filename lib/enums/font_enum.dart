import 'package:flutter/material.dart';

/*
w100 Thin, the least thick
w200 Extra-light
w300 Light
w400 Normal / regular / plain
w500 Medium
w600 Semi-bold
w700 Bold
w800 Extra-bold
w900 Black, the most thick
* */


enum MyFont {
  rRegular,
  rBold,
  rLight,
  rMedium,
  rThin
}

extension ExtMyFont on MyFont {
  String get family {
    switch (this) {
      default:
        return "Roboto";
    }
  }

  FontWeight get weight {
    switch (this) {
      case MyFont.rLight:
        return FontWeight.w300;
      case MyFont.rRegular:
        return FontWeight.normal;
      case MyFont.rMedium:
        return FontWeight.w500;
      case MyFont.rThin:
        return FontWeight.w100;
      case MyFont.rBold:
        return FontWeight.w700;
    }
  }
}