import 'package:flutter/material.dart';
import 'level_theme.dart';
import 'global_timer.dart';

class LevelAppBarDrawerless extends StatefulWidget
    implements PreferredSizeWidget {
  LevelAppBarDrawerless({Key key})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  _LevelAppBarDrawerlessState createState() => _LevelAppBarDrawerlessState();
}

class _LevelAppBarDrawerlessState extends State<LevelAppBarDrawerless> {
  var _widgetlessTimer = GlobalTimer();
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false, // Used for removing back buttoon.
      title: _widgetlessTimer.buildTimerText(),
      //Image.asset('images/level12.png', fit: BoxFit.contain, height: 35),
      centerTitle: true,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: LevelTheme.levelDarkPurple),
      bottom: PreferredSize(
        child: Container(color: LevelTheme.levelDarkPurple, height: 2.0),
        preferredSize: Size.fromHeight(2.0),
      ),
    );
  }
}
