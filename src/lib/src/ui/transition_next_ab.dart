import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'common_util.dart';
import 'package:project/handler_exporter.dart';
import 'package:project/src/ui/util/global_timer.dart';
import 'package:project/src/ui/start_first_ab.dart';
import 'event_summary.dart';

class TransitionNextAB extends StatefulWidget {
  @override
  _TransitionNextABState createState() => _TransitionNextABState();
}

class _TransitionNextABState extends State<TransitionNextAB> {
  @override
  Widget build(BuildContext context) {
    var data = ScoringHandler().getHitterPitcherString();
    return Scaffold(
      appBar: LevelAppBarDrawerless(),
      body: new Stack(children: <Widget>[
        new Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
                image: new AssetImage('images/background.png')),
          ),
        ),

        //your code here
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 100.0),
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: LevelColor.withOpacity(0.85),
                    ),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  'Next Batter',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 24),
                                ))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                data,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(20),
                              child: Align(
                                alignment: FractionalOffset.center,
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 10.0),
                                  child: new MaterialButton(
                                    height: 50.0,
                                    minWidth: 170.0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(12)),
                                    color: Colors.white,
                                    textColor: Colors.black,
                                    child: new Text("Start Next AB"),
                                    onPressed: () => {
                                      GlobalTimer().recordStartTime(),
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Start1stAB()))
                                    },
                                    splashColor: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '           ${ScoringHandler().getGoToString()}',
                              style: TextStyle(color: Colors.white),
                            ),
                            IconButton(
                              color: Colors.white,
                              icon: Icon(Icons.arrow_forward),
                              tooltip: 'Back',
                              onPressed: () {
                                setState(() {});
                                ScoringHandler().switchSides();
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EventSummary()));
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
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
