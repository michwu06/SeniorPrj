import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:project/handler_exporter.dart';

import 'common_util.dart';

/// Add AppBar for Navigator during future sprints
class LevelAlignmentInstructions extends StatelessWidget {
  final String _alignmentLabel = 'Alignment Indicator';
  final String _startLabel = 'Start Alignment';
  final String _lineOne = 'Turn your phone volume on loud'
      ' and place this device in front of'
      ' your camera so that this screen is visible.';
  final String _lineTwo = 'While your camera is recording,'
      ' click \'Start Alignment\' and continue to hold the device'
      ' in front of the camera until you hear a ping sound.';
  final String _lineThree = 'This will line up your video and'
      ' scorekeeping after the game.';

  void _clearLineup() {
    LineupHandler handler = LineupHandler();
    handler.clearHitters();
    handler.clearPitcher();
    print(handler);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: LevelAppBarDrawerless(),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 5),
            height: SizeConfig.blockSizeVertical * 72,
            width: SizeConfig.blockSizeHorizontal * 80,
            decoration: BoxDecoration(
              color: LevelTheme.levelLightPurple,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  margin:
                      EdgeInsets.only(top: SizeConfig.blockSizeVertical * 3),
                  alignment: Alignment.topCenter,
                  child: Text(
                    _alignmentLabel,
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: null,
                    ),
                  ),
                ),
                Expanded(
                    child: Container(
                  alignment: Alignment.topCenter,
                  margin:
                      EdgeInsets.only(top: SizeConfig.blockSizeVertical * 3),
                  width: SizeConfig.blockSizeHorizontal * 75,
                  child: AutoSizeText(
                    _lineOne,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: null,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )),
                Expanded(
                    child: Container(
                  alignment: Alignment.topCenter,
                  margin:
                      EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1),
                  width: SizeConfig.blockSizeHorizontal * 70,
                  child: AutoSizeText(
                    _lineTwo,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: null,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )),
                Expanded(
                    child: Container(
                  alignment: Alignment.topCenter,
                  margin:
                      EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1),
                  width: SizeConfig.blockSizeHorizontal * 70,
                  child: AutoSizeText(
                    _lineThree,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: null,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )),
                Container(
                  margin: EdgeInsets.only(
                      top: SizeConfig.blockSizeVertical * 1,
                      bottom: SizeConfig.blockSizeVertical * 3),
                  child: ButtonTheme(
                    height: SizeConfig.blockSizeVertical * 8,
                    minWidth: SizeConfig.blockSizeHorizontal * 50,
                    buttonColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: RaisedButton(
                      child: Text(
                        _startLabel,
                        style: TextStyle(
                          fontSize: 26,
                          color: LevelTheme.levelLightPurple,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/alignmentProcess');
                      },
                    ),
                  ),
                ),
                //here
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 81),
            child: BottomBar(
              rightIcon: RightIcon.empty,
              routeToPush: '',
              verticalScale: 0,
              onLeftPressFunctions: [_clearLineup],
            ),
          ),
        ],
      ),
    );
  }
}
