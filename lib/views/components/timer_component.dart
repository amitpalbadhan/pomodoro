import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/bloc/timer_bloc.dart';
import '/models/time_durations.dart';
import '/utils/colors.dart';
import '/utils/ticker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class TimerComponent extends StatefulWidget {
  const TimerComponent({Key? key}) : super(key: key);

  @override
  _TimerComponentState createState() => _TimerComponentState();
}

class _TimerComponentState extends State<TimerComponent>
    with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
        setState(() {});
      });

    controller.repeat(reverse: false);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemSound.play(SystemSoundType.click);

    return BlocProvider(
      create: (_) => TimerBloc(ticker: Ticker(), currentTimer: 0),
      child: TimerView(),
    );
  }
}

class TimerView extends StatelessWidget {
  const TimerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
          constraints:
              BoxConstraints(minWidth: 330, maxWidth: 960, minHeight: 500),
          height: height * 0.5,
          width: width * 0.5,
          color: kDangerColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('Pomodoro',
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 40.0,
                  )),
              Padding(
                padding: EdgeInsets.symmetric(vertical: height * 0.05),
                child: Center(child: TimerText()),
              ),
              Actions(),
            ],
          )),
    );
  }
}

class TimerText extends StatelessWidget {
  const TimerText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final duration = context.select((TimerBloc bloc) => bloc.state.duration);
    final totalIdx = context.select((TimerBloc bloc) => bloc.currentTimer);
    final minutesStr =
        ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    final secondsStr = (duration % 60).floor().toString().padLeft(2, '0');
    return AnimatedContainer(
      duration: Duration(milliseconds: 10),
      child: CircularPercentIndicator(
        radius: 200,
        lineWidth: height * 0.01,
        percent:
            (timerDurations[totalIdx] - duration) / timerDurations[totalIdx],
        center: FittedBox(
          child: Text(
            '$minutesStr:$secondsStr',
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 42.0,
            ),
          ),
        ),
        progressColor: kPrimaryColor,
      ),
    );
  }
}

class Actions extends StatelessWidget {
  const Actions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      buildWhen: (prev, state) => prev.runtimeType != state.runtimeType,
      builder: (context, state) {
        return Column(
          children: [
            Wrap(
              alignment: WrapAlignment.spaceAround,
              children: [
                if (state is TimerInitial) ...[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FloatingActionButton(
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.play_arrow,
                        color: kPrimaryColor,
                      ),
                      onPressed: () => context
                          .read<TimerBloc>()
                          .add(TimerStarted(duration: state.duration)),
                    ),
                  ),
                ],
                if (state is TimerRunInProgress) ...[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FloatingActionButton(
                      heroTag: "btn1",
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.pause,
                        color: kPrimaryColor,
                      ),
                      onPressed: () =>
                          context.read<TimerBloc>().add(TimerPaused()),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FloatingActionButton(
                      heroTag: "btn2",
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.replay,
                        color: kPrimaryColor,
                      ),
                      onPressed: () =>
                          context.read<TimerBloc>().add(TimerReset()),
                    ),
                  ),
                ],
                if (state is TimerRunPause) ...[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FloatingActionButton(
                      heroTag: "btn1",
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.play_arrow,
                        color: kPrimaryColor,
                      ),
                      onPressed: () =>
                          context.read<TimerBloc>().add(TimerResumed()),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FloatingActionButton(
                      heroTag: "btn2",
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.replay,
                        color: kPrimaryColor,
                      ),
                      onPressed: () =>
                          context.read<TimerBloc>().add(TimerReset()),
                    ),
                  ),
                ],
                if (state is TimerRunComplete) ...[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FloatingActionButton(
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.navigate_next,
                        color: kPrimaryColor,
                      ),
                      onPressed: () =>
                          context.read<TimerBloc>().add(TimerNext()),
                    ),
                  ),
                ]
              ],
            ),
            TextButton(
              child: Text(
                'Reset',
                style: GoogleFonts.montserrat(
                  color: kCaptionColor,
                  fontSize: 15.0,
                ),
              ),
              onPressed: () {
                context.read<TimerBloc>().currentTimer = 0;
                context.read<TimerBloc>().add(TimerReset());
              },
            ),
          ],
        );
      },
    );
  }
}
