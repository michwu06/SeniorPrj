import 'package:flutter/material.dart';
import 'package:project/src/api/upload_api.dart';
import 'package:project/ui_exporter.dart';

class SavedGames extends StatefulWidget {
  @override
  _SavedGamesState createState() => _SavedGamesState();
}

class _SavedGamesState extends State<SavedGames> {
  String _eventName = '';
  String _eventDate = '';

  @override
  void initState() {
    super.initState();
  }

  void _setEventName(String name) {
    _eventName = name;
  }

  void _setEventDate(String date) {
    _eventDate = date;
  }

  _SavedGamesState() {
    FileUtil.readEvent().then((value) => setState(() {
          _eventName = value.elementAt(0);
        }));
    FileUtil.readEvent().then((value) => setState(() {
          _eventDate = value.elementAt(1);
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          child: Container(
            color: LevelTheme.levelDarkPurple,
            height: 2.0,
          ),
          preferredSize: Size.fromHeight(2.0),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: LevelTheme.levelDarkPurple,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 11,
            child: Container(
              color: Colors.white,
              //child: <Your body widgets>
              child: Center(
                child: Column(children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          new Text("My Games",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 25)),
                        ]),
                  ),

                  myLayoutWidget(context), //the list of saved games start here
                ]),
              ),
            ),
          )
        ],
      ),
    );
  }

//a pop up message warning if user wants to delete a game
  showWarningDialog(BuildContext context) {
    // set up the buttons
    alignment:
    Alignment.center;
    Widget cancelButton = FlatButton(
      padding: EdgeInsets.only(top: 30),
      child: Text(
        "Delete Game",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      onPressed: () {},
    );

    Widget continueButton = FlatButton(
      padding: EdgeInsets.only(top: 15),
      child: Text(
        "Cancel",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      //title: Text(""),
      // content: Text("Are you sure you want to delete this game?"),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: LevelTheme.levelDarkPurple,

      actions: [
        Center(
          child: Text(
            'Are you sure you want to delete this game?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

//Popup for upload button
  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Uploading...'),
      content: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[LinearProgressIndicator()]),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: Text('Close'),
        )
      ],
    );
  }

//layouts for the center part
  Widget myLayoutWidget(BuildContext context) {
    return Container(
        // margin: EdgeInsets.all(5.0),
        // // padding: EdgeInsets.all(10.0),
        padding: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
        alignment: Alignment.bottomRight,
        // width: 300,
        // height: 80,
        width: double.infinity,
        height: 80,
        margin: EdgeInsets.only(left: 50, right: 50, top: 15, bottom: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: LevelTheme.levelDarkPurple,
          border: Border.all(),
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                //for the title and date
                //alignment: Alignment.centerLeft,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          _eventName,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          _eventDate,
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ]),
              ),
              // Container(
              //   //for the delete button
              //   constraints: BoxConstraints.tightFor(width: 30, height: 30),
              //   child: ElevatedButton(
              //     child: Text('-',
              //         style: TextStyle(color: Colors.white, fontSize: 24),
              //         textAlign: TextAlign.center),
              //     onPressed: () {
              //       showWarningDialog(context);
              //       //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Delete()));
              //     },
              //     style: ElevatedButton.styleFrom(
              //       primary: Colors.red,
              //       shape: CircleBorder(),
              //     ),
              //   ),
              // ),
              Container(
                  //for the upload button
                  //alignment: Alignment.bottomRight,
                  width: 100.0,
                  height: 25.0,
                  child: RaisedButton(
                    color: Colors.green,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            _buildPopupDialog(context),
                      );
                      FileUtil.readPostEventFile()
                          .then((value) => UploadApi().createEvent(value))
                          .then((value) => FileUtil.readPostClipFile()
                              .then((value) => UploadApi().createClip(value))
                              .then((value) => Navigator.pop(context)));
                    },
                    child: Text(
                      "Upload Now",
                      style: TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  )),
            ]));
  }
}
