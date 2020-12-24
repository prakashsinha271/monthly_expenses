import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_monthly_budget/main.dart';
import 'package:flutter_monthly_budget/screens/transaction.dart';

class Records extends StatefulWidget {
  Records({Key key}) : super(key: key);
  @override
  _RecordsState createState() => _RecordsState();
}

class _RecordsState extends State<Records> {
  DatabaseReference _ref; //Database Reference Variable
  int _debitTotal = 0, _creditTotal = 0; //Integer type variable for total amounts

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _ref = FirebaseDatabase.instance
        .reference(); //initialising firebase API database reference
  }

  /*
  Build dynamic list for API's data
   */

  Widget _buildDataItem({Map data, BuildContext context}) {
    Color typeColor = getTypeColor(data['Transaction']);
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.white, Colors.blueGrey])),
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(10),
      //height: 300.0,            //This is height for individual tile
      //color: Colors.white,
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.attach_money_rounded,
                color: typeColor,
                size: 20,
              ),
              SizedBox(
                width: 6,
              ),
              Text(
                data['Amount'],
                style: TextStyle(
                    fontSize: 16,
                    color: typeColor,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(width: 20),
              Icon(
                Icons.money,
                color: typeColor,
                size: 20,
              ),
              SizedBox(
                width: 6,
              ),
              Text(
                data['Transaction'],
                style: TextStyle(
                    fontSize: 16,
                    color: typeColor,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Icon(
                Icons.library_books_rounded,
                color: typeColor,
                size: 20,
              ),
              SizedBox(
                width: 6,
              ),
              Text(
                data['Description'],
                style: TextStyle(
                    fontSize: 16,
                    color: typeColor,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(
                Icons.date_range_rounded,
                color: typeColor,
                size: 20,
              ),
              SizedBox(
                width: 6,
              ),
              Text(
                data['Date'],
                style: TextStyle(
                    fontSize: 16,
                    color: typeColor,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(width: 20),
              GestureDetector(
                onDoubleTap: () {
                  delData(
                      data['UniqueVal'], data['Transaction'], data['Amount']);
                },
                onTap: () {
                  final snackBar = SnackBar(
                      content: Text('Double Tap To Delete This Record'));
                  Scaffold.of(context).showSnackBar(snackBar);
                  print("Visited onTap()");
                },
                child: Icon(
                  Icons.delete_forever_outlined,
                  color: Colors.red,
                  size: 30,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /*
  Body for record page
   */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction $myTitle'),
      ),
      body: Container(
        //height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Container(
                // height: 100.0,
                // width: 300.0,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    gradient:
                        LinearGradient(colors: [Colors.green, Colors.blue])),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Colors.lightBlueAccent,
                  elevation: 10,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 60.0,
                        child: FutureBuilder(
                            future: getCredit(),
                            builder:
                                (context, AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                //return Text(_creditTotal.toString());
                                return ListTile(
                                  leading: Icon(Icons.attach_money_rounded,
                                      size: 50),
                                  title: Text(
                                      (_creditTotal - _debitTotal).toString(),
                                      style: TextStyle(fontSize: 25.0)),
                                  subtitle: Text('Available Balance in Wallet',
                                      style: TextStyle(fontSize: 15.0)),
                                );
                              } else if (snapshot.data ==
                                  ConnectionState.none) {
                                return ListTile(
                                  leading: Icon(Icons.attach_money_rounded,
                                      size: 50),
                                  title: Text(
                                      (_creditTotal - _debitTotal).toString(),
                                      style: TextStyle(fontSize: 25.0)),
                                  subtitle: Text('Available Balance in Wallet',
                                      style: TextStyle(fontSize: 15.0)),
                                );
                              }
                              return CircularProgressIndicator();
                            }),
                      ),
                      ButtonBar(
                        children: <Widget>[
                          FutureBuilder(
                              future: getDebit(),
                              builder:
                                  (context, AsyncSnapshot<dynamic> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return RaisedButton(
                                    child: Text('Total Debit $_debitTotal'),
                                    color: Colors.teal,
                                    onPressed: () {},
                                  );
                                } else if (snapshot.connectionState ==
                                    ConnectionState.none) {
                                  return Text("No data");
                                }
                                return CircularProgressIndicator(); // child:
                              }
                              // ),
                              ),
                          FutureBuilder(
                              future: getDebit(),
                              builder:
                                  (context, AsyncSnapshot<dynamic> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return RaisedButton(
                                    child: Text('Total Credit $_creditTotal'),
                                    color: Colors.green,
                                    onPressed: () {},
                                  );
                                } else if (snapshot.connectionState ==
                                    ConnectionState.none) {
                                  return Text("No data");
                                }
                                return CircularProgressIndicator(); // child:
                              }),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Flexible(
              child: FirebaseAnimatedList(
                padding: EdgeInsets.all(10),
                query: _ref.child("CreditDebit"),
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  Map data = snapshot.value;
                  return _buildDataItem(data: data, context: context);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) {
              return Transaction();
            }),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
        tooltip: "New Transaction",
      ),
    );
  }

  /*
  Define color type for differentiate credit and debit text color
   */

  Color getTypeColor(String type) {
    Color color = Theme.of(context).accentColor;

    if (type == 'Credit') {
      color = Colors.green;
    }

    if (type == 'Debit') {
      color = Colors.teal;
    }
    return color;
  }

  /*
  Get Total Credit from API to calculate the amount
   */

  Future<dynamic> getCredit() async {
    await _ref
        .child("Calculation")
        .child('TotalCredit')
        .once()
        .then((DataSnapshot snapshot) {
      Map data = snapshot.value;
      _creditTotal = data['TotalCredit'];
      return _creditTotal.toString();
    });
  }

  /*
  Get Total Debit from API to calculate the amount
   */

  Future<dynamic> getDebit() async {
    await _ref
        .child("Calculation")
        .child('TotalDebit')
        .once()
        .then((DataSnapshot snapshot) {
      Map data = snapshot.value;
      _debitTotal = data['TotalDebit'];
      return _debitTotal;
    });
  }

  /*
  Delete single node data on tap event
   */

  void delData(dataKey, dataType, dataAmount) {
    int updateAmount;
    if (dataType == "Debit") {
      //type = debit
      updateAmount = _debitTotal - int.parse(dataAmount);

      Map<String, int> updateData = {
        'Total$dataType': updateAmount,
      };
      _ref.child("Calculation/Total$dataType").update(updateData).then((value) {
        _ref.child("CreditDebit/").child(dataKey).remove();
        Navigator.pop(context);
      });
    } else if (dataType == "Credit") {
      updateAmount = _creditTotal - int.parse(dataAmount);
      Map<String, int> updateData = {
        'Total$dataType': updateAmount,
      };
      _ref.child("Calculation/Total$dataType").update(updateData).then((value) {
        _ref.child("CreditDebit/").child(dataKey).remove();
        Navigator.pop(context);
      });
    }
  }
}
