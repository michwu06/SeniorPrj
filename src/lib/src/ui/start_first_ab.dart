import 'dart:developer';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/handler_exporter.dart';
import 'package:project/src/ui/util/global_timer.dart';
import 'transition_next_ab.dart';
import 'event_summary.dart';

import 'common_util.dart';

class Start1stAB extends StatefulWidget {
  @override
  _Start1stABState createState() => _Start1stABState();
}

class _Start1stABState extends State<Start1stAB> {
  //final List<Player> _playerList = LineupHandler().getStartingHitters();
  final List<Player> _playerList = LineupHandler().getSortedRoster();
  // final List<Player> playerList = LineupHandler().getRoster();
  //final HomeAwayStatus _homeAwayStatus = ScoringHandler().getHomeAwayStatus();

  String scoreType;
  ScoreType _scoreType;
  // Get next player based on Home-Away and Top-Bot
  Player selectedPlayer = ScoringHandler().getPlayerToScore();

/* 
  String playerName;
  int inning = 1;
  */

  bool _strikeout = false,
      _flyout = false,
      _single = false,
      _triple = false,
      _error = false,
      _bbhbp = false,
      _groundout = false,
      _double = false,
      _homerun = false,
      _bunt = false;

  resetButtons() {
    print('reset Buttons');
    scoreType = null;
    _scoreType = null;
    _strikeout = false;
    _flyout = false;
    _single = false;
    _triple = false;
    _error = false;
    _groundout = false;
    _double = false;
    _homerun = false;
    _bunt = false;
    _bbhbp = false;
    //return null;
  }

