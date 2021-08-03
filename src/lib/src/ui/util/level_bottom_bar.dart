import 'package:flutter/material.dart';

import 'level_theme.dart';
import 'size_config.dart';

// Enumeration for the possible right icons
enum RightIcon { next, endGame, empty }

class BottomBar extends StatefulWidget {
  final RightIcon rightIcon;
  final String routeToPush;
  final List<Function> onRightPressFunctions;
  final List<Function> onLeftPressFunctions;
  final List<bool> conditions;
  bool passConditions = false;
  final int verticalScale;

  /// Creates a bottom navigation bar with [verticalScale] spacing
  /// and includes a [rightIcon] that navigates to [routeToPush].
  BottomBar({
    @required this.rightIcon,
    @required this.routeToPush,
    @required this.verticalScale,
    this.onRightPressFunctions,
    this.onLeftPressFunctions,
    this.conditions,
  }) : assert(verticalScale != null && verticalScale >= 0); // Throw error

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  final String nextLabel = 'Next';
  final String endGameLabel = 'End Game';
  final String emptyLabel = '';

  /// Returns a text label of the RightIcon type.
  String getRightIconLabel() {
    String rightIconString;
    switch (widget.rightIcon) {
      case RightIcon.next:
        rightIconString = nextLabel;
        break;
      case RightIcon.endGame:
        rightIconString = endGameLabel;
        break;
      case RightIcon.empty:
        rightIconString = emptyLabel;
        break;
      default:
        print('RightIcon has defaulted to empty...check bottom_bar.dart');
        rightIconString = emptyLabel;
        break;
    }
    return rightIconString;
  }

  bool checkPassConditions() {
    setState(() {
      if (widget.conditions == null) {
        widget.passConditions = true;
        return widget.passConditions;
      }
      if (widget.conditions.every((element) => element)) {
        widget.passConditions = true;
      } else {
        widget.passConditions = false;
      }
    });
    return widget.passConditions;
  }

  /// Creates a widget containing the right icon and route.
  Container _createRightIcon(BuildContext context) {
    if (widget.rightIcon != RightIcon.empty) {
      return Container(
        child: FlatButton(
          child: Text(
            getRightIconLabel(),
            style: TextStyle(
              color: LevelTheme.levelDarkPurple,
              fontSize: 18,
            ),
          ),
          onPressed: () {
            if (widget.onRightPressFunctions != null &&
                widget.onRightPressFunctions.isNotEmpty) {
              widget.onRightPressFunctions.forEach((function) => function());
            }
            checkPassConditions();
            //print('passConditions: ${widget.passConditions}');
            if (widget.passConditions) {
              Navigator.pushNamed(context, widget.routeToPush);
            }
          },
        ),
      );
    } else {
      return Container(
        child: FlatButton(
          child: Text(
            getRightIconLabel(),
            style: TextStyle(
              color: LevelTheme.levelDarkPurple,
              fontSize: 18,
            ),
          ),
          onPressed: null, // Empty right icon
        ),
      );
    }
  }

  Container _createLeftIcon(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 8),
      child: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: LevelTheme.levelDarkPurple,
        ),
        onPressed: () {
          if (widget.onLeftPressFunctions != null &&
              widget.onLeftPressFunctions.isNotEmpty) {
            widget.onLeftPressFunctions.forEach((function) => function());
          }
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      height: 50,
      margin: EdgeInsets.only(
          top: SizeConfig.blockSizeVertical * widget.verticalScale),
      decoration: BoxDecoration(
        color: LevelTheme.levelWhite,
      ),
      child: Column(
        children: [
          Divider(
            color: LevelTheme.levelDarkPurple,
            height: 1, // 2
            thickness: 1, // 1
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _createLeftIcon(context),
              _createRightIcon(context),
            ],
          ),
        ],
      ),
    );
  }
}
