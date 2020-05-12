import 'package:auth/services/signIn.dart';
import 'package:auth/services/signUp.dart';
import 'package:flutter/material.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      appBar: AppBar(title:Text('Welcome'),centerTitle: true,
      ),
      body:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          RaisedButton(
            color:Colors.blue,
            onPressed:navigateToSignIn,
            child:Text('SignIn'),
          ),
          RaisedButton(
            color:Colors.blue,
            onPressed:navigateToSignUp,
            child:Text('SignUp'),
          )
        ],
      ) 
    );
  }
  void navigateToSignIn(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage(),fullscreenDialog: true));
  }
  void navigateToSignUp(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpPage()));
  }
}