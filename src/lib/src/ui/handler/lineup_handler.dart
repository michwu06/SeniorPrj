import 'dart:async';
import 'dart:collection';
import 'package:http/http.dart' as http;
import 'package:project/handler_exporter.dart';
import 'package:intl/intl.dart';

import 'package:project/src/api/player_api.dart';
import 'player.dart';

const int maxStartingHitters = 9;

// Might need a list of reserve Players in order to perform substitutions.
class LineupHandler {
  static final LineupHandler _lineupHandler = LineupHandler._internal();
  List<Player> _teamRoster = [];
  // Copies _teamRoster but removes hitters as they are assigned.
  // Gets appended to _sortedRoster
  List<Player> _tempRoster = [];
  // Shows hitters in order first followed by any reserve players
  List<Player> _sortedRoster = [];
  List<Player> _startingHitters = [];
  Player _currentPitcher;
  Player _currentHitter;
  //Player _nextHitter;
  String eventName;
  String formattedDate;

  void clearAll() {
    //_teamRoster.clear();
    _tempRoster.clear();
    _tempRoster.addAll(_teamRoster);
    _sortedRoster.clear();
    _startingHitters.clear();
    _currentPitcher = null;
    _currentHitter = null;
    eventName = null;
    formattedDate = null;
  }

  LineupHandler._internal();

  factory LineupHandler() {
    return _lineupHandler;
  }

  //get current date: yyyy/mm/dd
  String getDate() {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    formattedDate = formatter.format(now);
    return formattedDate;
  }

  String getEventDate() {
    var now = new DateTime.now();
    var formatter = new DateFormat('MM-dd-yyyy');
    formattedDate = formatter.format(now);
    return formattedDate;
  }

  /// Loads the team using REST API.
  void loadRoster() {
    Future<List<Player>> teamData = fetchPlayers(http.Client());
    teamData
        .then((value) => _initRoster(value))
        .catchError((error) => print('Error loading roster...'));
  }

  /// Helper function that adds the loaded players into the team roster.
  void _initRoster(List<Player> team) {
    _teamRoster.addAll(team);
    _tempRoster.addAll(team);
    print(_teamRoster);
  }

  /// Returns the next hitter (next at bat).
  Player _getNextHitter() {
    Player nextHitter;
    if (_currentHitter != null && _startingHitters.length > 0) {
      int currentIndex = _startingHitters.indexOf(_currentHitter);
      int nextIndex = -1;
      if (currentIndex == _startingHitters.length - 1) {
        nextIndex = 0;
      } else {
        nextIndex = currentIndex + 1;
      }
      nextHitter = _startingHitters.elementAt(nextIndex);
    }
    return nextHitter;
  }

  void advanceHitter() {
    if (ScoringHandler().getHomeAwayStatus() == HomeAwayStatus.home) {
      if (ScoringHandler().getInningHalf() == InningHalf.bottom) {
        _currentHitter = _getNextHitter();
      }
    } else {
      if (ScoringHandler().getInningHalf() == InningHalf.top) {
        _currentHitter = _getNextHitter();
      }
    }
  }

  List<Player> getRoster() {
    // Need to make sure loadRoster() has completed before other widgets
    // can reference the list of players.
    return _teamRoster;
  }

  List<Player> getTempRoster() {
    return _tempRoster;
  }

  List<Player> getSortedRoster() {
    return _sortedRoster;
  }

  Player getCurrentHitter() {
    return _currentHitter;
  }

  List<Player> getStartingHitters() {
    return _startingHitters;
  }

  void clearStartingLineup() {
    clearPitcher();
    clearHitters();
  }

  void clearPitcher() {
    _currentPitcher = null;
  }

  void clearHitters() {
    _startingHitters.clear();
  }

  /// Set the starting pitcher for the game.
  void setStartingPitcher(Player pitcher) {
    if (_currentPitcher == null && pitcher != null) {
      _currentPitcher = pitcher;
    }
    // Remove the pitcher and append them with the reserves
    if (_startingHitters.contains(pitcher)) {
      _tempRoster.remove(pitcher);
    }
  }

  /// Set the first starting hitter for the game.
  void setStartingHitter(Player hitter) {
    if (_currentHitter == null && hitter != null) {
      _currentHitter = hitter;
    }
  }

  // Must make sure starting pitcher is not listed twice, if they are also
  // listed as one of the starting hitters
  void sortRoster() {
    _sortedRoster.addAll(_startingHitters);
    _sortedRoster.addAll(_tempRoster);
  }

  /// Returns the current pitcher
  Player getCurrentPitcher() {
    return _currentPitcher;
  }

  /// Add a hitter to the starting lineup.
  void addStartingHitter(Player hitter) {
    // Also check if id already exists?
    if (_startingHitters.length < maxStartingHitters && hitter != null) {
      _startingHitters.add(hitter);
      _tempRoster.remove(hitter);
    }
  }

  Player getPlayerById(String id) {
    Player player;
    if (id != null && id.isNotEmpty) {
      for (int i = 0; i < _teamRoster.length; i++) {
        if (_teamRoster[i].id.compareTo(id) == 0) {
          return _teamRoster[i];
        }
      }
    }
    return player;
  }

