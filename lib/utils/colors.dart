import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import ''
    if (dart.library.html) 'package:shared_preferences_web/shared_preferences_web.dart';
import 'package:shared_preferences_linux/shared_preferences_linux.dart';

Color hexToColor(String code) {
  return code.contains('#')
      ? Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000)
      : Color(int.parse(code, radix: 16) + 0xFF000000);
}

Color kPrimaryColor = Colors.white;
Color kBackgroundColor = Colors.white;
Color kDangerColor = Colors.white;
Color kCaptionColor = Colors.white;

void initColors({
  String one = 'ff006e',
  String two = '0f1119',
  String three = '1976D2',
  String four = 'a6b1bb',
}) {
  kPrimaryColor = hexToColor(one);
  kBackgroundColor = hexToColor(two);
  kDangerColor = hexToColor(three);
  kCaptionColor = hexToColor(four);
}

Future<void> setColorsLinux() async {
  final prefs = SharedPreferencesLinux.instance;
  final values = await prefs.getAll();

  final primaryColor = values['primaryColor'] as String? ?? 'ff006e';
  final backgroundColor = values['backgroundColor'] as String? ?? '0f1119';
  final dangerColor = values['dangerColor'] as String? ?? '1976D2';
  final captionColor = values['captionColor'] as String? ?? 'a6b1bb';

  initColors(
    one: primaryColor,
    two: backgroundColor,
    three: dangerColor,
    four: captionColor,
  );
}

Future<void> setColorsWeb() async {
  final prefs = await SharedPreferences.getInstance();

  final primaryColor = prefs.getString('primaryColor') ?? 'ff006e';
  final backgroundColor = prefs.getString('backgroundColor') ?? '0f1119';
  final dangerColor = prefs.getString('dangerColor') ?? '1976D2';
  final captionColor = prefs.getString('captionColor') ?? 'a6b1bb';

  initColors(
    one: primaryColor,
    two: backgroundColor,
    three: dangerColor,
    four: captionColor,
  );
}
