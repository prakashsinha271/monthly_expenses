import 'package:flutter/material.dart';
import 'package:flutter_monthly_budget/screens/sign_up.dart';

import '../main.dart';
import 'home.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _email, _password;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login $myTitle"),
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
                child: TextFormField(
                  controller: _email,
                  //maxLength: 5,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person_pin_sharp),
                    hintText: 'Enter Registered Email Address',
                    labelText: 'Email*',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  //validator: ValidateForm.validateAmount,
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: _password,
                  obscureText: true,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.lock),
                    hintText: 'Password',
                    labelText: 'Password*',
                  ),
                  //maxLength: 50,
                  //maxLines: 2,
                  //validator: ValidateForm.validateDescription,
                ),
              ),
              Expanded(
                child: Row(
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FloatingActionButton(
                        child: Icon(Icons.login_outlined),
                        foregroundColor: Colors.white,
                        tooltip: "Login to Home Page",
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            verifyCredential();
                          }
                        },
                      ),
                      SizedBox(width: 20),
                      IconButton(
                        icon: Icon(Icons.person_add),
                        iconSize: 50,
                        color: Colors.blue,
                        tooltip: "New User Registration",
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      Registration()));
                        },
                      ),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void verifyCredential() {
    //if verified return 1
    Navigator.push(
        context, MaterialPageRoute(builder: (BuildContext context) => Home()));
  }
}
