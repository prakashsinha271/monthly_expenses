import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_monthly_budget/models/newPDF.dart';
import 'package:flutter_monthly_budget/utils/new_database_helper.dart';

class ExportPDF extends StatefulWidget {
  final String appBarTitle;

  ExportPDF(this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return ExportPDFState(this.appBarTitle);
  }
}

class ExportPDFState extends State<ExportPDF> {
  DatabaseHelper1 helper =
      DatabaseHelper1(); //Database helper for accessing SQLite
  String appBarTitle;
  DatabaseReference _ref; //Database Reference for Firebase API database

  ExportPDFState(this.appBarTitle);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _ref =
        FirebaseDatabase.instance.reference(); //Initializing firebase reference
    helper.deleteCD(); //Clearing SQLite table for older records
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        // ignore: missing_return
        onWillPop: () {
          moveToLastScreen();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  moveToLastScreen();
                }),
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Column(
                    children: [
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: RaisedButton(
                              color: Theme.of(context).primaryColorDark,
                              textColor: Theme.of(context).primaryColorLight,
                              child: Text(
                                'Fetch API data into SQLite',
                                textScaleFactor: 1.5,
                              ),
                              onPressed: () {
                                setState(() {
                                  _fetchFirebase();
                                  _showAlertDialog("From API",
                                      "Data has been stored into SQLite from Firebase API");
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: RaisedButton(
                              color: Theme.of(context).primaryColorDark,
                              textColor: Theme.of(context).primaryColorLight,
                              child: Text(
                                'Fetch data from SQLite',
                                textScaleFactor: 1.5,
                              ),
                              onPressed: () {
                                setState(() {
                                  //debugPrint("Fetch Clicked");
                                  //_fetchFirebase();

                                  var tmp = helper
                                      .getCreditDebitMapList()
                                      .then((value) {
                                    if (value.length != 0) {
                                      print("Data Fetched From Database");
                                      print(value.toString());
                                      _showAlertDialog("From SQL",
                                          "Data has been received from SQLite, and for display the data in screen is in under progress..\n\nCurrently you can track data in debug console.");
                                    } else {
                                      _showAlertDialog("From SQL",
                                          "Data not found.\n\nPlease fetch data from cloud");
                                    }
                                  });
                                  //print(helper.getCDList());
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          'Clear SQLite Data',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          setState(() {
                            helper.deleteCD();
                            _showAlertDialog("From SQLite",
                                "Local storage has been cleared.\n\nYou can retrieve your data from API");
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  //Fetch the data from firebase
  void _fetchFirebase() {
    _ref.child("CreditDebit/").onChildAdded.listen((event) {
      _ref
          .child("CreditDebit")
          .child(event.snapshot.key)
          .once()
          .then((DataSnapshot snapshot) async {
        if (snapshot.value != null) {
          Map data = snapshot.value;
          CreditDebitClass cdClass = new CreditDebitClass.withId(
              data['UniqueVal'],
              data['Description'],
              data['Transaction'],
              data['Amount'],
              data['Date']);
          _save(cdClass);
        }
      });
    });
  }

  //Insert firebase data into SQLite
  void _save(CreditDebitClass cdClass) async {
    int result;
    result = await helper.insertCD(cdClass);
    if (result == 0) {
      // Failure
      _showAlertDialog('Status', 'Problem Saving Data');
    }
  }

  //Alert Dialog box for status
  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
