import 'package:flutter/material.dart';

extension ThemeDataExtension on ThemeData {
  AppColorTheme get colorTheme => extension<AppColorTheme>() ?? AppColorTheme();
}

class AppColorTheme extends ThemeExtension<AppColorTheme> {
  AppColorTheme({
    this.orangeColor = const Color(0xFFFD673A),
    this.lightBlueColor = const Color(0xff8736F8),
    this.purpleColor = const Color(0xff2D2E43),
    this.greenColor = const Color(0xff189E6F),
    this.redColor = const Color(0xffb0b0b0),
    this.lightGreyColor = const Color(0xffF0F0F0),
    this.darkGreyColor = const Color(0xff555555),
    this.darkPurpleColor = const Color(0xff41224a),
    this.lightPurpleColor = const Color(0xff68506f),
    this.iconColor = const Color(0xff424242),
  });

  final Color orangeColor;

  final Color lightBlueColor;
  final Color purpleColor;
  final Color greenColor;
  final Color redColor;
  final Color lightGreyColor;
  final Color darkGreyColor;
  final Color darkPurpleColor;
  final Color lightPurpleColor;
  final Color iconColor;

  @override
  ThemeExtension<AppColorTheme> copyWith({
    Color? appPrimaryColor,
    Color? appSecondaryColor,
  }) {
    return AppColorTheme(
      orangeColor: appPrimaryColor ?? orangeColor,
      lightBlueColor: appSecondaryColor ?? lightBlueColor,
    );
  }

  @override
  ThemeExtension<AppColorTheme> lerp(
    covariant ThemeExtension<AppColorTheme>? other,
    double t,
  ) {
    if (other == null) {
      return this;
    }
    return AppColorTheme();
  }
}
