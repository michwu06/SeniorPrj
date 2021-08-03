import 'package:flutter/material.dart';

import 'common_util.dart';

class LoadTeam extends StatefulWidget {
  @override
  _LoadTeamState createState() => _LoadTeamState();
}

class _LoadTeamState extends State<LoadTeam> {
  final String _loadTeamLabel = 'Load Team Roster';
  final String _hintLabel = 'Select a Team'; // Possibly unneeded
  String _dropDownLabel;
  final List<String> teamList = [
    'Team One',
    'Team Two',
    'Team Three',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 12),
            child: Text(
              _loadTeamLabel,
              style: TextStyle(
                fontSize: 26,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(6),
            margin: EdgeInsets.only(top: 60),
            height: 40,
            width: 320,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1.0, style: BorderStyle.solid),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _dropDownLabel,
                hint: Text(_hintLabel),
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 24,
                isExpanded: true,
                elevation: 16,
                underline: Container(
                  height: 2,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    _dropDownLabel = newValue;
                  });
                },
                items: teamList.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
          Spacer(),
          Container(
            child: BottomBar(
              rightIcon: RightIcon.next, routeToPush: null, verticalScale: 0,
            ),
          ),
        ],
      ),
    );
  }
}
