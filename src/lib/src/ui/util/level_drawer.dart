import 'package:flutter/material.dart';

class LevelDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                image: AssetImage('images/Level_Home_Logo.png'),
                fit: BoxFit.contain,
              ),
            ),
            child: null,
          ),
          ListTile(
              title: Text('Main Menu'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/mainMenu');
              }),
          ListTile(
              title: Text('My Teams'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/myTeams');
              }),
          ListTile(
              title: Text('My Games'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/myGames');
              }),
          ListTile(
              title: Text('Log Out'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/logOut');
              }),
        ],
      ),
    );
  }
}
