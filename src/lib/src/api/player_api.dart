import 'dart:convert';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:project/src/ui/handler/player.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String url = 'https://api-dev.levelapp.saveondev.com/players';

Future<List<Player>> fetchPlayers(http.Client client) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  final response = await client.get('$url',
      headers: {"X-Session-Token": '${sharedPreferences.get('token')}'});
  return compute(parsePlayers, response.body);
}

// A function that converts a response body into a List<Player>.
List<Player> parsePlayers(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Player>((json) => Player.fromJson(json)).toList();
}
