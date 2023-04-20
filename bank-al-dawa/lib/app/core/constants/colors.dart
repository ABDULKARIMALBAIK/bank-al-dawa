import 'package:flutter/material.dart';

class ConstColors {
  Color primaryColorLight() => Colors.green;
  Color primaryColorDark() => Colors.greenAccent[400]!;

  Color accentColorLight() => Colors.green;
  Color accentColorDark() => Colors.greenAccent[400]!;

  Color backgroundColorLight() => const Color(0xFFE7ECEF); //Colors.white
  Color backgroundColorDark() =>
      const Color(0xFF2E3239); //const Color(0xFF181818)

  Color cardColorLight() => const Color(0xFFF8F8F8); //const Color(0xFFF8F8F8)
  Color cardColorDark() => const Color(0xFF0E0E0E); //const Color(0xFF0E0E0E)

  Color textTitleColorLight() => Colors.black;
  Color textTitleColorDark() => Colors.white;

  Color textBodyColorLight() => Colors.black38;
  Color textBodyColorDark() => Colors.white38;

  //Colors of custom card
  Color shadowLeftColorLight() => Colors.white;
  Color shadowLeftColorDark() => const Color(0xFF35393F);

  Color shadowRightColorLight() => const Color(0xFFA7A9AF);
  Color shadowRightColorDark() => const Color(0xFF23262A);
}
