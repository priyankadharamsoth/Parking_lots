//import 'package:auth/screens/home.dart';
import 'package:auth/services/signIn.dart';
//import 'package:firebase/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUpPage> {
  String _email, _password, _vehicleNum, _role;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('signUp'),
        ),
        body: Form(
            key: _formkey,
            child: Column(
              children: <Widget>[
                //implement fields
                TextFormField(
                  onSaved: (input) => _email = input,
                  validator: (input) {
                    if (input.isEmpty) return 'please type valid email';
                  },
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                TextFormField(
                  onSaved: (input) => _password = input,
                  validator: (input) {
                    if (input.length < 6) return 'enter atlast 6 letters';
                  },
                  decoration: InputDecoration(
                    labelText: 'password',
                  ),
                  obscureText: true,
                ),
                TextFormField(
                  onSaved: (input) => _vehicleNum = input,
                  validator: (input) {
                    if (input.isEmpty) return 'please type your vehicle num';
                  },
                  decoration: InputDecoration(
                    labelText: 'vehicle num',
                  ),
                ),
                TextFormField(
                  onSaved: (input) => _role = input,
                  validator: (input) {
                    if (input.isEmpty)
                      return 'please type either user or owner';
                  },
                  decoration: InputDecoration(
                    labelText: 'user/owner',
                  ),
                ),
                RaisedButton(
                  onPressed: SignUp,
                  child: Text('SignUp'),
                  color: Colors.blue,
                )
              ],
            )));
  }

  Future<void> SignUp() async {
    final formState = _formkey.currentState;
    if (formState.validate()) {
      //login to firebase
      formState.save();
      try {
        FirebaseUser user = (await FirebaseAuth.instance
                .createUserWithEmailAndPassword(
                    email: _email, password: _password))
            .user;
        user.sendEmailVerification();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      } catch (e) {
        print(e.message);
      }
    }
  }
}
