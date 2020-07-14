
import 'package:auth/owner/SignUpOwner.dart';
import 'package:auth/user/signUp.dart';
import 'package:flutter/material.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Welcome',style:TextStyle(fontFamily: 'Lobster',color:Colors.black,fontSize: 25.0)),
        centerTitle: true,
        
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          RaisedButton(
            color: Colors.teal,
            onPressed: navigateToSignIn,
            child: Text('User'),
          ),
          RaisedButton(
            color: Colors.teal,
            onPressed: navigateToSignUp,
            child: Text('Owner'),
          ),
          
        ],

      ),
    );
  }

  void navigateToSignIn() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SignUpPage(), fullscreenDialog: true));
  }

  void navigateToSignUp() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignUpOwnerPage()));
  }
}
