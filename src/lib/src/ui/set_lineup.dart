import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'common_util.dart';
import 'package:project/handler_exporter.dart';

class SetStartingLineup extends StatefulWidget {
  @override
  _SetStartingLineupState createState() => _SetStartingLineupState();
}

class _SetStartingLineupState extends State<SetStartingLineup> {
  // Fixed text labels
  final String _nameEventLabel = 'Name Your Event';
  final String _eventHintText = 'Event Name';
  final String _setLineupLabel = 'Set Your Lineup';
  final String _pitcherLabel = 'Pitcher';
  final String _hittersLabel = 'Hitters';
  final String _addPlayerLabel = '+ Add Player';
  final List<String> _dropdownHintText = [
    'Starting Pitcher',
    'First Hitter',
    'Second Hitter',
    'Third Hitter',
    'Fourth Hitter',
    'Fifth Hitter',
    'Sixth Hitter',
    'Seventh Hitter',
    'Eigth Hitter',
    'Ninth Hitter',
  ];

  String _errorMessage = '';

  // Controllers
  final _eventTextController = TextEditingController(); // dispose() after use

  // Holds the dropdown value when a player is selected
  List<String> _dropdownValue = List<String>.filled(10, null);

  // A copy of the player roster, used to populate the dropdown menu
  final List<Player> _playerList = LineupHandler().getRoster();

