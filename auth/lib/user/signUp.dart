import 'package:auth/shared/constants.dart';
import 'package:auth/user/signIn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUpPage> {
  bool _isLoading = false;
  String _email, _password, _vehicleNum, _username, _phonenum;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SignUp',
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
                      //implement fields
                      TextFormField(
                        onSaved: (input) => _username = input,
                        validator: (input) {
                          if (input.isEmpty) return 'please type your name';
                          return null;
                        },
                        decoration:
                            textInputDecoration.copyWith(labelText: 'Username'),
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        onSaved: (input) => _email = input,
                        validator: (input) {
                          if (input.isEmpty) return 'please type valid email';
                          return null;
                        },
                        decoration:
                            textInputDecoration.copyWith(labelText: 'email'),
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        onSaved: (input) => _password = input,
                        validator: (input) {
                          if (input.length < 6)
                            return 'enter atleast 6 letters';
                          return null;
                        },
                        decoration:
                            textInputDecoration.copyWith(labelText: 'password'),
                        obscureText: true,
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        onSaved: (input) => _phonenum = input,
                        keyboardType: TextInputType.number,
                        validator: (input) {
                          if (input.length < 10) return 'enter valid phone num';
                          return null;
                        },
                        decoration:
                            textInputDecoration.copyWith(labelText: 'Phonenum'),
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        onSaved: (input) => _vehicleNum = input,
                        validator: (input) {
                          if (input.isEmpty)
                            return 'please type your vehicle num';
                          return null;
                        },
                        decoration: textInputDecoration.copyWith(
                            labelText: 'vehicle number'),
                      ),
                      SizedBox(height: 20.0),
                      RaisedButton(
                        onPressed: signUp,
                        child: Text('Register'),
                        color: Colors.teal,
                      ),
                      Row(
                        children: <Widget>[
                          Text('already registerd?',
                              style: TextStyle(fontSize: 15.0)),
                          SizedBox(width: 15.0),
                          FlatButton(
                            onPressed: navigateToLoginpage,
                            child: Text(
                              'Login',
                              style:
                                  TextStyle(color: Colors.teal, fontSize: 18.0),
                            ),
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  navigateToLoginpage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  Future<void> signUp() async {
    final formState = _formkey.currentState;
    if (formState.validate()) {
      //login to firebase
      formState.save();
      try {
        setState(() {
          _isLoading = true;
        });
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password);
        FirebaseUser user = await FirebaseAuth.instance.currentUser();

        Map<String, dynamic> mapData = Map<String, dynamic>();
        mapData['username'] = _username;
        mapData['email'] = _email;
        mapData['vechile'] = _vehicleNum;
        mapData['phonenum'] = _phonenum;
        await Firestore.instance
            .collection('Users')
            .document(user.uid)
            .setData(mapData);

        FirebaseAuth.instance.signOut();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      } catch (e) {
        print(e.message);
      }
      setState(() {
        _isLoading = true;
      });
    }
  }
}
