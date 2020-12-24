import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_monthly_budget/main.dart';
import 'package:flutter_monthly_budget/screens/pdf_export.dart';
import 'package:flutter_monthly_budget/screens/record.dart';
import 'package:flutter_monthly_budget/screens/transaction.dart';
import 'help.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DatabaseReference _ref;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _ref = FirebaseDatabase.instance.reference();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(myTitle),
      ),

      /*
      Drawer Menu
       */

      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Row(
                children: [
                  Image.asset(
                    'avatar.jpeg',
                    height: 60,
                    width: 60,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Monthly\nBudget\nAnalytics',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text("View Records"),
              leading: Icon(Icons.library_books),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Records()));
              },
            ),
            Divider(height: 0.2),
            ListTile(
              title: Text("Transaction"),
              leading: Icon(Icons.attach_money_rounded),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Transaction()));
              },
            ),
            ListTile(
              title: Text("Help"),
              leading: Icon(Icons.help_outline_rounded),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Help()));
              },
            ),
            ListTile(
              title: Text("About"),
              leading: Icon(Icons.account_box_outlined),
              onTap: () {
                showAlertProgress(context);
              },
            ),
            ListTile(
              title: Text("Exit"),
              leading: Icon(Icons.exit_to_app_rounded),
              onTap: () {
                SystemNavigator.pop();
              },
            ),
          ],
        ),
      ),

      /*
      Body of Home Page
       */

      body: Container(
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.all(15),
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => Records()));
                    },
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            Color(0xFF0D47A1),
                            Color(0xFF1976D2),
                            Color(0xFF42A5F5),
                          ],
                        ),
                      ),
                      padding:
                          const EdgeInsets.fromLTRB(35.0, 10.0, 35.0, 10.0),
                      child:
                          const Text('Records', style: TextStyle(fontSize: 20)),
                    ),
                  ),
                ),
                SizedBox(
                  width: 40,
                ),
                Expanded(
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  Transaction()));
                    },
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            Color(0xFF0D47A1),
                            Color(0xFF1976D2),
                            Color(0xFF42A5F5),
                          ],
                        ),
                      ),
                      padding:
                          const EdgeInsets.fromLTRB(13.0, 10.0, 13.0, 10.0),
                      child: const Text('Transactions',
                          style: TextStyle(fontSize: 20)),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: RaisedButton(
                    onPressed: () {
                      //showAlertProgress(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ExportPDF(myTitle)));
                    },
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            Color(0xFF0D47A1),
                            Color(0xFF1976D2),
                            Color(0xFF42A5F5),
                          ],
                        ),
                      ),
                      padding:
                          const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      child: const Text('Export Data',
                          style: TextStyle(fontSize: 20)),
                    ),
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                Expanded(
                  child: RaisedButton(
                    onPressed: () async {
                      final ConfirmAction action =
                          await _asyncConfirmDialog(context);
                      //
                      if (action == ConfirmAction.Accept) {
                        Map<String, int> _updateCredit = {
                          'TotalCredit': 0,
                        };
                        Map<String, int> _updateDebit = {
                          'TotalDebit': 0,
                        };
                        //print("Confirm Action $action");
                        _ref
                            .child("Calculation/TotalCredit")
                            .update(_updateCredit)
                            .then((value) {
                          _ref
                              .child("Calculation/TotalDebit")
                              .update(_updateDebit)
                              .then((value) {
                            _ref.child("CreditDebit/").remove();
                            _ref.child("UniqueVal/").remove();
                          });
                        });
                      }
                    },
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            Color(0xFF0D47A1),
                            Color(0xFF1976D2),
                            Color(0xFF42A5F5),
                          ],
                        ),
                      ),
                      padding:
                          const EdgeInsets.fromLTRB(23.0, 10.0, 23.0, 10.0),
                      child: const Text('Clear Data',
                          style: TextStyle(fontSize: 20)),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => Help()));
                    },
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            Color(0xFF0D47A1),
                            Color(0xFF1976D2),
                            Color(0xFF42A5F5),
                          ],
                        ),
                      ),
                      padding:
                          const EdgeInsets.fromLTRB(45.0, 10.0, 45.0, 10.0),
                      child: const Text('Help', style: TextStyle(fontSize: 20)),
                    ),
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                Expanded(
                  child: RaisedButton(
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            Color(0xFF0D47A1),
                            Color(0xFF1976D2),
                            Color(0xFF42A5F5),
                          ],
                        ),
                      ),
                      padding:
                          const EdgeInsets.fromLTRB(45.0, 10.0, 45.0, 10.0),
                      child: const Text('Exit', style: TextStyle(fontSize: 20)),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//Confirm Action Dialog Box for Clearing API Data
enum ConfirmAction { Cancel, Accept }
Future<ConfirmAction> _asyncConfirmDialog(BuildContext context) async {
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('$myTitle'),
        content: const Text(
            'This will clear all records.\n\nAnd will never recovered.'),
        actions: <Widget>[
          FlatButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.Cancel);
            },
          ),
          FlatButton(
            child: const Text('Delete'),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.Accept);
            },
          )
        ],
      );
    },
  );
}
