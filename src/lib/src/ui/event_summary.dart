import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/handler_exporter.dart';
import 'transition_next_ab.dart';

import 'common_util.dart';

class EventSummary extends StatefulWidget {
  @override
  _EventSummaryState createState() => _EventSummaryState();
}

class _EventSummaryState extends State<EventSummary> {
  @override
  Widget build(BuildContext context) {
    // getting recent plays from scoring handler
    final List<Play> plays = ScoringHandler().getRecentPlays();

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
                    width: 350,
                    height: 500,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: LevelColor.withOpacity(0.85),
                    ),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Text(
                            ScoringHandler().getLastHalfStr(),
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                        ),
                        new Expanded(
                            child: ListView.builder(
                                padding: const EdgeInsets.all(20),
                                itemCount: plays.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    height: 30,
                                    margin:
                                        EdgeInsets.only(left: 20, right: 20),
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${LineupHandler().getPlayerById(plays[index].playerId).getAbbreviatedName()}', // ${plays[index].playerId}
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          '${plays[index].scoreType.toDisplayString()}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  );
                                })),
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
                                    child: new Text(
                                        'Start ${ScoringHandler().getInningStr()}'), // Next inning
                                    onPressed: () => {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  TransitionNextAB()))
                                    },
                                    splashColor: Colors.redAccent,
                                  ),
                                ),
                              ),
                            )
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
