import 'package:flutter/material.dart';
import '/views/settings/settings_view.dart';
import 'package:google_fonts/google_fonts.dart';

import 'utils/app_builder.dart';
import 'utils/colors.dart';
import 'views/home_view.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBuilder(
      builder: (context) {
        return MaterialApp(
          title: 'Pomodoro',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: kBackgroundColor,
            primaryColor: kPrimaryColor,
            canvasColor: kBackgroundColor,
            textTheme: GoogleFonts.latoTextTheme(),
          ),
          home: HomeView(),
          routes: <String, WidgetBuilder>{
            '/settings': (BuildContext context) => SettingsView(),
          },
        );
      },
    );
  }
}
