import 'package:flutter/material.dart';
import 'package:project/handler_exporter.dart';
import 'package:project/src/api/upload_api.dart';
import 'common_util.dart';
import 'main_menu.dart';

class UploadGames extends StatefulWidget {
  @override
  _UploadGamesState createState() => _UploadGamesState();
}

class _UploadGamesState extends State<UploadGames> {
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

            //Upload Game
            Container(
              margin: EdgeInsets.all(5.0),
              padding: EdgeInsets.only(
                  left: 5.0, right: 5.0, top: 10.0, bottom: 10.0),
              alignment: Alignment.center,
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: LevelTheme.levelLightPurple.withOpacity(0.98), //opacity
                border: Border.all(),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Container(
                      width: 200,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: LevelTheme.levelWhite,
                        border: Border.all(
                          color: LevelTheme.levelDarkPurple,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      child: Text(
                        LineupHandler().eventName,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),

                  //Upload Now Button
                  Container(
                    width: 200.0,
                    height: 50.0,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: BorderSide(color: Colors.white),
                      ),
                      color: LevelTheme.levelDarkPurple,
                      onPressed: () async {
                        final postEventStatus =
                            await ScoringHandler().preparePostEvent(true);
                        final postClipStatus = await ScoringHandler()
                            .preparePostClip(true); // Update
                        if (postEventStatus != null && postClipStatus != null) {
                          // final create = await ScoringHandler()
                          //     .preparePostClip();
                          if (postEventStatus == 200 && postClipStatus == 200) {
                            ScoringHandler().clearAll();
                            LineupHandler().clearAll();
                            GlobalTimer().resetTimer();
                            // if createClip failed, error prompt
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Successfully Uploaded',
                                      style: TextStyle(
                                          color: LevelTheme.levelDarkPurple),
                                    ),
                                    content: Text(
                                        'The game has been uploaded. Returning to Main Menu.'),
                                    actions: <Widget>[
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MainMenu()));
                                          },
                                          child: Text('Close'))
                                    ],
                                  );
                                });
                          } else {
                            //if createEvent failed, error prompt
                            print('\n\nfailed create event\n\n');
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Error Warning',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    content: Text('Error in creating Event'),
                                    actions: <Widget>[
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Close'))
                                    ],
                                  );
                                });
                          }
                        } else {
                          //if createEvent failed, error prompt
                          print('\n\nfailed create event\n\n');
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    'Error Warning',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  content: Text('Error in creating Event'),
                                  actions: <Widget>[
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Close'))
                                  ],
                                );
                              });
                        }
                      },
                      child: Text(
                        "Upload Now",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),

                  //Upload Later Button
                  Container(
                    width: 200.0,
                    height: 50.0,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: BorderSide(color: Colors.white),
                      ),
                      color: LevelTheme.levelDarkPurple,
                      onPressed: () async {
                        final postEventStatus =
                            await ScoringHandler().preparePostEvent(false);
                        final postClipStatus =
                            await ScoringHandler().preparePostClip(false);
                        ScoringHandler().clearAll();
                        LineupHandler().clearAll();
                        GlobalTimer().resetTimer(); // Update
                        FileUtil.readPostClipFile();
                        FileUtil.readPostEventFile();
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  'Game has been saved',
                                  style: TextStyle(
                                      color: LevelTheme.levelDarkPurple),
                                ),
                                content: Text(
                                    'Scorekeeping for the game has been saved. Returning to the Main Menu.'),
                                actions: <Widget>[
                                  TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        MainMenu()));
                                      },
                                      child: Text('Close'))
                                ],
                              );
                            });
                      },
                      child: Text(
                        "Upload Later",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
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
