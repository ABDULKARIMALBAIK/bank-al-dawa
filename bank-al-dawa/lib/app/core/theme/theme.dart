import 'package:bank_al_dawa/app/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData themeLight = ThemeData(

      //Custom Color
      hintColor: ConstColors().shadowLeftColorLight(),
      dividerColor: ConstColors().shadowRightColorLight(),
      canvasColor: ConstColors().textBodyColorLight(),
      //Custom Color

      brightness: Brightness.light,
      primaryColor: ConstColors().primaryColorLight(),
      disabledColor: ConstColors().cardColorLight(),

      // ignore: deprecated_member_use
      primaryColorBrightness: Brightness.light,
      primaryColorLight: ConstColors().primaryColorLight(),
      primaryColorDark: ConstColors().primaryColorDark(),
      // ignore: deprecated_member_use
      accentColor: ConstColors().accentColorLight(),
      // ignore: deprecated_member_use
      accentColorBrightness: Brightness.light,
      scaffoldBackgroundColor: ConstColors().backgroundColorLight(),
      backgroundColor: ConstColors().cardColorLight(),
      bottomAppBarColor: ConstColors().cardColorLight(),
      cardColor: ConstColors().cardColorLight(),
      dialogBackgroundColor: ConstColors().cardColorLight(),
      indicatorColor: ConstColors().primaryColorLight(),
      scrollbarTheme: ScrollbarThemeData(
        //thumbVisibility: MaterialStateProperty.all(false),
        thickness: MaterialStateProperty.all(12),
        interactive: true,
        thumbColor: MaterialStateProperty.all(
            ConstColors().primaryColorLight().withOpacity(0.3)),
        radius: const Radius.circular(10),
        minThumbLength: 100,
      ),
      textTheme: TextTheme(
          headline1: GoogleFonts.notoKufiArabic(
              color: ConstColors().textTitleColorLight()),
          headline2: GoogleFonts.notoKufiArabic(
              color: ConstColors().textTitleColorLight()),
          headline3: GoogleFonts.notoKufiArabic(
              color: ConstColors().textTitleColorLight()),
          headline4: GoogleFonts.notoKufiArabic(
              color: ConstColors().textTitleColorLight()),
          headline5: GoogleFonts.notoKufiArabic(
              color: ConstColors().textTitleColorLight()),
          headline6: GoogleFonts.notoKufiArabic(
              color: ConstColors().textTitleColorLight()),
          bodyText1: GoogleFonts.notoKufiArabic(
              color: ConstColors().textTitleColorLight()),
          bodyText2: GoogleFonts.notoKufiArabic(
              color: ConstColors().textTitleColorLight()),
          subtitle1: GoogleFonts.notoKufiArabic(
              color: ConstColors().textTitleColorLight()),
          subtitle2: GoogleFonts.notoKufiArabic(
              color: ConstColors().textTitleColorLight()),
          button: GoogleFonts.notoKufiArabic(
              color: ConstColors().textTitleColorLight()),
          caption: GoogleFonts.notoKufiArabic(
              color: ConstColors().textTitleColorLight()),
          overline: GoogleFonts.notoKufiArabic(
              color: ConstColors().textTitleColorLight())),
      tabBarTheme: TabBarTheme(
          labelColor: ConstColors().cardColorLight(),
          unselectedLabelColor: ConstColors().primaryColorLight()),
      iconTheme: IconThemeData(color: ConstColors().textTitleColorLight()),
      primaryIconTheme: IconThemeData(color: ConstColors().primaryColorLight()),
      // ignore: deprecated_member_use
      accentIconTheme: IconThemeData(color: ConstColors().accentColorLight()),
      chipTheme: ChipThemeData(
          brightness: Brightness.light,
          backgroundColor: ConstColors().cardColorLight(),
          disabledColor: ConstColors().backgroundColorLight(),
          selectedColor: ConstColors().primaryColorLight(),
          checkmarkColor: ConstColors().textTitleColorDark(),
          deleteIconColor: ConstColors().textTitleColorDark(),
          shadowColor: ConstColors().primaryColorLight(),
          labelStyle: GoogleFonts.notoKufiArabic(
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
          secondaryLabelStyle: const TextStyle(),
          padding: const EdgeInsets.all(8),
          secondarySelectedColor: ConstColors().primaryColorLight()),
      appBarTheme: AppBarTheme(
          backgroundColor: ConstColors().cardColorLight(),
          elevation: 6,
          // brightness: Brightness.light,
          actionsIconTheme:
              IconThemeData(color: ConstColors().textTitleColorLight()),
          // centerTitle: PlatformDetector().isIOS() ? true : false,
          shadowColor: ConstColors().textTitleColorLight(),
          titleTextStyle: GoogleFonts.notoKufiArabic(
              color: ConstColors().textTitleColorLight()),
          toolbarTextStyle: GoogleFonts.notoKufiArabic(
              color: ConstColors().textTitleColorLight())),
      bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: ConstColors().backgroundColorLight(),
          elevation: 8,
          modalBackgroundColor: ConstColors().backgroundColorLight(),
          modalElevation: 9),
      checkboxTheme: CheckboxThemeData(
          checkColor: MaterialStateProperty.all(ConstColors().cardColorLight()),
          splashRadius: 8,
          mouseCursor: MaterialStateProperty.all(MouseCursor.defer),
          fillColor:
              MaterialStateProperty.all(ConstColors().primaryColorLight()),
          overlayColor: MaterialStateProperty.all(Colors.green[100])),
      radioTheme: RadioThemeData(
          splashRadius: 8,
          mouseCursor: MaterialStateProperty.all(MouseCursor.defer),
          fillColor:
              MaterialStateProperty.all(ConstColors().primaryColorLight()),
          overlayColor: MaterialStateProperty.all(Colors.green[100])),
      switchTheme: SwitchThemeData(
          thumbColor:
              MaterialStateProperty.all(ConstColors().primaryColorLight()),
          trackColor: MaterialStateProperty.all(Colors.green[100]),
          splashRadius: 8,
          mouseCursor: MaterialStateProperty.all(MouseCursor.defer),
          overlayColor: MaterialStateProperty.all(Colors.green[100])));

  static ThemeData themeDark = ThemeData(

      //Custom Color
      hintColor: ConstColors().shadowLeftColorDark(),
      dividerColor: ConstColors().shadowRightColorDark(),
      canvasColor: ConstColors().textBodyColorDark(),
      //Custom Color

      brightness: Brightness.dark,
      primaryColor: ConstColors().primaryColorDark(),
      disabledColor: ConstColors().cardColorDark(),

      // ignore: deprecated_member_use
      primaryColorBrightness: Brightness.dark,
      primaryColorLight: ConstColors().primaryColorLight(),
      primaryColorDark: ConstColors().primaryColorDark(),
      // ignore: deprecated_member_use
      accentColor: ConstColors().accentColorDark(),
      // ignore: deprecated_member_use
      accentColorBrightness: Brightness.dark,
      backgroundColor: ConstColors().cardColorDark(),
      scaffoldBackgroundColor: ConstColors().backgroundColorDark(),
      bottomAppBarColor: ConstColors().cardColorDark(),
      cardColor: ConstColors().cardColorDark(),
      dialogBackgroundColor: ConstColors().cardColorDark(),
      indicatorColor: ConstColors().primaryColorDark(),
      scrollbarTheme: ScrollbarThemeData(
        //thumbVisibility: MaterialStateProperty.all(false),
        interactive: true,
        thickness: MaterialStateProperty.all(12),
        thumbColor: MaterialStateProperty.all(
            ConstColors().primaryColorDark().withOpacity(0.3)),
        radius: const Radius.circular(12),
        minThumbLength: 100,
      ),
      textTheme: TextTheme(
          headline1: GoogleFonts.notoKufiArabic(
              color: ConstColors().textTitleColorDark()),
          headline2: GoogleFonts.notoKufiArabic(
              color: ConstColors().textTitleColorDark()),
          headline3: GoogleFonts.notoKufiArabic(
              color: ConstColors().textTitleColorDark()),
          headline4: GoogleFonts.notoKufiArabic(
              color: ConstColors().textTitleColorDark()),
          headline5: GoogleFonts.notoKufiArabic(
              color: ConstColors().textTitleColorDark()),
          headline6: GoogleFonts.notoKufiArabic(
              color: ConstColors().textTitleColorDark()),
          bodyText1: GoogleFonts.notoKufiArabic(
              color: ConstColors().textTitleColorDark()),
          bodyText2: GoogleFonts.notoKufiArabic(
              color: ConstColors().textTitleColorDark()),
          subtitle1: GoogleFonts.notoKufiArabic(
              color: ConstColors().textTitleColorDark()),
          subtitle2: GoogleFonts.notoKufiArabic(
              color: ConstColors().textTitleColorDark()),
          button: GoogleFonts.notoKufiArabic(
              color: ConstColors().textTitleColorDark()),
          caption: GoogleFonts.notoKufiArabic(
              color: ConstColors().textTitleColorDark()),
          overline: GoogleFonts.notoKufiArabic(
              color: ConstColors().textTitleColorDark())),
      tabBarTheme: TabBarTheme(
          labelColor: ConstColors().cardColorDark(),
          unselectedLabelColor: ConstColors().primaryColorDark()),
      iconTheme: IconThemeData(color: ConstColors().textTitleColorDark()),
      primaryIconTheme: IconThemeData(color: ConstColors().primaryColorDark()),
      // ignore: deprecated_member_use
      accentIconTheme: IconThemeData(color: ConstColors().accentColorDark()),
      chipTheme: ChipThemeData(
          brightness: Brightness.light,
          backgroundColor: ConstColors().cardColorDark(),
          disabledColor: ConstColors().backgroundColorDark(),
          selectedColor: ConstColors().primaryColorDark(),
          checkmarkColor: ConstColors().textTitleColorDark(),
          deleteIconColor: ConstColors().textTitleColorDark(),
          shadowColor: ConstColors().primaryColorLight(),
          labelStyle: GoogleFonts.notoKufiArabic(
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
          secondaryLabelStyle: const TextStyle(),
          padding: const EdgeInsets.all(8),
          secondarySelectedColor: ConstColors().primaryColorLight()),
      appBarTheme: AppBarTheme(
          backgroundColor: ConstColors().cardColorDark(),
          elevation: 6,
          // brightness: Brightness.dark,
          actionsIconTheme:
              IconThemeData(color: ConstColors().textTitleColorDark()),
          // centerTitle: PlatformDetector().isIOS() ? true : false,
          shadowColor: ConstColors().textTitleColorLight(),
          titleTextStyle: GoogleFonts.notoKufiArabic(
              color: ConstColors().textTitleColorDark()),
          toolbarTextStyle: GoogleFonts.notoKufiArabic(
              color: ConstColors().textTitleColorDark())),
      bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: ConstColors().backgroundColorDark(),
          elevation: 8,
          modalBackgroundColor: ConstColors().backgroundColorDark(),
          modalElevation: 8),
      checkboxTheme: CheckboxThemeData(
          checkColor: MaterialStateProperty.all(ConstColors().cardColorLight()),
          splashRadius: 8,
          mouseCursor: MaterialStateProperty.all(MouseCursor.defer),
          fillColor:
              MaterialStateProperty.all(ConstColors().primaryColorDark()),
          overlayColor: MaterialStateProperty.all(Colors.blue[100])),
      radioTheme: RadioThemeData(
          splashRadius: 8,
          mouseCursor: MaterialStateProperty.all(MouseCursor.defer),
          fillColor:
              MaterialStateProperty.all(ConstColors().primaryColorDark()),
          overlayColor: MaterialStateProperty.all(Colors.blue[100])),
      switchTheme: SwitchThemeData(
          thumbColor:
              MaterialStateProperty.all(ConstColors().primaryColorDark()),
          trackColor: MaterialStateProperty.all(Colors.blue[100]),
          splashRadius: 8,
          mouseCursor: MaterialStateProperty.all(MouseCursor.defer),
          overlayColor: MaterialStateProperty.all(Colors.blue[100])));
}
