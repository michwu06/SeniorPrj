import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';

//import '../../ui_exporter.dart';

const String url = 'https://api-dev.levelapp.saveondev.com/login';

Future<String> authenticateUser(String username, String password) async {
  SharedPreferences.setMockInitialValues({});
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  final msg = jsonEncode({'email': username, 'password': password});
  final response = await http.post('$url',
      headers: {
        'Content-Type': 'application/json',
        //'Accept': 'application/json'
      },
      body: msg);

// successful
  if (response.statusCode == 200) {
    final convertData = jsonDecode(response.body);
    print('success from login_api.dart\n');
    print('\nbody:' + response.body);

    if (convertData != null) {
      sharedPreferences.setString("token", convertData['token']);
      //print('\ntoken: ${sharedPreferences.get('token')}');
      return sharedPreferences.getString('token');
    }
  } else {
    //401 authentication failed
    print('\nERROR\n');
    print('\nfailed from login_api.dart\n');
    return null;
  }
}
