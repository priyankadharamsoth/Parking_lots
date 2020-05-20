import 'package:auth/screens/signIn.dart';
import 'package:auth/shared/constants.dart';
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
                    return null;
                  },
                  decoration: textInputDecoration.copyWith(
                              labelText: 'email'),
                ),
                SizedBox(height:20.0),
                TextFormField(
                  onSaved: (input) => _password = input,
                  validator: (input) {
                    if (input.length < 6) return 'enter atlast 6 letters';
                    return null;
                  },
                  decoration: textInputDecoration.copyWith(
                              labelText: 'password'),
                  obscureText: true,
                ),
                SizedBox(height:20.0),
                TextFormField(
                  onSaved: (input) => _vehicleNum = input,
                  validator: (input) {
                    if (input.isEmpty) return 'please type your vehicle num';
                    return null;
                  },
                  decoration:textInputDecoration.copyWith(
                              labelText: 'vehicle number'),
                ),
                SizedBox(height:20.0),
                TextFormField(
                  onSaved: (input) => _role = input,
                  validator: (input) {
                    if (input.isEmpty)
                      return 'please type either user or owner';
                    return null;
                  },
                  decoration: textInputDecoration.copyWith(
                              labelText: 'user/owner'),
                ),
                SizedBox(
                  height: 20.0,
                ),
                RaisedButton(
                  onPressed: signUp,
                  child: Text('Register'),
                  color: Colors.orange,
                ),
                Row(
                  children: <Widget>[
                    Text('already registerd?',style:TextStyle(fontSize: 15.0)),
                    SizedBox(width: 15.0),
                    FlatButton(
                      onPressed: navigateToLoginpage,
                      child: Text('Login',style: TextStyle(color:Colors.orange[400],fontSize: 18.0),),
                    
                      color: Colors.orange[50],
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
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password);
        FirebaseAuth.instance.signOut();
            
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      } catch (e) {
        print(e.message);
      }
    }
  }
}
