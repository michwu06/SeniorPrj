import 'dart:developer';
import 'dart:convert';
import 'package:project/handler_exporter.dart';
import 'package:project/src/api/upload_api.dart';
import 'package:project/src/ui/common_util.dart';
import 'package:project/src/ui/util/global_timer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'inning.dart';
import 'player.dart';
import 'play.dart';

enum HomeAwayStatus { home, away }

/// ScoringHandler will only be initialized once and will handle scoring
/// for both hitting and pitching.
class ScoringHandler {
  // Singleton implementation of the ScoringHandler
  static final ScoringHandler _scoringHandler = ScoringHandler._internal();

  // Inning tracking
  List<Inning> _innings = [];
  Inning _currentInning;

  // Play tracking
  HomeAwayStatus _homeAwayStatus; // if home, pitch top1st, if away hit top1st
  int _playOrder;
  int _inningNumber; // Can be calculated from list total ?
  InningHalf _inningHalf;
  String _lastHalfInningStr;
  List<Play> _lastHalfPlays;

  // Empty constructor
  ScoringHandler._internal();

  // Singleton
  factory ScoringHandler() {
    return _scoringHandler;
  }

  void clearAll() {
    _innings.clear();
    _currentInning = null;
    _homeAwayStatus = null;
    _playOrder = null;
    _inningNumber = null;
    _inningHalf = null;
    _lastHalfInningStr = null;
    _lastHalfPlays.clear();
  }

  // ScoringHandler depends on the lineup of LineupHandler
  void init(HomeAwayStatus status) {
    if (this._homeAwayStatus == null) {
      //_currentPitcher = LineupHandler().getCurrentPitcher();
      //_currentHitter = LineupHandler().getCurrentHitter();
      //_startingHitters = LineupHandler().getStartingHitters();
      //_nextHitter = _getNextHitter();
      // Home = Always pitch at the top, hit at the bottom
      // Away = Always hit at the top, pitch at the bottom
      this._homeAwayStatus = status;
      _playOrder = 1;
      _inningNumber = 1;
      _inningHalf = InningHalf.top;
      _lastHalfInningStr = getInningStr();
      _lastHalfPlays = [];
    }
  }

  void getInningMap() {
    log(_currentInning.topInningEventMap().toString());
    log(_currentInning.botInningEventMap().toString());
  }

  Future<int> preparePostEvent(bool uploadNow) async {
    _addInning();
    List<String> inningMaps = [];
    _innings.forEach((inning) {
      String topHalfPlays = inning.topInningEventMap().toString();
      String bottomHalfPlays = inning.botInningEventMap().toString();
      inningMaps.add(topHalfPlays);
      inningMaps.add(bottomHalfPlays);
    });
    Map<String, dynamic> eventBody = {
      json.encode('innings'): inningMaps,
      json.encode('name'): json.encode(LineupHandler().eventName),
      json.encode('eventDate'): json.encode(LineupHandler().getEventDate()),
    };
    // Save Post Event
    FileUtil.writePostEventFile(eventBody.toString());
    FileUtil.writeEvent(
        LineupHandler().eventName, LineupHandler().getEventDate());
    FileUtil.readEvent();
    //log(eventBody.toString());
    if (uploadNow) {
      UploadApi uploadApi = UploadApi();
      Future<int> status = uploadApi.createEvent(eventBody.toString());
      return status;
    }
    return 0;
    // status.then((value) => value == 200
    //     ? preparePostClip()
    //     : log('Status code: $value, could not create event.'));
  }

