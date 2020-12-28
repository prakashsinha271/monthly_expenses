import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_monthly_budget/screens/home.dart';
import 'package:flutter_monthly_budget/screens/sign_in.dart';
import 'package:flutter_monthly_budget/utils/new_database_helper.dart';
import 'package:splashscreen/splashscreen.dart';

void main() {
  runApp(MyApp());
}

/*
* Common title for use anywhere in the app
*/

String myTitle =
    "Monthly Budget"; // this is title that can be used anywhere in the app

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DatabaseHelper1 helper = DatabaseHelper1();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    helper
        .initializeDatabase(); //local SQLite database will be initiated while the app is loading
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: myTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(), //Splash screen will be called
    );
  }
}

/*
* This is Splash Screen
*/

class SplashScreenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      gradientBackground: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.blue, Colors.red]),
      seconds: 6, //Splash screen will be display for 6 seconds
      navigateAfterSeconds:
          new LoginPage(), //Home(), //After then Home() will be called, and we have our home page
      backgroundColor: Colors.yellow,
      title: new Text(
        '$myTitle',
        textScaleFactor: 2,
      ),
      image: new Image.asset('img.webp'),
      loadingText: Text("Loading"),
      photoSize: 150.0,
      loaderColor: Colors.white38,
    );
  }
}

/*
* This is common alert dialog box for showing under construction message
*/

showAlertProgress(BuildContext context) {
  Widget okButton = FlatButton(
    child: Text("Close"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  AlertDialog alert = AlertDialog(
    title: Text("$myTitle"),
    content: Container(
      height: 100.0,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.red, Colors.blue])),
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Column(
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 35,
          ),
          SizedBox(height: 15),
          Text("Sorry!! This Page is in Under Development"),
        ],
      ),
    ),
    actions: [
      okButton,
    ],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
