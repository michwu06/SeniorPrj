import 'package:flutter/material.dart';

import 'common_util.dart';

class BottomBarContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LevelTheme.levelWhite,
      appBar: LevelAppBar(),
      drawer: LevelDrawer(),
      body: Column(
        children: [
          Expanded(
            flex: 11,
            child: Container(
              color: Colors.white,
              //child: <Your body widgets>
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.blue,
              child: BottomBar(
                rightIcon: RightIcon.next,
                routeToPush: '',
                verticalScale: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
