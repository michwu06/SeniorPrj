import 'dart:convert';

import 'package:flutter/material.dart';

import 'player.dart';

/// A score type is describes the outcome of a play.
enum ScoreType {
  strikeout,
  bbhbp,
  flyout,
  groundout,
  single,
  double,
  triple,
  homerun,
  error,
  bunt,
}

extension scoreToString on ScoreType {
  String toDisplayString() {
    return toDisplayStringAsJson(false);
  }

  String toDisplayStringAsJson(bool asJson) {
    String displayStr;
    if (this == ScoreType.bbhbp && !asJson) {
      displayStr = 'BB/HBP';
    } else if (this == ScoreType.bbhbp && asJson) {
      displayStr = 'HBP';
    } else {
      displayStr = this.toString().split('.').last;
      displayStr =
          displayStr[0].toUpperCase() + displayStr.substring(1).toLowerCase();
    }
    return displayStr;
  }
}

class Play {
  int order; // Order matches the participants (See API)
  String playerId; // A play is associated with one player
  PlayerType playerType; // Get the type of player being scored
  String startTime; // Convert into a TimeStamp type later
  String endTime; // Convert into a TimeStamp type later
  ScoreType scoreType; // Type of score

  Play({
    this.order,
    @required this.playerId,
    this.playerType, // Handler will set this value?
    @required this.startTime,
    @required this.endTime,
    @required this.scoreType,
  });

  // factory Play.fromJson(Map<String, dynamic> json) {
  //   return Play(
  //     order: json['order'] as int,
  //     playerId: json['playerId'] as String,
  //     playerType: json['playerType'] as PlayerType,
  //     startTime: json['startTime'] as String,
  //     endTime: json['endTime'] as String,
  //     scoreType: json['scoreType'] as ScoreType,
  //   );
  // }

  // static String getScoreAsString(ScoreType scoreType) {
  //   String scoreStr;
  //   switch (scoreType) {
  //     case ScoreType.strikeout:
  //       scoreStr = 'Strikeout';
  //       break;
  //     case ScoreType.bbhbp:
  //       scoreStr = 'BB/HBP';
  //       break;
  //     case ScoreType.flyout:
  //       scoreStr = 'Flyout';
  //       break;
  //     case ScoreType.groundout:
  //       scoreStr = 'Groundout';
  //       break;
  //     case ScoreType.single:
  //       scoreStr = 'Single';
  //       break;
  //     case ScoreType.double:
  //       scoreStr = 'Double';
  //       break;
  //     case ScoreType.triple:
  //       scoreStr = 'Triple';
  //       break;
  //     case ScoreType.homerun:
  //       scoreStr = 'Homerun';
  //       break;
  //     case ScoreType.error:
  //       scoreStr = 'Error';
  //       break;
  //     case ScoreType.bunt:
  //       scoreStr = 'Bunt';
  //       break;
  //     default:
  //       scoreStr = '';
  //   }
  //   return scoreStr;
  // }
  //

  Map<String, dynamic> toEventJson() {
    return {
      json.encode('order'): order,
      json.encode('playerId'): json.encode('$playerId'),
      json.encode('playerType'): json.encode('${playerType.toShortString()}'),
    };
  }

  Map<String, dynamic> toClipJson() {
    return {
      json.encode('order'): order,
      json.encode('playerType'): json.encode(playerType.toShortString()),
      json.encode('startTime'): json.encode(startTime),
      json.encode('endTime'): json.encode(endTime),
      json.encode('score'): json.encode(scoreType.toDisplayStringAsJson(true)),
    };
  }

  @override
  String toString() {
    String toStr = '';
    String playInfo =
        '[order: $order, player: $playerId, playerType: $playerType, ';
    String timeInfo =
        'startTime: $startTime, endTime: $endTime, scoreType: $scoreType]';
    return toStr + playInfo + timeInfo;
  }
}
