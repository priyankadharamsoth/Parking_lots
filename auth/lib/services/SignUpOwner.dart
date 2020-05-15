//import 'package:auth/screens/home.dart';
import 'package:auth/services/database.dart';
import 'package:auth/services/signIn.dart';
import 'package:auth/services/signInOwner.dart';
import 'package:auth/shared/constants.dart';
//import 'package:firebase/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpOwnerPage extends StatefulWidget {
  @override
  _SignUpOwnerState createState() => _SignUpOwnerState();
}

class _SignUpOwnerState extends State<SignUpOwnerPage> {
  String _email, _password, _latitude, _longitude, _apartmentname, _location;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('signUp'),
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
                  //implement fields
                  TextFormField(
                    onSaved: (input) => _email = input,
                    validator: (input) {
                      if (input.isEmpty) return 'please type valid email';
                    },
                    decoration:
                        textInputDecoration.copyWith(labelText: 'email'),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    onSaved: (input) => _password = input,
                    validator: (input) {
                      if (input.length < 6) return 'enter atlast 6 letters';
                    },
                    decoration:
                        textInputDecoration.copyWith(labelText: 'password'),
                    obscureText: true,
                  ),
                  SizedBox(height: 20.0),
                  SizedBox(height: 20.0),

                  
                  TextFormField(
                  onSaved: (input) => _apartmentname = input,
                  validator: (input) {
                    if (input.isEmpty)
                      return 'please type name of your apartment';
                  },
                  decoration:
                      textInputDecoration.copyWith(labelText: 'apartmentname'),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  onSaved: (input) => _latitude = input,
                  validator: (input) {
                    if (input.isEmpty) return 'please type latitude';
                  },
                  decoration:
                      textInputDecoration.copyWith(labelText: 'latitude'),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  onSaved: (input) => _longitude = input,
                  validator: (input) {
                    if (input.isEmpty) return 'please type longitude';
                  },
                  decoration:
                      textInputDecoration.copyWith(labelText: 'longitude'),
                ),
                RaisedButton(
                    onPressed: SignUp,
                    child: Text('SignUp'),
                    color: Colors.orange,
                  ),
                  Row(
                    children: <Widget>[
                      Text('already registerd?'),
                      SizedBox(width: 20.0),
                      FlatButton(
                        onPressed: navigateToLoginPage,
                        child: Text(
                          'Login',
                          style: TextStyle(
                              color: Colors.orange[400], fontSize: 18.0),
                        ),
                        color: Colors.orange[50],
                      ),
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }

  navigateToLoginPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  Future<void> SignUp() async {
    final formState = _formkey.currentState;
    if (formState.validate()) {
      //login to firebase
      formState.save();
      try {
        FirebaseUser user =(await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _email, password: _password)).user;
            //create a new document for the user with the uid
            DataBaseService(uid:user.uid).updateOwnerData('new Apartment',0 , 0);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      } catch (e) {
        print(e.message);
        
      }
    }
  }
}