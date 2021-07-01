import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_linux/shared_preferences_linux.dart'
    if (dart.library.html) 'package:shared_preferences_web/shared_preferences_web.dart';

List<int> timerDurations = [];

/*
void setTimeLinux() async {
  final prefs = SharedPreferencesLinux.instance;
  final values = await prefs.getAll();

  final work = values['work'] as int? ?? 1500;
  final short = values['short'] as int? ?? 300;
  final long = values['long'] as int? ?? 900;

  setTime(
    work: work,
    short: short,
    long: long,
  );
}

void setTimeWeb() async {
  final prefs = await SharedPreferences.getInstance();

  final work = prefs.getInt('work') ?? 1500;
  final short = prefs.getInt('short') ?? 300;
  final long = prefs.getInt('long') ?? 900;

  setTime(
    work: work,
    short: short,
    long: long,
  );
}
*/

void setTime({
  int work = 1500,
  int short = 300,
  int long = 900,
}) {
  timerDurations = [work, short, work, short, work, short, work, long];
}
