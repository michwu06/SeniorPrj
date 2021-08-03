import 'dart:convert';

import 'package:project/handler_exporter.dart';

import 'play.dart';

/// Identifies the half of an inning.
enum InningHalf { top, bottom } // Might remove if unneeded

class Inning {
  /// The number or order associated with the inning.
  int inningNumber;

  /// Contains plays for the top half of an inninng.
  List<Play> _topHalfPlays;

  /// Contains plays for the bottom half of an inning.
  List<Play> _bottomHalfPlays;

  // Notes:
  // An inning consists of two halves: Top and Bottom
  // Might need a list of participating players in a half-inning.
  // See POST method: Create Event mobile. (Related to above)
  // ScoringHandler creates innings and manages the adding of plays.

  /// Creates an inning with an [inningNumber] containing no plays.
  /// Plays can be processed using an iterator.
  Inning(int inningNumber) {
    this.inningNumber = inningNumber;
    _topHalfPlays = [];
    _bottomHalfPlays = [];
  }

  /// Add a single Play to the top inning.
  void addTopHalfPlay(Play play) {
    _topHalfPlays.add(play);
  }

  /// Returns an iterator to the Plays in the top inning.
  Iterator<Play> getTopHalfIterator() {
    return _topHalfPlays.iterator;
  }

  /// Add a single play to the bottom inning.
  void addBottomHalfPlay(Play play) {
    _bottomHalfPlays.add(play);
  }

  /// Returns an iterator to the Plays in the bottom inning.
  Iterator<Play> getBottomHalfIterator() {
    return _bottomHalfPlays.iterator;
  }

  /// Returns the toStr() method of each stored Play. Invoked in the toStr()
  /// method of Inning to list all recorded Plays.
  String _toStrPlays(List<Play> listPlays) {
    String playStr = '';
    Iterator<Play> playIterator = listPlays.iterator;
    while (playIterator.moveNext()) {
      Play play = playIterator.current;
      playStr += play.toString();
      playStr += '\n';
    }
    return playStr;
  }

  Map<String, dynamic> topInningEventMap() {
    List<String> jsonStr = [];
    _topHalfPlays.forEach((play) {
      String encodedPlay = play.toEventJson().toString();
      jsonStr.add(encodedPlay);
    });
    return {
      json.encode('name'): json.encode('Top $inningNumber'),
      json.encode('players'): jsonStr,
    };
  }

  Map<String, dynamic> topInningClipMap() {
    List<String> jsonStr = [];
    _topHalfPlays.forEach((play) {
      String encodedPlay = play.toClipJson().toString();
      jsonStr.add(encodedPlay);
    });
    return {
      json.encode('name'): json.encode('Top $inningNumber'),
      json.encode('players'): jsonStr,
    };
  }

  Map<String, dynamic> botInningEventMap() {
    List<String> jsonStr = [];
    _bottomHalfPlays.forEach((play) {
      String encodedPlay = play.toEventJson().toString();
      jsonStr.add(encodedPlay);
    });
    return {
      json.encode('name'): json.encode('Bottom $inningNumber'),
      json.encode('players'): jsonStr,
    };
  }

  Map<String, dynamic> botInningClipMap() {
    List<String> jsonStr = [];
    _bottomHalfPlays.forEach((play) {
      String encodedPlay = play.toClipJson().toString();
      jsonStr.add(encodedPlay);
    });
    return {
      json.encode('name'): json.encode('Bottom $inningNumber'),
      json.encode('players'): jsonStr,
    };
  }

  Map<String, dynamic> _topPlaysMap() {}

  /// Returns a description of plays in the Inning
  @override
  String toString() {
    String toStr = 'Inning: $inningNumber\n';
    String topHalfStr = 'Top $inningNumber: \n';
    String bottomHalfStr = 'Bot $inningNumber: \n';
    toStr += topHalfStr;
    toStr += _toStrPlays(_topHalfPlays);
    toStr += bottomHalfStr;
    toStr += _toStrPlays(_bottomHalfPlays);
    return toStr;
  }
}
