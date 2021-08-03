import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class FileUtil {
  static String postEventFile = 'postEvent.txt';
  static String postClipFile = 'postClip.txt';
  static String event = 'event.txt';

  //get the file dir
  static Future<String> get getFilePath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  //gets the saved games file
  static Future<File> get getPostEventFile async {
    final path = await getFilePath;
    log(path);
    return File('$path/$postEvent');
  }

  //gets the saved games file
  static Future<File> get getPostClipFile async {
    final path = await getFilePath;
    log(path);
    return File('$path/$postClipFile');
  }

  //gets the saved games file
  static Future<File> get getEventFile async {
    final path = await getFilePath;
    log(path);
    return File('$path/$event');
  }

  //writes to the file
  static Future<File> writePostEventFile(String data) async {
    final file = await getPostEventFile;
    return file.writeAsString(data);
  }

  static Future<File> writePostClipFile(String data) async {
    final file = await getPostClipFile;
    return file.writeAsString(data);
  }

  static Future<File> writeEvent(String eventName, eventDate) async {
    final file = await getEventFile;
    file.writeAsString(eventName + '\n' + eventDate);
    return file;
  }

  // Reads from the file
  static Future<String> readPostEventFile() async {
    try {
      final file = await getPostEventFile;
      String contents = await file.readAsString();
      log(contents);
      return contents;
    } catch (e) {
      // If encountering an error, print error message
      return "couldn't read file";
    }
  }

  // Reads from the file
  static Future<String> readPostClipFile() async {
    try {
      final file = await getPostClipFile;
      String contents = await file.readAsString();
      log(contents);
      return contents;
    } catch (e) {
      // If encountering an error, print error message
      return "couldn't read file";
    }
  }

  // Reads from the file
  static Future<List<String>> readEvent() async {
    try {
      final file = await getEventFile;
      List<String> contents = await file.readAsLines();
      contents.forEach((element) {
        log(element);
      });
      return contents;
    } catch (e) {
      // If encountering an error, print error message
      return ['error'];
    }
  }
}
