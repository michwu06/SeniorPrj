import 'package:flutter/material.dart';

import 'ui_exporter.dart';

void main() => runApp(LevelMobileApp());

class LevelMobileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LEVEL Mobile App',
      debugShowCheckedModeBanner: false,
      routes: {
        '/alignmentInstructions': (context) => LevelAlignmentInstructions(),
        '/alignmentProcess': (context) => AlignmentProcess(),
        '/homeAwayStatus': (context) => Status(),
        '/mainMenu': (context) => MainMenu(),
        '/myTeams': (context) => ManageTeamWidget(),
        '/myGames': (context) => SavedGames(),
        '/confirmEndGame': (context) => ConfirmEndGame(),
        '/uploadGames': (context) => UploadGames(),
        '/logOut': (context) => Login(),
      },
      home: Login(),
    );
  }
}
