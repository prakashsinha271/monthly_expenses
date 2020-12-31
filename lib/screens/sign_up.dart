import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_monthly_budget/models/validate_forms.dart';
import '../main.dart';

class Registration extends StatefulWidget {
  static const routeName = '/sign_up';
  Registration({Key key}) : super(key: key);
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _formKey = GlobalKey<FormState>();
  DatabaseReference _ref;
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController _name,_mobile,_email, _password, _rePassword;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _ref = FirebaseDatabase.instance.reference();
    _name = TextEditingController();
    _mobile = TextEditingController();
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
                  controller: _name,
                  //maxLength: 5,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.drive_file_rename_outline),
                    hintText: 'Enter Your Name',
                    labelText: 'Name*',
                  ),
                  keyboardType: TextInputType.name,
                  validator: ValidateForm.validateRegName,
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: _mobile,
                  //maxLength: 5,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.mobile_friendly_outlined),
                    hintText: 'Enter Mobile Number',
                    labelText: 'Mobile*',
                  ),
                  keyboardType: TextInputType.number,
                  validator: ValidateForm.validateRegName,
                ),
              ),
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
    String _inpName = _name.text;
    String _inpMobile = _mobile.text;
    String _inpMail = _email.text;
    String _inpPass = _password.text;
    debugPrint(_inpPass);
    debugPrint(_inpMail);

    //Authentication Code
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _inpMail, password: _inpPass);
      Map<String, String> uniqueVal = {
        'Email': userCredential.user.email.toString(),
        'Name': _inpName,
        'Mobile': _inpMobile,
      };
      if (userCredential.additionalUserInfo.isNewUser) {
        _ref.child('CreditDebit').child(_inpMobile).update(uniqueVal).then((value) {
          Navigator.pushNamed(context, '/home');
        });
        print(userCredential);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      } else if (e.code == 'invalid-email') {
        print('Invalid email address.');
      }
    } catch (e) {
      print(e);
    }

   }
}
