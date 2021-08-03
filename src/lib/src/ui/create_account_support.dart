import 'package:flutter/material.dart';

import 'common_util.dart';

final String _titleLabel = 'Account Setup';
final String _levelEmail = 'levelbaseball@gmail.com';
final String _bodyText =
    'Don\'t miss the moment! Contact LEVEL now to setup your account.';

class CreateAccount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //centering the container so that it doesn't fill up the whole page
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
      backgroundColor: LevelTheme.levelLightPurple,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 40, bottom: 20),
              color: Colors.white,
              child: Text(
                _titleLabel,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 40,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 5),
              margin: EdgeInsets.all(28),
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.white)),
              child: Text(
                _levelEmail,
                style: TextStyle(
                  color: LevelTheme.levelWhite,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(top: 10, left: 15, right: 15),
              child: Text(
                _bodyText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: LevelTheme.levelWhite,
                  fontSize: 27,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              height: 100,
              decoration: new BoxDecoration(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