  void _pushTransitionPage() {
    if (_scoreType != null) {
      GlobalTimer().recordEndTime();
      ScoringHandler().addPlay(_scoreType);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TransitionNextAB(),
        ),
      );
    }
  }

  void _logScoringHandler() {
    log(ScoringHandler().toString());
  }

  void logInningMap() {
    //ScoringHandler().getInningMap();
    //ScoringHandler().preparePostEvent();
    //ScoringHandler().preparePostClip();
  }

  //List<Player> players = LineupHandler().getStartingHitters();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LevelAppBarDrawerless(),
      body: new Stack(children: <Widget>[
        new Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
                fit: BoxFit.fill,
                image: new AssetImage('images/background.png')),
          ),
        ),

        //your code here
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 25.0),
                      child: Container(
                        width: 340,
                        height: 550,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: LevelColor.withOpacity(0.85),
                        ),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    ScoringHandler().getInningStr(),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        ScoringHandler().getGoToString(),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      IconButton(
                                        color: Colors.white,
                                        icon: Icon(Icons.arrow_forward),
                                        tooltip: 'Back',
                                        onPressed: () {
                                          ScoringHandler().switchSides();
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EventSummary()));
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border(
                                            bottom:
                                                BorderSide(color: Colors.white),
                                            top:
                                                BorderSide(color: Colors.white),
                                            left:
                                                BorderSide(color: Colors.white),
                                            right: BorderSide(
                                                color: Colors.white))),
                                    child: Container(
                                        alignment: Alignment.center,
                                        height: 40,
                                        width: 220,
                                        child: new DropdownButton<Player>(
                                          dropdownColor:
                                              LevelColor.withOpacity(0.9),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                          isDense: true,
                                          hint: new Text(
                                            "Select Player",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          value: selectedPlayer,
                                          onChanged: (Player value) {
                                            setState(() {
                                              if (ScoringHandler().hitting()) {
                                                LineupHandler()
                                                    .substituteHitter(
                                                        selectedPlayer, value);
                                              } else {
                                                LineupHandler()
                                                    .substitutePitcher(value);
                                              }
                                            });
                                            selectedPlayer = value;
                                          },
                                          items:
                                              _playerList.map((Player player) {
                                            return new DropdownMenuItem<Player>(
                                              value: player,
                                              child: new Text(
                                                player.getFullName(),
                                                textAlign: TextAlign.center,
                                              ),
                                            );
                                          }).toList(),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: new TextButton(
                                      child: new Text("Strikeout"),
                                      onPressed: () => {
                                        setState(
                                            () => _strikeout = !_strikeout),
                                        _scoreType = null,
                                        if (_strikeout)
                                          {
                                            scoreType = "Strikeout",
                                            _scoreType = ScoreType.strikeout,
                                            _flyout = false,
                                            _single = false,
                                            _triple = false,
                                            _error = false,
                                            _bbhbp = false,
                                            _groundout = false,
                                            _double = false,
                                            _homerun = false,
                                            _bunt = false
                                          }
                                      },
                                      style: TextButton.styleFrom(
                                        minimumSize: const Size(100, 40),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          side: BorderSide(color: Colors.white),
                                        ),
                                        backgroundColor: _strikeout
                                            ? Colors.white
                                            : LevelColor.withOpacity(0.0),
                                        primary: _strikeout
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    )),
                                Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: new TextButton(
                                      child: new Text("BB/HBP"),
                                      onPressed: () => {
                                        setState(() => _bbhbp = !_bbhbp),
                                        _scoreType = null,
                                        if (_bbhbp)
                                          {
                                            scoreType = "BB/HBP",
                                            _scoreType = ScoreType.bbhbp,
                                            _strikeout = false,
                                            _flyout = false,
                                            _single = false,
                                            _triple = false,
                                            _error = false,
                                            _groundout = false,
                                            _double = false,
                                            _homerun = false,
                                            _bunt = false
                                          }
                                      },
                                      style: TextButton.styleFrom(
                                        minimumSize: const Size(100, 40),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          side: BorderSide(color: Colors.white),
                                        ),
                                        backgroundColor: _bbhbp
                                            ? Colors.white
                                            : LevelColor.withOpacity(0.0),
                                        primary: _bbhbp
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    )),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: new TextButton(
                                      child: new Text("Flyout"),
                                      onPressed: () => {
                                        setState(() => _flyout = !_flyout),
                                        _scoreType = null,
                                        if (_flyout)
                                          {
                                            scoreType = "Flyout",
                                            _scoreType = ScoreType.flyout,
                                            _strikeout = false,
                                            _single = false,
                                            _triple = false,
                                            _error = false,
                                            _bbhbp = false,
                                            _groundout = false,
                                            _double = false,
                                            _homerun = false,
                                            _bunt = false
                                          }
                                      },
                                      style: TextButton.styleFrom(
                                        minimumSize: const Size(100, 40),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          side: BorderSide(color: Colors.white),
                                        ),
                                        backgroundColor: _flyout
                                            ? Colors.white
                                            : LevelColor.withOpacity(0.0),
                                        primary: _flyout
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    )),
                                Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: new TextButton(
                                      child: new Text("Groundout"),
                                      onPressed: () => {
                                        setState(
                                            () => _groundout = !_groundout),
                                        _scoreType = null,
                                        if (_groundout)
                                          {
                                            scoreType = "Groundout",
                                            _scoreType = ScoreType.groundout,
                                            _strikeout = false,
                                            _flyout = false,
                                            _single = false,
                                            _triple = false,
                                            _error = false,
                                            _bbhbp = false,
                                            _double = false,
                                            _homerun = false,
                                            _bunt = false
                                          }
                                      },
                                      style: TextButton.styleFrom(
                                        minimumSize: const Size(100, 40),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          side: BorderSide(color: Colors.white),
                                        ),
                                        backgroundColor: _groundout
                                            ? Colors.white
                                            : LevelColor.withOpacity(0.0),
                                        primary: _groundout
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    )),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: new TextButton(
                                      child: new Text("Single"),
                                      onPressed: () => {
                                        setState(() => _single = !_single),
                                        _scoreType = null,
                                        if (_single)
                                          {
                                            scoreType = "Single",
                                            _scoreType = ScoreType.single,
                                            _strikeout = false,
                                            _flyout = false,
                                            _triple = false,
                                            _error = false,
                                            _bbhbp = false,
                                            _groundout = false,
                                            _double = false,
                                            _homerun = false,
                                            _bunt = false
                                          }
                                      },
                                      style: TextButton.styleFrom(
                                        minimumSize: const Size(100, 40),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          side: BorderSide(color: Colors.white),
                                        ),
                                        backgroundColor: _single
                                            ? Colors.white
                                            : LevelColor.withOpacity(0.0),
                                        primary: _single
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    )),
                                Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: new TextButton(
                                      child: new Text("Double"),
                                      onPressed: () => {
                                        setState(() => _double = !_double),
                                        _scoreType = null,
                                        if (_double)
                                          {
                                            scoreType = "Double",
                                            _scoreType = ScoreType.double,
                                            _strikeout = false,
                                            _flyout = false,
                                            _single = false,
                                            _triple = false,
                                            _error = false,
                                            _bbhbp = false,
                                            _groundout = false,
                                            _homerun = false,
                                            _bunt = false
                                          }
                                      },
                                      style: TextButton.styleFrom(
                                        minimumSize: const Size(100, 40),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          side: BorderSide(color: Colors.white),
                                        ),
                                        backgroundColor: _double
                                            ? Colors.white
                                            : LevelColor.withOpacity(0.0),
                                        primary: _double
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    )),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: new TextButton(
                                      child: new Text("Triple"),
                                      onPressed: () => {
                                        setState(() => _triple = !_triple),
                                        _scoreType = null,
                                        if (_triple)
                                          {
                                            scoreType = "Triple",
                                            _scoreType = ScoreType.triple,
                                            _strikeout = false,
                                            _flyout = false,
                                            _single = false,
                                            _error = false,
                                            _bbhbp = false,
                                            _groundout = false,
                                            _double = false,
                                            _homerun = false,
                                            _bunt = false
                                          }
                                      },
                                      style: TextButton.styleFrom(
                                        minimumSize: const Size(100, 40),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          side: BorderSide(color: Colors.white),
                                        ),
                                        backgroundColor: _triple
                                            ? Colors.white
                                            : LevelColor.withOpacity(0.0),
                                        primary: _triple
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    )),
                                Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: new TextButton(
                                      child: new Text("Homerun"),
                                      onPressed: () => {
                                        setState(() => _homerun = !_homerun),
                                        _scoreType = null,
                                        if (_homerun)
                                          {
                                            scoreType = "Homerun",
                                            _scoreType = ScoreType.homerun,
                                            _strikeout = false,
                                            _flyout = false,
                                            _single = false,
                                            _triple = false,
                                            _error = false,
                                            _bbhbp = false,
                                            _groundout = false,
                                            _double = false,
                                            _bunt = false
                                          }
                                      },
                                      style: TextButton.styleFrom(
                                        minimumSize: const Size(100, 40),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          side: BorderSide(color: Colors.white),
                                        ),
                                        backgroundColor: _homerun
                                            ? Colors.white
                                            : LevelColor.withOpacity(0.0),
                                        primary: _homerun
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    )),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: new TextButton(
                                      child: new Text("Error"),
                                      onPressed: () => {
                                        setState(() => _error = !_error),
                                        _scoreType = null,
                                        if (_error)
                                          {
                                            scoreType = "Error",
                                            _scoreType = ScoreType.error,
                                            _strikeout = false,
                                            _flyout = false,
                                            _single = false,
                                            _triple = false,
                                            _bbhbp = false,
                                            _groundout = false,
                                            _double = false,
                                            _homerun = false,
                                            _bunt = false
                                          }
                                      },
                                      style: TextButton.styleFrom(
                                        minimumSize: const Size(100, 40),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          side: BorderSide(color: Colors.white),
                                        ),
                                        backgroundColor: _error
                                            ? Colors.white
                                            : LevelColor.withOpacity(0.0),
                                        primary: _error
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    )),
                                Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: new TextButton(
                                      child: new Text("Bunt"),
                                      onPressed: () => {
                                        setState(() => _bunt = !_bunt),
                                        _scoreType = null,
                                        if (_bunt)
                                          {
                                            scoreType = "Bunt",
                                            _scoreType = ScoreType.bunt,
                                            _strikeout = false,
                                            _flyout = false,
                                            _single = false,
                                            _triple = false,
                                            _error = false,
                                            _bbhbp = false,
                                            _groundout = false,
                                            _double = false,
                                            _homerun = false,
                                          }
                                      },
                                      style: TextButton.styleFrom(
                                        minimumSize: const Size(100, 40),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          side: BorderSide(color: Colors.white),
                                        ),
                                        backgroundColor: _bunt
                                            ? Colors.white
                                            : LevelColor.withOpacity(0.0),
                                        primary:
                                            _bunt ? Colors.black : Colors.white,
                                      ),
                                    )),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: new TextButton(
                                      child: new Text("Score"),
                                      onPressed: () => {
                                        //print(GlobalTimer().getTimerStr()),
                                        // print(playerName),
                                        //   inning += 1,
                                        //
                                        // Push next page here
                                        log(LineupHandler()
                                            .getTempRoster()
                                            .toString()),
                                        _pushTransitionPage(),
                                        setState(() => resetButtons()),
                                      },
                                      style: TextButton.styleFrom(
                                        minimumSize: const Size(100, 40),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          side: BorderSide(color: Colors.white),
                                        ),
                                        backgroundColor:
                                            LevelColor.withOpacity(0.0),
                                        primary: Colors.white,
                                      ),
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
            BottomBar(
              rightIcon:
                  RightIcon.endGame, // Select which right icon should appear
              routeToPush: '/confirmEndGame', // Route must be added above
              verticalScale:
                  0, // An estimated distance from the top of the screen
            ),
          ],
        ),
      ]),
    );
  }
}
