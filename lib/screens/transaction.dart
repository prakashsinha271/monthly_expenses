import 'package:flutter/material.dart';
import 'package:flutter_monthly_budget/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_monthly_budget/models/validate_forms.dart';

enum TransType { Debit, Credit } //Dropdown items

class Transaction extends StatefulWidget {
  Transaction({Key key}) : super(key: key);
  @override
  _TransactionState createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  DatabaseReference _ref; //Firebase database reference variable
  TransType _mode =
      TransType.Debit; //Initializing dropdown variable for default value
  final _formKey = GlobalKey<FormState>(); //global key for form validation
  TextEditingController _amount,
      _description; //TextFormField controller for accessing values and all
  String
      _typeOfTrans; //Variable for defining transaction type i.e. Credit and Debit
  int _debitTotal,
      _creditTotal,
      _unique; //Integer type variable for calculating total credit, debit, and unique key

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //initializing text edit controller
    _amount = TextEditingController();
    _description = TextEditingController();

    //Default type of transaction
    _typeOfTrans = "Debit";

    //initializing database reference
    _ref = FirebaseDatabase.instance.reference();

    //Function that fetch data from firebase for calculation and transaction
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    // String value;
    return Scaffold(
      appBar: AppBar(
        title: Text("Transaction $myTitle"),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Radio(
                      value: TransType.Debit,
                      groupValue: _mode,
                      onChanged: (TransType value) {
                        setState(() {
                          _mode = value;
                          _typeOfTrans = "Debit";
                        });
                      },
                    ),
                    Text("Debit"),
                    SizedBox(
                      width: 30,
                    ),
                    Radio(
                      value: TransType.Credit,
                      groupValue: _mode,
                      onChanged: (TransType value) {
                        setState(() {
                          _mode = value;
                          _typeOfTrans = "Credit";
                        });
                      },
                    ),
                    Text("Credit"),
                  ],
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: _amount,
                  maxLength: 5,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.attach_money_rounded),
                    hintText: 'Credit or Debit Amount',
                    labelText: 'Amount*',
                  ),
                  keyboardType: TextInputType.number,
                  validator: ValidateForm.validateAmount,
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: _description,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.description),
                    hintText: 'Description',
                    labelText: 'Description*',
                  ),
                  //maxLength: 50,
                  //maxLines: 2,
                  validator: ValidateForm.validateDescription,
                ),
              ),
              Expanded(
                child: FloatingActionButton(
                  child: Icon(Icons.save),
                  foregroundColor: Colors.white,
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      saveData();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /*
  Save data on firebase realtime storage
   */
  void saveData() {
    //int transType = _mode.index;
    String amount = _amount.text;
    String description = _description.text;
    String uniqueValue = (_unique + 1).toString();
    int amt = int.parse(amount);
    int crd;

    //timestamp for storing into firebase
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    String dateToSave = date.toString();

    if (_typeOfTrans == "Credit") {
      crd = _creditTotal + amt;
    } else if (_typeOfTrans == "Debit") {
      crd = _debitTotal + amt;
    }

    //Mapping data for store into database

    Map<String, String> details = {
      'Amount': amount,
      'Description': description,
      'Date': dateToSave,
      'Transaction': _typeOfTrans,
      'UniqueVal': uniqueValue,
    };

    Map<String, int> calculation = {
      'Total$_typeOfTrans': crd,
      //'TotalDebit': debt,
    };

    Map<String, int> uniqueVal = {
      'UniqueVal': _unique + 1,
    };

    //Save data into firebase
    //here instead of push() method, I am using update() so that I can manage keys for each and every node
    try {
      _ref
          .child("Calculation/Total$_typeOfTrans")
          .update(calculation)
          .then((value) {
        _ref
            .child("CreditDebit")
            .child(uniqueValue)
            .update(details)
            .then((value) {
          _ref.child("UniqueVal").update(uniqueVal).then((value) {
            Navigator.pop(context);
          });
        });
      });
    } catch (error) {
      print(error);
    }
  }

  /*
  Get the stored data for further transaction
   */

  void _getData() {
    _ref.child("Calculation").once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        //Map data = snapshot.value;

        _ref
            .child("Calculation")
            .child("TotalCredit")
            .once()
            .then((DataSnapshot snapshot) {
          if (snapshot.value != null) {
            Map creditData = snapshot.value;
            _creditTotal = creditData['TotalCredit'];
          } else {
            _creditTotal = 0;
          }
        });

        _ref
            .child("Calculation")
            .child("TotalDebit")
            .once()
            .then((DataSnapshot snapshot) {
          if (snapshot.value != null) {
            Map debitData = snapshot.value;
            _debitTotal = debitData['TotalDebit'];
          } else {
            _debitTotal = 0;
          }
        });
      } else {
        _creditTotal = 0;
        _debitTotal = 0;
      }
    });
    _ref.child("UniqueVal").once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        Map data = snapshot.value;
        _unique = data['UniqueVal'];
      } else if (snapshot.value == null) {
        _unique = 0;
      }
    });
  }
}
