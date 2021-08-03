import 'package:flutter/material.dart';

import 'common_util.dart';
import 'set_lineup.dart';
import 'manage_team.dart';
import 'saved_games.dart';
import 'contact_support.dart';
import 'login.dart';

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //debugShowCheckedModeBanner: false,
      // theme: ThemeData(
      // primarySwatch: Colors.green,
      //),
      //home: Scaffold(

      appBar: LevelAppBar(),
      drawer: LevelDrawer(),
      body: Center(
          child: Column(children: <Widget>[
        Container(
            width: double.infinity,
            height: 80,
            margin: EdgeInsets.only(left: 40, right: 40, top: 90, bottom: 15),
            child: RaisedButton(
              color: LevelTheme.levelDarkPurple,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => SetStartingLineup()),
                );
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                'Start New Game',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            )),
        Container(
            width: double.infinity,
            height: 50,
            margin: EdgeInsets.only(left: 40, right: 40, top: 15, bottom: 5),
            child: RaisedButton(
              color: LevelTheme.levelDarkPurple,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => ManageTeamWidget()));
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                'My Teams',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )),
        Container(
            width: double.infinity,
            height: 50,
            margin: EdgeInsets.only(left: 40, right: 40, top: 10, bottom: 5),
            child: RaisedButton(
              color: LevelTheme.levelDarkPurple,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => SavedGames()));
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                'My Games',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )),
        Container(
            width: double.infinity,
            height: 50,
            margin: EdgeInsets.only(left: 40, right: 40, top: 10, bottom: 5),
            child: RaisedButton(
              color: LevelTheme.levelDarkPurple,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Support()));
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                'Support',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )),
        Container(
            width: double.infinity,
            height: 50,
            margin: EdgeInsets.only(left: 40, right: 40, top: 18, bottom: 5),
            child: RaisedButton(
              color: Colors.red,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Login()));
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                'Log Out',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )),
      ])),
    );
  }
}
