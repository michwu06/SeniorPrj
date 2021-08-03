import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:project/handler_exporter.dart';
import 'package:project/src/ui/home_away_status.dart';
import 'package:project/src/ui/util/global_timer.dart';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

import 'common_util.dart';

class AlignmentProcess extends StatefulWidget {
  @override
  _AlignmentProcessState createState() => _AlignmentProcessState();
}

class UpdateText extends StatefulWidget {
  _AlignmentProcessState createState() => _AlignmentProcessState();
}

class _AlignmentProcessState extends State<AlignmentProcess> {
  final String _startLabel = 'START';
  final int endTime = DateTime.now().microsecondsSinceEpoch + 1000 * 11;
  String _buttonLabel = 'Press to Begin';
  // Add timer labels here...
  static const _timerDuration = 10;
  Timer _timer;
  int _start = 10;
  bool _countdownStarted = false;
  // ignore: close_sinks
  final StreamController _timerStream = new StreamController<int>();
  Timer _resendCodeTimer;

  activeCounter() {
    _resendCodeTimer = new Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (_timerDuration - timer.tick > 0) {
        _timerStream.sink.add(_timerDuration - timer.tick);
      } else {
        _timerStream.sink.add(0);
        _resendCodeTimer.cancel();
        Navigator.pushNamed(context, '/homeAwayStatus');
      }
    });
  }

  @override
  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          //here
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
            if (_start <= 0) {
              GlobalTimer().startTimer();
              _buttonLabel = 'Press to Continue...';
            } else {
              _buttonLabel = 'Please Wait...$_start';
            }
          });
        }
      },
    );
  }

  @override
  void dispose() {
    resetCountdown();
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _timerStream.sink.add(0);
    super.initState();
  }

  void resetCountdown() {
    _countdownStarted = false;
    _buttonLabel = 'Press to Begin';
    _start = 10;
    GlobalTimer().stopTimer();
    GlobalTimer().resetTimer();
  }

  // @override
  // dispose() {
  //   _timerStream.close();
  //   _resendCodeTimer.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    Future<AudioPlayer> playLocalAsset() async {
      AudioCache cache = new AudioCache(prefix: 'sounds/');
      return await cache.play("notif.wav");
    }

    SizeConfig().init(context);
    var textHolder;
    return Scaffold(
      appBar: LevelAppBarDrawerless(),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          //Container(child: Text('$textHolder', style: TextStyle(fontSize: 21))),
          Container(
            margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 5),
            height: SizeConfig.blockSizeVertical * 72,
            width: SizeConfig.blockSizeHorizontal * 80,
            decoration: BoxDecoration(
              color: Color(0xFF454368),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 20),
            height: SizeConfig.blockSizeVertical * 30,
            width: SizeConfig.blockSizeHorizontal * 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: AutoSizeText(
              _startLabel,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                //color: Color(0xFF454368),
                fontFamily: 'Calibri',
                fontSize: 70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 62),
            child: ButtonTheme(
              height: SizeConfig.blockSizeVertical * 7,
              minWidth: SizeConfig.blockSizeHorizontal * 48,
              buttonColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              // ignore: deprecated_member_use
              child: RaisedButton(
                  child: Text(
                    _buttonLabel,
                    style: TextStyle(
                      fontSize: 24,
                      color: Color(0xFF454368),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onPressed: () {
                    // if noStarted
                    if (!_countdownStarted) {
                      _countdownStarted = true;
                      startTimer();
                      playLocalAsset();
                      _buttonLabel = 'Please Hold...$_start';
                    } else if (_countdownStarted && _start == 0) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => Status()));
                    } else {}

                    // else if(_start == 0)
                    // Navigate to new page
                    // else
                    // do nothing
                    /*setState(() {
                    _buttonLabel = 'Hold Position...';
                    activeCounter();
                  });*/
                  }),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 81),
            child: BottomBar(
              rightIcon: RightIcon.empty,
              routeToPush: '',
              verticalScale: 0,
            ),
          ),
          //Text("$_start"),
        ],
      ),
    );
  }
}
