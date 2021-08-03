import 'package:flutter/material.dart';
import 'package:project/src/api/login_api.dart';

import 'common_util.dart';
import 'package:project/handler_exporter.dart';
import 'main_menu.dart';
import 'create_account_support.dart';
import 'password_support.dart';

class Login extends StatefulWidget {
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formkey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController userController = new TextEditingController();
  final TextEditingController passController = new TextEditingController();

  // login testing => {username: password}
  //final Map<String, String> test = {'admin': 'admin'};

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Login',
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            key: _scaffoldKey,
            // screen layout
            resizeToAvoidBottomInset: false,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                //image of logo
                Image.asset(
                  'images/transparent_logo.png',
                  semanticLabel: 'Level logo',
                  width: 500,
                  height: 300,
                ),

                // TextFormFields for password and username
                Expanded(
                    flex: 6,
                    child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 40.0),
                        //margin: EdgeInsets.all(50.0),
                        child: Form(
                            key: _formkey,
                            child: Column(children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: TextFormField(
                                    controller: userController,
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.visiblePassword,
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 20,
                                    ),
                                    decoration: InputDecoration(
                                        labelText: 'Username',
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                          color: Colors.black54,
                                        ))),
                                    // not sure of how match the username and password validation
                                    // validation
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return '* REQUIRED *';
                                      }
                                      return null;
                                    },
                                    //onSaved: (value) => user = value,
                                  )),

                              Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: TextFormField(
                                    obscureText: true,
                                    controller: passController,
                                    textInputAction: TextInputAction.done,
                                    keyboardType: TextInputType.visiblePassword,
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 20,
                                    ),
                                    decoration: InputDecoration(
                                        labelText: 'Password',
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                          color: Colors.black54,
                                        ))),
                                    // validation
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return '* REQUIRED *';
                                      }
                                      return null;
                                    },
                                    //onSaved: (value) => pass = value,
                                  )),

                              // spacing in between
                              Padding(padding: EdgeInsets.all(10.0)),

                              // button for login
                              ElevatedButton(
                                onPressed: () async {
                                  // validation
                                  if (_formkey.currentState.validate()) {
                                    final token = await authenticateUser(
                                        userController.text,
                                        passController.text);
                                    // check if in system
                                    if (token != null) {
                                      print('\nsuccess from login.dart:\n');
                                      LineupHandler()
                                          .loadRoster(); // Begin load roster
                                      // navigate to main menu
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MainMenu()));
                                    } else {
                                      print('\nfailed from login.dart:\n');
                                      // error notice
                                      _scaffoldKey.currentState.showSnackBar(
                                          SnackBar(
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8,
                                              duration:
                                                  const Duration(minutes: 1),
                                              content: Text(
                                                'Failed Authentication.',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.red,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )));
                                    }
                                    //userController.clear();
                                    //passController.clear();
                                  }
                                },
                                child: Text('Login'),
                                style: ElevatedButton.styleFrom(
                                    primary: LevelTheme.levelLightPurple,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 100, vertical: 20),
                                    textStyle: TextStyle(fontSize: 20),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0))),
                              )
                            ])))),

                /*
            specific layout to spread text buttons for password
            recovery and create account
            */
                Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                flex: 1,
                                child: TextButton(
                                  // navigate to support ui
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ForgotPassword()));
                                  },
                                  child: Text('Forgot Password?',
                                      style: TextStyle(
                                        fontSize: 18,
                                      )),
                                  style: TextButton.styleFrom(
                                    primary: LevelTheme.levelLightPurple,
                                  ),
                                )),
                            Expanded(
                                flex: 0,
                                child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 0.0, horizontal: 15.0))),
                            Expanded(
                                flex: 1,
                                child: TextButton(
                                  // navigate to support ui
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CreateAccount()));
                                  },
                                  child: Text('Create Account',
                                      style: TextStyle(
                                        fontSize: 18,
                                      )),
                                  style: TextButton.styleFrom(
                                    primary: LevelTheme.levelLightPurple,
                                  ),
                                ))
                          ],
                        )))
              ],
            )));
  }
}