  /// Returns the first occurence of a hitter matching [playerId].
  Player getHitterById(String playerId) {
    Player hitter;
    if (playerId != null && playerId.isNotEmpty) {
      for (int i = 0; i < _startingHitters.length; i++) {
        if (_startingHitters.elementAt(i).id == playerId) {
          hitter = _startingHitters.elementAt(i);
          return hitter;
        }
      }
    }
    return hitter;
  }

  /// Returns the first occurence of a hitter with [first] and [last] name.
  Player getHitterByFullName(String first, String last) {
    Player hitter;
    if (first.isNotEmpty && first != null && last.isNotEmpty && last != null) {
      for (int i = 0; i < _startingHitters.length; i++) {
        if (_startingHitters.elementAt(i).firstName.compareTo(first) == 0 &&
            _startingHitters.elementAt(i).lastName.compareTo(last) == 0) {
          hitter = _startingHitters.elementAt(i);
          return hitter;
        }
      }
    }
    return hitter;
  }

  Player getPlayerByFullName(String fullName) {
    Player player;
    if (fullName.isNotEmpty && fullName != null) {
      for (int i = 0; i < _teamRoster.length; i++) {
        String playerStr = _teamRoster[i].getFullName();
        if (playerStr.compareTo(fullName) == 0) {
          player = _teamRoster[i];
          return player;
        }
      }
    }
    return player;
  }

  Player getPlayerByFirstLast(String first, String last) {
    Player player;
    if (first.isNotEmpty && first != null && last.isNotEmpty && last != null) {
      for (int i = 0; i < _teamRoster.length; i++) {
        if (_teamRoster[i].firstName.compareTo(first) == 0 &&
            _teamRoster[i].lastName.compareTo(last) == 0) {
          player = _teamRoster[i];
          return player;
        }
      }
    }
    return player;
  }

  // Apply checks when pitcher is / is not one of the hitters
  void substitutePitcher(Player sub) {
    if (_sortedRoster.contains(sub)) {
      if (!_startingHitters.contains(sub)) {
        substituteHitter(_currentPitcher, sub);
      }
      _currentPitcher = sub;
    }
  }

  /// Substitutes the [current] Player with a [sub] Player.
  /// Note that batting order stays the same if the pitcher is subbed out
  /// with a player from the starting hitter lineup (When pitching).
  /// Track reserves in a separate list and build the sortedRoster
  void substituteHitter(Player current, Player sub) {
    print(LineupHandler());
    // Check that [current] exists and [sub] is not null
    if (_startingHitters.contains(current)) {
      // Case that the [sub] is a reserve (on bench)
      if (!_startingHitters.contains(sub)) {
        // Move [current] to reserve list?
        // Set the Player at the index position to [sub]
        // Remove [sub] from reserve list?
        if (current == _currentPitcher) {
          _currentPitcher = sub;
        }
        int hitterIndex = _startingHitters.indexOf(current);
        int sortedIndexOfCurrent = _sortedRoster.indexOf(current);
        int sortedSubIndexOfCurrent = _sortedRoster.indexOf(sub);
        _startingHitters.removeAt(hitterIndex);
        _sortedRoster.removeAt(sortedIndexOfCurrent); // remove current
        _startingHitters.insert(hitterIndex, sub);
        _sortedRoster.insert(sortedIndexOfCurrent, sub); // place sub
        _sortedRoster.removeAt(sortedSubIndexOfCurrent); // remove old sub spot
        _sortedRoster.insert(
            sortedSubIndexOfCurrent, current); // add curr to old sub spot
        // If on Pitching screen: only update hitters if the currentHitter == pitcher
        if ((!ScoringHandler().isHitting() && _currentHitter == current) ||
            ScoringHandler().isHitting()) {
          _currentHitter = sub;
        } // Bug: if pitcher is subbed, next hitter is pitcher
      } else {
        int hitterIndexOfCurrent = _startingHitters.indexOf(current);
        int subIndexOfCurrent = _startingHitters.indexOf(sub);
        int sortedIndexOfCurrent = _sortedRoster.indexOf(current);
        int sortedSubIndexOfCurrent = _sortedRoster.indexOf(sub);

        _startingHitters.removeAt(hitterIndexOfCurrent);
        _sortedRoster.removeAt(sortedIndexOfCurrent);
        _startingHitters.insert(hitterIndexOfCurrent, sub);
        _sortedRoster.insert(sortedIndexOfCurrent, sub);
        _startingHitters.removeAt(subIndexOfCurrent);
        _sortedRoster.removeAt(sortedSubIndexOfCurrent);
        _startingHitters.insert(subIndexOfCurrent, current);
        _sortedRoster.insert(sortedSubIndexOfCurrent, current);
        _currentHitter = sub;
        // Save the indices of both [current] and [sub]
        // Swap [current] with [sub]
      }
    }
    print(LineupHandler());
  }

  Iterator<Player> getStartingHittersIterator() {
    return _startingHitters.iterator;
  }

  String _getStartingHitters() {
    String hittersToStr = '';
    for (int i = 0; i < _startingHitters.length; i++) {
      hittersToStr += _startingHitters[i].toString();
      hittersToStr += '\n';
    }
    return hittersToStr;
  }

  @override
  String toString() {
    String toStr = 'LineupHandler:\n';
    toStr += 'Event Name = $eventName\n';
    toStr += 'Starting Pitcher = $_currentPitcher\n';
    toStr += 'Starting Hitters:\n';
    toStr += _getStartingHitters();
    return toStr;
  }
}
