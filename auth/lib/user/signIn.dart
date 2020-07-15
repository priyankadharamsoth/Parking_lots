import 'package:auth/owner/homePage.dart';
import 'package:auth/shared/constants.dart';
import 'package:auth/user/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  String _email, _password;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SignIn',
            style: TextStyle(
                fontFamily: 'Lobster', color: Colors.black, fontSize: 25.0)),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
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
                      SizedBox(height: 10.0),
                      TextFormField(
                        onSaved: (input) => _password = input,
                        validator: (input) {
                          if (input.length < 6) return 'enter atlast 6 letters';
                          return null;
                        },
                        decoration:
                            textInputDecoration.copyWith(labelText: 'password'),
                        obscureText: true,
                      ),

                      SizedBox(height: 20.0),
                      RaisedButton(
                        onPressed: signIn,
                        child: Text('SignIn'),
                        color: Colors.teal,
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Future<void> signIn() async {
    final formState = _formkey.currentState;
    if (formState.validate()) {
      //login to firebase
      formState.save();
      try {
        setState(() {
          _isLoading = true;
        });
        FirebaseUser user = (await FirebaseAuth.instance
                .signInWithEmailAndPassword(email: _email, password: _password))
            .user;

        // check if the user is owner
        DocumentSnapshot userDoc = await Firestore.instance
            .collection('Places')
            .document(user.uid)
            .get();

        // navigate to next page
        if (userDoc.exists) {
          //navigate to owner home page
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        } else {
          // navigate to customer home page
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Home()));
        }
      } catch (e) {
        print(e.message);
      }
      setState(() {
        _isLoading = false;
      });
    }
  }
}