  Future<int> preparePostClip(bool uploadNow) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _addInning();
    List<String> inningClipMaps = [];
    _innings.forEach((inning) {
      String topHalfClips = inning.topInningClipMap().toString();
      String botHalfClips = inning.botInningClipMap().toString();
      inningClipMaps.add(topHalfClips);
      inningClipMaps.add(botHalfClips);
    });
    Map<String, dynamic> clipBody = {
      json.encode('eventId'): json.encode(sharedPreferences.get('EventID')),
      json.encode('createDate'): json.encode(LineupHandler().getDate()),
      json.encode('timers'): inningClipMaps,
    };
    FileUtil.writePostClipFile(clipBody.toString());
    if (uploadNow) {
      UploadApi uploadApi = UploadApi();
      Future<int> status = uploadApi.createClip(clipBody.toString());
      return status;
    }
    return 0;
  }

  void clearAllSettings() {
    _homeAwayStatus = null;
  }

  Play createPlay(ScoreType scoreType) {
    Player player;
    if (_inningHalf == InningHalf.top) {
      if (_homeAwayStatus == HomeAwayStatus.home) {
        player = LineupHandler().getCurrentPitcher();
      } else {
        player = LineupHandler().getCurrentHitter();
      }
    } else {
      if (_homeAwayStatus == HomeAwayStatus.home) {
        player = LineupHandler().getCurrentHitter();
      } else {
        player = LineupHandler().getCurrentPitcher();
      }
    }

    Play play = Play(
      order: _playOrder,
      playerId: player.id,
      playerType: getPlayerType(),
      startTime: GlobalTimer().getStartTime(),
      endTime: GlobalTimer().getEndTime(),
      scoreType: scoreType,
    );
    return play;
  }

  PlayerType getPlayerType() {
    if (_inningHalf == InningHalf.top) {
      if (_homeAwayStatus == HomeAwayStatus.home) {
        return PlayerType.pitcher;
      } else {
        return PlayerType.hitter;
      }
    } else {
      if (_homeAwayStatus == HomeAwayStatus.home) {
        return PlayerType.hitter;
      } else {
        return PlayerType.pitcher;
      }
    }
  }

  HomeAwayStatus getHomeAwayStatus() {
    return _homeAwayStatus;
  }

  /// Adds the play to the current half-inning. [half] is experimental and
  /// might be replaced later.
  void addPlay(ScoreType scoreType) {
    // Plays are created in the UI widget?

    // First see if the currentInning exists
    if (_currentInning == null) {
      // Create a new inning
      _currentInning = _createInning(_inningNumber);
    }

    Play play = createPlay(scoreType);
    //log(play.toString());
    if (_inningHalf == InningHalf.top) {
      _currentInning.addTopHalfPlay(play);
    } else {
      _currentInning.addBottomHalfPlay(play);
    }
    _incrementPlayOrder();
    if (hitting()) {
      LineupHandler().advanceHitter();
    }
    log(_currentInning.toString());
  }

  bool hitting() {
    if (_homeAwayStatus == HomeAwayStatus.home &&
        _inningHalf == InningHalf.bottom) {
      return true;
    } else {
      if (_homeAwayStatus == HomeAwayStatus.away &&
          _inningHalf == InningHalf.top) {
        return true;
      }
    }
    return false;
  }

  // Replace _currentPitcher and _currenHitter with direct references from
  // LineupHandler()?
  Player getPlayerToScore() {
    Player playerToScore;
    if (_homeAwayStatus == HomeAwayStatus.home) {
      if (_inningHalf == InningHalf.top) {
        playerToScore = LineupHandler().getCurrentPitcher();
      } else {
        playerToScore = LineupHandler().getCurrentHitter();
      }
    } else {
      if (_inningHalf == InningHalf.top) {
        playerToScore = LineupHandler().getCurrentHitter();
      } else {
        playerToScore = LineupHandler().getCurrentPitcher();
      }
    }
    //log('playerToScore: $playerToScore');
    return playerToScore;
  }

  String getGoToString() {
    String goToString;
    if (_homeAwayStatus == HomeAwayStatus.home) {
      if (_inningHalf == InningHalf.top) {
        goToString = 'Go to Hitting';
      } else {
        goToString = 'Go to Pitching';
      }
    } else {
      if (_inningHalf == InningHalf.top) {
        goToString = 'Go to Pitching';
      } else {
        goToString = 'Go to Hitting';
      }
    }
    return goToString;
  }

  String getHitterPitcherString() {
    String hitterPitcherStr;
    if (_homeAwayStatus == HomeAwayStatus.home) {
      if (_inningHalf == InningHalf.top) {
        hitterPitcherStr = 'Pitcher: ';
      } else {
        hitterPitcherStr = 'Hitter: ';
      }
    } else {
      if (_inningHalf == InningHalf.top) {
        hitterPitcherStr = 'Hitter: ';
      } else {
        hitterPitcherStr = 'Pitcher: ';
      }
    }
    return hitterPitcherStr + getPlayerToScore().getFullName();
  }

  String getLastHalfStr() {
    return _lastHalfInningStr;
  }

  String getInningStr() {
    String inningStr;
    if (_inningHalf == InningHalf.top) {
      inningStr = 'Top $_inningNumber';
    } else {
      inningStr = 'Bottom $_inningNumber';
    }
    return inningStr;
  }

  void _setLastHalfPlays() {
    _lastHalfPlays.clear();
    if (_currentInning != null) {
      Iterator<Play> playIter;
      if (_inningHalf == InningHalf.top) {
        playIter = _currentInning.getTopHalfIterator();
      } else {
        playIter = _currentInning.getBottomHalfIterator();
      }
      if (playIter != null) {
        while (playIter.moveNext()) {
          _lastHalfPlays.add(playIter.current);
        }
      }
    }
  }

  // Add inning to inning list when side switch occurs
  // Save a copy of the current inning for the event summary page
  void switchSides() {
    if (_inningHalf != null) {
      _lastHalfInningStr = getInningStr();
      _setLastHalfPlays();
      if (_inningHalf == InningHalf.top) {
        _inningHalf = InningHalf.bottom;
      } else {
        _addInning();
        _inningNumber++;
        _inningHalf = InningHalf.top;
      }
      _resetPlayOrder();
    }
  }

  int _getCurrentInningNumber() {
    return _inningNumber;
  }

  void _addInning() {
    if (_currentInning != null) {
      _innings.add(_currentInning); // Add the current Inning
      _currentInning = null; // Remove current Inning
    }
  }

  Inning _createInning(int inningNumber) {
    return Inning(inningNumber);
  }

  InningHalf getInningHalf() {
    return _inningHalf;
  }

  void _incrementPlayOrder() {
    _playOrder++;
  }

  // Called when switching halves or starting a new inning
  void _resetPlayOrder() {
    _playOrder = 1;
  }

  List<Play> getRecentPlays() {
    return _lastHalfPlays;
  }

  bool isHitting() {
    if ((_homeAwayStatus == HomeAwayStatus.away &&
            _inningHalf == InningHalf.top) ||
        (_homeAwayStatus == HomeAwayStatus.home &&
            _inningHalf == InningHalf.bottom)) {
      return true;
    }
    return false;
  }

  @override
  String toString() {
    String toStr = '';
    String inningStr = 'Innings: \n';
    _innings.forEach((element) {
      inningStr += element.toString();
      inningStr += '\n';
    });
    String currentInnStr = 'Current Inning: $_currentInning \n';
    //String startHittersStr = 'Starting Hitters: \n';
    // _startingHitters.forEach((element) {
    //   startHittersStr += element.toString();
    //   startHittersStr += '\n';
    // });
    String currPitcherStr =
        'Current Pitcher: ${LineupHandler().getCurrentPitcher().getFullName()} \n';
    String currHitterStr =
        'Current Hitter: ${LineupHandler().getCurrentHitter().getFullName()} \n';
    //String nextHitterStr = 'Next Hitter: ${} \n';
    String homeAwayStr = 'Home / Away: $_homeAwayStatus \n';
    String playOrderStr = 'Play Order: $_playOrder \n';
    String inningNumStr = 'Inning #$_inningNumber \n';
    String inningHalfStr = 'Half: $_inningHalf \n';
    return toStr +
        inningStr +
        currentInnStr +
        //startHittersStr +
        currPitcherStr +
        currHitterStr +
        homeAwayStr +
        playOrderStr +
        inningNumStr +
        inningHalfStr;
  }
}
