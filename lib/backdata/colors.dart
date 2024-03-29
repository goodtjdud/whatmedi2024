import 'package:flutter/material.dart';

class Colorsintegrate {
  Color medinavy = const Color(0xff1c3462);
  Color medigreen = const Color(0xff183f3e);
  Color medigreenwhite = const Color(0xffAFE6CB);
  Color medipink = const Color(0xfff6cecc);
  Color medipinkwhite = const Color(0xfff6d8cc);
  Color springgreen = const Color(0xff0ffa61);
  Color clover = const Color(0xff405016);
  Color emerald = const Color(0xff4cc87b);
  Color screamingreen = const Color(0xff58f391);
  Color seagreen = const Color(0xff319b4b);
  Color kPrimaryColor = Color(0xFF0C9869);
  Color kTextColor = Color(0xFF3C4046);
  Color kBackgroundColor = Color(0xFFF9F8FD);

//MaterialColor matgreen = MaterialColor();
}

final Colorsintegrate whatmedicol = Colorsintegrate();

//https://points.tistory.com/65 메테리얼 컬러 관련해서 할 수 있는 방법

//MaterialColor(int primary, Map<int, Color> swatch)

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  ;
  return MaterialColor(color.value, swatch);
}
