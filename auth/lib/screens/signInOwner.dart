import 'package:auth/screens/details.dart';
//import 'package:auth/screens/home.dart';
import 'package:auth/shared/constants.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

class Loginpage extends StatefulWidget {
  @override
  _LoginpageState createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  String _email, _password;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.orange[50],
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Text('signIn'),
        ),
        body: Container(
            width: double.infinity,
            child: Padding(
                padding: EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  top: 5.0,
                  bottom: 5.0,
                ),
                child: Form(
                    key: _formkey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 30.0),
                        //implement fields
                        TextFormField(
                          onSaved: (input) => _email = input,
                          validator: (input) {
                            if (input.isEmpty) return 'please type valid email';
                            return null;
                          },
                          decoration:
                              textInputDecoration.copyWith(labelText: 'email'),
                        ),
                        SizedBox(height:10.0),
                        TextFormField(
                          onSaved: (input) => _password = input,
                          validator: (input) {
                            if (input.length < 6)
                              return 'enter atlast 6 letters';
                            return null;
                          },
                          decoration: textInputDecoration.copyWith(
                              labelText: 'password'),
                          obscureText: true,
                        ),

                        SizedBox(height: 20.0),
                        RaisedButton(
                          onPressed: signIn,
                          child: Text('SignIn'),
                          color: Colors.orange,
                        )
                      ],
                    )))));
  }

  Future<void> signIn() async {
    final formState = _formkey.currentState;
    if (formState.validate()) {
      //login to firebase
      formState.save();
      try {
        FirebaseUser user = (await FirebaseAuth.instance
                .signInWithEmailAndPassword(email: _email, password: _password))
            .user;
        //navigate to home

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Details()));
      } catch (e) {
        print(e.message);
      }
    }
  }
}