  @override
  void initState() {
    super.initState();
    _eventTextController.addListener(() {
      final String text = _eventTextController.text.toString();
      _eventTextController.value = _eventTextController.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
  }

  @override
  void dispose() {
    _eventTextController.clear();
    clearLineup();
    _eventTextController.dispose();
    super.dispose();
  }

  /// Creates the TextField for naming the event.
  TextField _eventField() {
    return TextField(
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        fillColor: LevelTheme.levelWhite,
        border: OutlineInputBorder(),
        hintText: _eventHintText,
      ),
      inputFormatters: [
        FilteringTextInputFormatter(RegExp('[a-zA-Z0-9 ]'), allow: true),
        LengthLimitingTextInputFormatter(26), // add [a-zA-Z] filter
      ],
      controller: _eventTextController,
      onChanged: (text) {
        _setErrorLabel();
      },
    );
  }

  /// Builds the DropdownButton for the pitcher
  Container _buildPitcherDropdown() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _playerDropdownButton(0, _dropdownHintText[0]),
        ],
      ),
    );
  }

  /// Builds the DropdownButtons for the nine hitters.
  Container _buildHittersDropdown() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: LevelTheme.levelSmallHeadlineText(_hittersLabel),
          ),
          _playerDropdownButton(1, _dropdownHintText[1]),
          _playerDropdownButton(2, _dropdownHintText[2]),
          _playerDropdownButton(3, _dropdownHintText[3]),
          _playerDropdownButton(4, _dropdownHintText[4]),
          _playerDropdownButton(5, _dropdownHintText[5]),
          _playerDropdownButton(6, _dropdownHintText[6]),
          _playerDropdownButton(7, _dropdownHintText[7]),
          _playerDropdownButton(8, _dropdownHintText[8]),
          _playerDropdownButton(9, _dropdownHintText[9]),
          //_buildAddPlayerButton(),
          _buildErrorMessage(),
        ],
      ),
    );
  }

  /// Populates the DropdownMenuItems and handles the player selection.
  /// [index] is the String element which holds the selected value.
  Container _playerDropdownButton(int index, String hintText) {
    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.all(Radius.circular(3)),
        ),
      ),
      height: 30, // 34 fits iPhone 7+
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true, // Pads text
          child: DropdownButton<String>(
            value: _dropdownValue[index],
            icon: Icon(Icons.arrow_drop_down),
            isExpanded: true,
            iconSize: 32,
            elevation: 16,
            hint: Text(hintText),
            underline: Container(
              height: 2,
            ),
            onChanged: (String newPlayer) {
              setState(() {
                // set the dropdownValue to the new value
                // remove the newValue
                // add the old value
                _dropdownValue[index] = newPlayer;
              });
            },
            items: _playerList.map((player) {
              return DropdownMenuItem(
                child: Container(
                  child: Text(
                    player.getFullName(),
                  ),
                ),
                value: player.id,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  /// Builds the '+ Add Player' button.
  Container _buildAddPlayerButton() {
    return Container(
      child: TextButton(
        onPressed: () {
          _displayAddPlayerDialog(context);
        },
        child: LevelTheme.levelSmallHeadlineText(_addPlayerLabel),
      ),
    );
  }

  /// Displays the Dialog for manually adding a Player to the player list.
  Future<void> _displayAddPlayerDialog(BuildContext context) async {
    String newPlayer;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add Player'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  newPlayer = value;
                });
              },
              //controller: _textFieldController,
              decoration: InputDecoration(hintText: 'Full Name'),
            ),
            actions: [
              FlatButton(
                color: Colors.red,
                textColor: Colors.white,
                child: Text('Cancel'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    //_playerList.add();
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  Container _buildErrorMessage() {
    _setErrorLabel();
    return Container(
      alignment: Alignment.center,
      child: Text(
        _errorMessage,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.red,
        ),
      ),
    );
  }

  void _setErrorLabel() {
    setState(() {
      if (!_allPositionsFilled()) {
        _errorMessage = 'Please fill all positions before continuing.';
      } else if (_allPositionsFilled() && !_noDuplicateHitters()) {
        _errorMessage = 'There are duplicate hitters in the starting lineup.';
      } /*else if (_allPositionsFilled() && !_pitcherInHitters()) {
        _errorMessage =
            'The starting pitcher must be one of the starting hitters.';
      }*/
      else if (!_eventNameFilled()) {
        _errorMessage = 'The event name is empty.';
      } else {
        _errorMessage = '';
      }
    });
  }

  bool _validLineup() {
    return (_allPositionsFilled() &&
        _noDuplicateHitters() &&
        //_pitcherInHitters() &&
        _eventNameFilled());
  }

  bool _allPositionsFilled() {
    for (int i = 0; i < _dropdownValue.length; i++) {
      if (_dropdownValue[i] == null) {
        //print('Not all positions are filled');
        return false;
      }
    }
    //print('All positions are filled');
    return true;
  }

  bool _noDuplicateHitters() {
    List<String> hitters = _dropdownValue.sublist(1);
    // hitters.forEach((element) {
    //   print(element);
    // });
    Set<String> playerSet = hitters.toSet();
    // playerSet.forEach((element) {
    //   print('Set: $element');
    // });
    //print('Set length: ${playerSet.length} vs List length: ${hitters.length}');
    if (playerSet.length < hitters.length) {
      //print('There is a duplicate player in the hitting lineup.');
      return false;
    } else {
      //print('No duplicates found');
    }
    return true;
  }

  bool _pitcherInHitters() {
    List<String> hitters = _dropdownValue.sublist(1);
    if (!hitters.contains(_dropdownValue[0])) {
      //print('Pitcher is not in hitter lineup');
      return false;
    }
    //print('Pitcher is in the hitting lineup.');
    return true;
  }

  bool _eventNameFilled() {
    String input = _eventTextController.text;
    //print('Event Name is not empty? ${input.isNotEmpty}');
    return input.isNotEmpty;
  }

  /// Saves the name of the event.
  void _saveEventName() {
    LineupHandler().eventName = _eventTextController.text;
  }

  /// Sets the starting pitcher and hitters for the game.
  void _saveLineup() {
    if (_validLineup()) {
      LineupHandler handler = LineupHandler();
      _saveEventName();
      handler.setStartingPitcher(handler.getPlayerById(_dropdownValue[0]));
      for (int i = 1; i < _dropdownValue.length; i++) {
        handler.addStartingHitter(handler.getPlayerById(_dropdownValue[i]));
      }
      handler.setStartingHitter(handler.getStartingHitters().first);
      handler.sortRoster();
      print(handler);
    }
  }

  /// Called when pressing the back button.
  void clearLineup() {
    LineupHandler().clearStartingLineup();
    _dropdownValue.forEach((element) {
      element = null;
    });

    //print(LineupHandler());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LevelTheme.levelWhite,
      appBar: LevelAppBarDrawerless(),
      resizeToAvoidBottomInset: false, // Stop overflow when keyboard is open
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.only(left: 30, right: 30),
              //color: Colors.red,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  LevelTheme.levelHeadlineOneText(_nameEventLabel),
                  _eventField(),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.only(left: 30, right: 30),
              //color: Colors.purple,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  LevelTheme.levelHeadlineOneText(_setLineupLabel),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: LevelTheme.levelSmallHeadlineText(_pitcherLabel),
                  ),
                  _buildPitcherDropdown(),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.only(left: 30, right: 30),
              //color: Colors.green,
              child: _buildHittersDropdown(),
            ),
          ),
          Expanded(
            child: BottomBar(
              rightIcon: RightIcon.next,
              routeToPush: '/alignmentInstructions',
              verticalScale: 0,
              onRightPressFunctions: [_saveLineup],
              onLeftPressFunctions: [clearLineup],
              conditions: [
                _noDuplicateHitters(),
                _allPositionsFilled(),
                //_pitcherInHitters(),
                _eventNameFilled(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
