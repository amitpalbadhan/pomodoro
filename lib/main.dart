import 'package:flutter/material.dart';
import '/utils/colors.dart';

import 'app.dart';
import 'configure_nonweb.dart' if (dart.library.html) 'configure_web.dart';
import 'models/time_durations.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

import 'utils/platform_bools.dart';

void main() async {
  if (kIsWeb) {
    await setColorsWeb();
  } else {
    try {
      await setColorsLinux();
      isLinux = true;
    } catch (err) {
      initColors();
      print(err);
    }
  }

  setTime();
  configureApp();
  runApp(App());
}
