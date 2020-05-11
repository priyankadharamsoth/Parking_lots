import 'package:auth/screens/home.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email, _password;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('signIn'),
        ),
        body: Form(
            key: _formkey,
            child: Column(
              children: <Widget>[
                //implement fields
                TextFormField(
                  onSaved: (input) => _email = input,
                  validator: (input) {
                    if (input.isEmpty) 
                    return 'please type valid email';
                  },
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                TextFormField(
                  onSaved: (input) => _password = input,
                  validator: (input) {
                    if (input.length<6) 
                    return 'enter atlast 6 letters';
                  },
                  decoration: InputDecoration(
                    labelText: 'password',
                  ),
                  obscureText: true,
                ),
                RaisedButton(
                  onPressed: signIn,
                  child:Text('SignIn'),
                  color:Colors.blue,
                  
                  )
              ],
            )
          )
        );
  }
  Future <void> signIn() async {
    final formState =_formkey.currentState;
    if (formState.validate()){
     //login to firebase
     formState.save();
     try{
     FirebaseUser user = (await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password)).user;
     //navigate to home
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
      }
      catch(e){
      print(e.message);

      }
     }
    }
  }

