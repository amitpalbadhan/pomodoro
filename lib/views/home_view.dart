import 'package:flutter/material.dart';
import '/utils/colors.dart';

import 'components/timer_component.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hsl = HSLColor.fromColor(kBackgroundColor);
    print(hsl);
    var newHue = hsl.hue + 180;
    if (newHue > 360) newHue -= 360;
    final newHSL = HSLColor.fromAHSL(
        1,
        newHue,
        hsl.saturation < 0.5 ? hsl.saturation + 0.5 : hsl.saturation - 0.5,
        hsl.lightness < 0.5 ? hsl.lightness + 0.5 : hsl.lightness - 0.5);
    print(newHSL);
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          children: [
            Positioned(
              top: width * 0.02,
              right: width * 0.02,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  color: newHSL.toColor(),
                  child: IconButton(
                    splashRadius: width * 0.02,
                    icon: Icon(
                      Icons.settings,
                      color: kBackgroundColor,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/settings');
                    },
                  ),
                ),
              ),
            ),
            Center(
              child: TimerComponent(),
            ),
          ],
        ),
      ),
    );
  }
}
