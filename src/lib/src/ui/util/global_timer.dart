import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'level_theme.dart';

class GlobalTimer {
  static final GlobalTimer _widgetlessTimer = GlobalTimer._internal();
  String _timerStr;
  String _startTime; // The start time of a play.
  String _endTime; // The end time of a play.
  final _stopWatchTimer = StopWatchTimer(mode: StopWatchMode.countUp);

  GlobalTimer._internal();

  factory GlobalTimer() {
    return _widgetlessTimer;
  }

  void startTimer() {
    if (!_stopWatchTimer.isRunning) {
      _stopWatchTimer.onExecute.add(StopWatchExecute.start);
    }
  }

  void stopTimer() {
    if (_stopWatchTimer.isRunning) {
      _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
    }
  }

  void resetTimer() {
    _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
  }

  void recordStartTime() {
    _startTime = _timerStr;
    _startTime = _startTime.split('.').first + ',000';
    //print(_startTime);
  }

  void recordEndTime() {
    _endTime = _timerStr;
    _endTime = _endTime.split('.').first + ',000';
  }

  String getStartTime() {
    return _startTime;
  }

  String getEndTime() {
    return _endTime;
  }

  String getTimerStr() {
    return _timerStr;
  }

  Container buildTimerText() {
    return Container(
      child: StreamBuilder<int>(
        stream: _stopWatchTimer.rawTime,
        initialData: 0,
        builder: (context, snap) {
          final value = snap.data;
          final displayTime = StopWatchTimer.getDisplayTime(value);
          _timerStr = displayTime;
          return Text(displayTime,
              style:
                  TextStyle(color: LevelTheme.levelLightPurple, fontSize: 18));
        },
      ),
    );
  }
}
