import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';

import '../../handler_exporter.dart';

const String urlEvent = 'https://api-dev.levelapp.saveondev.com/events';
const String urlClip = 'https://api-dev.levelapp.saveondev.com/clips';

class UploadApi {
  Future<int> createEvent(String bodyMessage) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    //Map<String, dynamic> data = new Map<String, dynamic>();

    // i dont understand how the inning.dart works

    // temporary test

    final response = await http.post('$urlEvent',
        headers: {
          "Content-Type": "application/json",
          "X-Session-Token": '${sharedPreferences.get('token')}'
        },
        body: bodyMessage);

    // successful
    if (response.statusCode == 200) {
      final convertData = jsonDecode(response.body);
      print('\nsuccess from createEvent\n');
      print('\nbody:' + response.body);

      if (convertData != null) {
        // im not sure which one im supposed to grab
        sharedPreferences.setString("EventID", convertData['id']);
        print('\n\nEvent ID: ${sharedPreferences.get('EventID')}\n');
        //createClip();
        return 200;
      }
    } else {
      return null;
    }
  }

  Future<int> createClip(String bodyMessage) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    final response = await http.post('$urlClip',
        headers: {
          'Content-Type': 'application/json',
          "X-Session-Token": '${sharedPreferences.get('token')}'
        },
        body: bodyMessage);

    // successful
    if (response.statusCode == 200) {
      final convertData = jsonDecode(response.body);
      print('\nsuccess from createClips\n');
      print('\nbody:' + response.body);

      if (convertData != null) {
        //idk what to do here
        sharedPreferences.setString("ClipID", convertData['id']);
        sharedPreferences.setString("videoUrl", convertData['videoUrl']);
        print('\n\nClip ID: ${sharedPreferences.get('ClipID')}\n');
        print('\nVideo URL: ${sharedPreferences.get('videoUrl')}\n');
        return 200;
      }
    } else {
      return null;
    }
  }
}
