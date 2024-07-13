import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keys_saver/config/constants/colors.dart';
import 'package:keys_saver/config/extensions/color_from_hex.dart';

TextStyle googleFont = GoogleFonts.lato(
  textStyle: const TextStyle(),
);

TextStyle lightTextStyle = googleFont.copyWith(
  color: HexColor.fromHex(AppColors.primary800),
  fontWeight: FontWeight.w100
);

TextStyle darkTextStyle = googleFont.copyWith(
  color: HexColor.fromHex(AppColors.primary50),
  fontWeight: FontWeight.w100
);

TextStyle lightLargeTextStyle = lightTextStyle.copyWith(
  fontSize: 18
);

TextStyle lightMediumTextStyle = lightTextStyle.copyWith(
  fontSize: 15
);

TextStyle lightSmallTextStyle = lightTextStyle.copyWith(
  fontSize: 12
);

TextStyle darkLargeTextStyle = darkTextStyle.copyWith(
  fontSize: 15
);

TextStyle darkMediumTextStyle = darkTextStyle.copyWith(
  fontSize: 15
);

TextStyle darkSmallTextStyle = darkTextStyle.copyWith(
  fontSize: 12
);

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  brightness: Brightness.light,
  indicatorColor: HexColor.fromHex(AppColors.primary800),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: HexColor.fromHex(AppColors.secondary900),
    selectionColor: HexColor.fromHex(AppColors.secondary500),
  ),
  textTheme: TextTheme(
    bodyLarge: lightLargeTextStyle,
    bodyMedium: lightMediumTextStyle,
    bodySmall: lightSmallTextStyle,
  ),
  appBarTheme: AppBarTheme(
    centerTitle: false,
    titleTextStyle: lightMediumTextStyle
  ),
  primaryColor: HexColor.fromHex(AppColors.secondary900),
  secondaryHeaderColor: HexColor.fromHex(AppColors.primary50),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: HexColor.fromHex(AppColors.secondary900),
    elevation: 6
  ),
  disabledColor: HexColor.fromHex(AppColors.primary400),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll<Color>(HexColor.fromHex(AppColors.secondary900)),
      shape: const WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.zero))),
      elevation: const WidgetStatePropertyAll<double?>(0.0)
    )
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.black12,
    focusColor: HexColor.fromHex(AppColors.secondary500),
    hintStyle: lightSmallTextStyle.copyWith(color: HexColor.fromHex(AppColors.primary400)),
    labelStyle: lightMediumTextStyle,
    enabledBorder: UnderlineInputBorder(borderSide: BorderSide( color: HexColor.fromHex(AppColors.secondary900))),
    focusedErrorBorder: UnderlineInputBorder(borderSide: BorderSide( color: HexColor.fromHex(AppColors.darkRed))),
    focusedBorder: UnderlineInputBorder(borderSide: BorderSide( color: HexColor.fromHex(AppColors.secondary700)))
  )
);

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  brightness: Brightness.dark,
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: HexColor.fromHex(AppColors.secondary500),
    selectionColor: HexColor.fromHex(AppColors.secondary500),
  ),
  textTheme: TextTheme(
    bodyLarge: darkLargeTextStyle,
    bodyMedium: darkMediumTextStyle,
    bodySmall: darkSmallTextStyle,
  ),
  appBarTheme: AppBarTheme(
    centerTitle: false,
    titleTextStyle: darkMediumTextStyle
  ),
  primaryColor: HexColor.fromHex(AppColors.secondary500),
  secondaryHeaderColor: HexColor.fromHex(AppColors.primary600),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: HexColor.fromHex(AppColors.secondary500),
    elevation: 4
  ),
  disabledColor: HexColor.fromHex(AppColors.primary200),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll<Color>(HexColor.fromHex(AppColors.secondary500)),
      shape: const WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.zero))),
      elevation: const WidgetStatePropertyAll<double?>(0.0)
    )
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white10,
    focusColor: HexColor.fromHex(AppColors.secondary500),
    hintStyle: darkSmallTextStyle.copyWith(color: HexColor.fromHex(AppColors.primary400)),
    labelStyle: darkSmallTextStyle.copyWith(color: HexColor.fromHex(AppColors.secondary500)),
    enabledBorder: UnderlineInputBorder(borderSide: BorderSide( color: HexColor.fromHex(AppColors.secondary500))),
    focusedErrorBorder: UnderlineInputBorder(borderSide: BorderSide( color: HexColor.fromHex(AppColors.darkRed))),
    focusedBorder: UnderlineInputBorder(borderSide: BorderSide( color: HexColor.fromHex(AppColors.primary50)))
  )
);
