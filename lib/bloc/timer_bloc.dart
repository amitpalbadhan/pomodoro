import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '/models/time_durations.dart';
import '/utils/ticker.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  int currentTimer = 0;

  final Ticker _ticker;
  int _duration = 60;

  StreamSubscription<int>? _tickerSubscribtion;

  TimerBloc({required Ticker ticker, required this.currentTimer})
      : _ticker = ticker,
        _duration = timerDurations[0],
        super(TimerInitial(timerDurations[0]));

  @override
  Stream<TimerState> mapEventToState(
    TimerEvent event,
  ) async* {
    if (event is TimerStarted) {
      yield* _mapTimerStartedToState(event);
    } else if (event is TimerPaused) {
      yield* _mapTimerPausedToState(event);
    } else if (event is TimerResumed) {
      yield* _mapTimerResumedToState(event);
    } else if (event is TimerReset) {
      yield* _mapTimerResetToState(event);
    } else if (event is TimerNext) {
      yield* _mapTimerNextToState(event);
    } else if (event is TimerTicked) {
      yield* _mapTimerTickedToState(event);
    }
  }

  @override
  Future<void> close() {
    _tickerSubscribtion?.cancel();
    return super.close();
  }

  Stream<TimerState> _mapTimerStartedToState(TimerStarted start) async* {
    yield TimerRunInProgress(start.duration);
    _tickerSubscribtion?.cancel();
    _tickerSubscribtion = _ticker
        .tick(ticks: start.duration)
        .listen((duration) => add(TimerTicked(duration: duration)));
  }

  Stream<TimerState> _mapTimerPausedToState(TimerPaused pause) async* {
    if (state is TimerRunInProgress) {
      _tickerSubscribtion?.pause();
      yield TimerRunPause(state.duration);
    }
  }

  Stream<TimerState> _mapTimerResumedToState(TimerResumed resume) async* {
    if (state is TimerRunPause) {
      _tickerSubscribtion?.resume();
      yield TimerRunInProgress(state.duration);
    }
  }

  Stream<TimerState> _mapTimerResetToState(TimerReset reset) async* {
    _tickerSubscribtion?.cancel();
    yield TimerInitial(_duration);
  }

  Stream<TimerState> _mapTimerNextToState(TimerNext reset) async* {
    _tickerSubscribtion?.cancel();
    if (currentTimer >= timerDurations.length) currentTimer = -1;
    _duration = timerDurations[++currentTimer];
    yield TimerInitial(_duration);
  }

  Stream<TimerState> _mapTimerTickedToState(TimerTicked tick) async* {
    if (tick.duration > 0)
      yield TimerRunInProgress(tick.duration);
    else {
      AudioPlayer audioPlayer = AudioPlayer();
      audioPlayer.play('assets/sound_alarm.mp3');
      yield TimerRunComplete();
    }
  }
}
