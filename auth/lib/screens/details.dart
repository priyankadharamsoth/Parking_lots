import 'package:auth/shared/constants.dart';
import 'package:flutter/material.dart';

class Details extends StatefulWidget {
  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  String _latitude, _longitude, _apartmentname, _location;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Apartment Details'),
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
                SizedBox(height:10.0),
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
                SizedBox(height:10.0),
                RaisedButton(onPressed: (){},
                child:Text('submit'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
