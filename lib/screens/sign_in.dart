import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';
  LoginPage({Key key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController _email, _password;

  @override
  void initState() {
    // TODO: implement initState
    checkStatus();
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
                        tooltip: "Login to your dashboard",
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
                          Navigator.pushNamed(context, '/sign_up');
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

  /*
* This method will check for user's login status
 */
  void checkStatus() {
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      // if (user == null) {
      //   print('User is currently signed out!');
      //   Navigator.pushNamed(context, '/login');
      // } else
      if (user != null){
        Navigator.pushNamed(context, '/home');
      }
    });
  }

  /*
  * This method will verify and login the user into home screen
   */

  void verifyCredential() async{
    String _inpMail = _email.text;
    String _inpPass = _password.text;
    // debugPrint(_inpPass);
    // debugPrint(_inpMail);

    //Login code
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _inpMail, password: _inpPass);
      if (userCredential != null) {
        Navigator.pushNamed(context, '/home');
      }
    } on FirebaseAuthException catch (e) {
      //errorMessage = e.toString();
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      print("Printing error from firebase");
      //print(errorMessage);
    }
  }
}
