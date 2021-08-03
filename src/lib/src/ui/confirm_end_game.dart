import 'package:flutter/material.dart';
import 'package:project/handler_exporter.dart';
import 'common_util.dart';
import 'upload_game.dart';

class ConfirmEndGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: LevelAppBarDrawerless(),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  new Text("End of Game",
                      style: TextStyle(color: Colors.black, fontSize: 25)),
                ],
              ),
            ),

            //Confrim End Game Widget
            Container(
              margin: EdgeInsets.all(5.0),
              padding: EdgeInsets.only(
                  left: 5.0, right: 5.0, top: 10.0, bottom: 10.0),
              alignment: Alignment.bottomRight,
              width: 300.0,
              height: 300.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: LevelTheme.levelLightPurple
                    .withOpacity(0.98), //transparency
                border: Border.all(),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text("Are you sure you want to end the game?",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 18.0)),
                  ),

                  //Yes Button
                  Container(
                    width: 200.0,
                    height: 50.0,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: BorderSide(color: Colors.white),
                      ),
                      color: LevelTheme.levelDarkPurple,
                      onPressed: () {
                        GlobalTimer().stopTimer();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    UploadGames()));
                      },
                      child: Text("Yes",
                          style:
                              TextStyle(color: Colors.white, fontSize: 18.0)),
                    ),
                  ),

                  //No Button
                  Container(
                    width: 200.0,
                    height: 50.0,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side: BorderSide(color: Colors.white)),
                      color: LevelTheme.levelDarkPurple,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("No",
                          style:
                              TextStyle(color: Colors.white, fontSize: 18.0)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
