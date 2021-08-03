import 'package:flutter/material.dart';
import 'package:project/handler_exporter.dart';
import 'package:project/src/ui/util/global_timer.dart';
import 'common_util.dart';
import 'start_first_ab.dart';

class Status extends StatefulWidget {
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<Status> {
  // scroll bar
  final ScrollController _scrollController = ScrollController();
  //purple
  Color awayTextColor = LevelTheme.levelDarkPurple; //Colors.deepPurple[900];
  //white
  Color homeTextColor = Colors.white, awayColor = Colors.white;
  //no color
  Color homeColor = Colors.white.withOpacity(0);
  bool _isHome = false;
  //text
  final String eventName = LineupHandler().eventName;

  final List<Player> _playerList = LineupHandler().getStartingHitters();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: LevelAppBarDrawerless(),
        body: new Stack(children: <Widget>[
          //diamond background picture
          new Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                  fit: BoxFit.fill,
                  image: new AssetImage('images/background.png')),
            ),
          ),
          Column(children: <Widget>[
            Padding(padding: EdgeInsets.all(10.0)),
            Padding(padding: EdgeInsets.all(5.0)),

            // purple box widgets
            Center(
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.8,
                  //width: 350,
                  padding: EdgeInsets.all(30.0),
                  decoration: BoxDecoration(
                      color: LevelTheme.levelLightPurple.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(12.0)),
                  child: Column(
                    children: <Widget>[
                      // event name
                      Text(
                        eventName,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 23,
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(padding: EdgeInsets.all(4.0)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          // customizing the outline button
                          Expanded(
                              child: DecoratedBox(
                            decoration: BoxDecoration(
                                color: homeColor,
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Theme(
                                data: Theme.of(context).copyWith(
                                    buttonTheme: ButtonTheme.of(context)
                                        .copyWith(
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap)),
                                child: OutlineButton(
                                  // button color change on click
                                  onPressed: () {
                                    setState(() {
                                      if (homeColor ==
                                          Colors.white.withOpacity(0)) {
                                        // home button transform
                                        homeColor = Colors.white;
                                        homeTextColor =
                                            LevelTheme.levelDarkPurple;

                                        // away button transform
                                        awayColor = Colors.white.withOpacity(0);
                                        awayTextColor = Colors.white;

                                        // set boolean isHome
                                        _isHome = true;
                                      }
                                    });
                                  },

                                  // default setting of home button
                                  child: Text('Home',
                                      style: TextStyle(fontSize: 14)),
                                  textColor: homeTextColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                )),
                          )),
                          Padding(padding: EdgeInsets.all(5.0)),

                          // customizing the outline button
                          Expanded(
                              child: DecoratedBox(
                            decoration: BoxDecoration(
                                color: awayColor,
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Theme(
                                data: Theme.of(context).copyWith(
                                    buttonTheme: ButtonTheme.of(context)
                                        .copyWith(
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap)),
                                child: OutlineButton(
                                  // button color change on click
                                  onPressed: () {
                                    setState(() {
                                      if (awayColor ==
                                          Colors.white.withOpacity(0)) {
                                        // away button
                                        awayColor = Colors.white;
                                        awayTextColor =
                                            LevelTheme.levelDarkPurple;

                                        // home button
                                        homeColor = Colors.white.withOpacity(0);
                                        homeTextColor = Colors.white;

                                        // set boolean isHome
                                        _isHome = false;
                                      }
                                    });
                                  },

                                  // default setting of away button
                                  child: Text('Away',
                                      style: TextStyle(fontSize: 14)),
                                  textColor: awayTextColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                )),
                          ))
                        ],
                      ),
                      // player listing
                      // need more clarification of what "Display info from objects" means
                      listTitle('Pitching'),
                      nameStyle(
                          LineupHandler().getCurrentPitcher().getFullName()),
                      listTitle('Hitting'),
                      // scrollable list
                      Expanded(
                          flex: 6,
                          child: Container(
                              height: 310,
                              child: Scrollbar(
                                  isAlwaysShown: true,
                                  controller: _scrollController,
                                  child: ListView.builder(
                                    controller: _scrollController,
                                    scrollDirection: Axis.vertical,
                                    physics: BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: _playerList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return nameStyle(
                                          '${_playerList.elementAt(index).getFullName()}');
                                    },
                                  )))),

                      // navigate to 1st AB ui
                      Expanded(
                          flex: 2,
                          child: Padding(
                              padding: EdgeInsets.all(10),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_isHome) {
                                    ScoringHandler().init(HomeAwayStatus.home);
                                  } else {
                                    ScoringHandler().init(HomeAwayStatus.away);
                                  }
                                  GlobalTimer().recordStartTime();
                                  print(ScoringHandler());
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Start1stAB()));
                                },
                                child: Text(
                                  'Start 1st AB',
                                  style: TextStyle(
                                      color: LevelTheme.levelDarkPurple),
                                ),
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    textStyle: TextStyle(fontSize: 17)),
                              ))),

                      // instruction
                      Expanded(
                          child: Text('Press when the batter steps in the box',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15)))
                    ],
                  )),
            ),
            /*divider??
              Row(children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back_ios,
                      size: 33, color: LevelTheme.levelLightPruple),
                  onPressed: () {
                    // response to press
                  },
                ),
              ])
              */
          ]),
        ]));
  }

// specific style for Pitching title and Hitting title
  Widget listTitle(String name) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 9),
        child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              name,
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            )));
  }

// specific style for listing player names
  Widget nameStyle(String given) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
        child: Align(
          alignment: Alignment.centerLeft,
          child:
              Text(given, style: TextStyle(color: Colors.white, fontSize: 17)),
        ));
  }
}
