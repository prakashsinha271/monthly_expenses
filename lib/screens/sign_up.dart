import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_monthly_budget/models/validate_forms.dart';

import '../main.dart';
import 'home.dart';

class Registration extends StatefulWidget {
  Registration({Key key}) : super(key: key);
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _email, _password, _rePassword;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Firebase.initializeApp();
   // initializeApln();
    _email = TextEditingController();
    _password = TextEditingController();
    _rePassword = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registration $myTitle"),
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
                    hintText: 'Enter Valid Email Address',
                    labelText: 'Email*',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: ValidateForm.validateRegEmail,
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
                  validator: ValidateForm.validateRegPassword,
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: _rePassword,
                  obscureText: true,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.lock),
                    hintText: 'Retype Password',
                    labelText: 'Password*',
                  ),
                  //maxLength: 50,
                  //maxLines: 2,
                  validator: (String value) {
                    if (value != _password.text) {
                      return 'Password does not match';
                    }
                    return null;
                  },
                ),
              ),
              Expanded(
                child: FloatingActionButton(
                  child: Icon(Icons.add),
                  foregroundColor: Colors.white,
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      registerUser();
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

  void registerUser() async {
    String inpEmail = _email.text;
    String inpPass = _password.text;
    await Firebase.initializeApp();
    //String confPass = _rePassword.text;
    //if verified return 1
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: inpEmail,
          password: inpPass
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
   }

    void initializeApln() async {
      await Firebase.initializeApp();
    }
}
