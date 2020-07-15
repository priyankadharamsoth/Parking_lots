import 'package:auth/shared/constants.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeOwner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add slots',
            style: TextStyle(
                fontFamily: 'Lobster', color: Colors.black, fontSize: 25.0)),
        centerTitle: true,
      ),
      body: Fields(),
    );
  }
}

class Fields extends StatefulWidget {
  Fields({Key key}) : super(key: key);

  @override
  _FieldsState createState() => _FieldsState();
}

class _FieldsState extends State<Fields> {
  int _slots;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  // fireauth instance
  final FirebaseAuth auth = FirebaseAuth.instance;

  bool _isLoading = false;
  DocumentSnapshot userdoc;

  void getUserdata() async {
    // set the loading to true
    setState(() {
      _isLoading = true;
    });
    final FirebaseUser user = await auth.currentUser();
    userdoc =
        await Firestore.instance.collection('Places').document(user.uid).get();

    // set the loading to false
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    getUserdata();
    super.initState();
  }

  Future<void> addSlots(int noOfSlots) async {
    WriteBatch batch = Firestore.instance.batch();

    // create a new slots in the slots collection of the appartment doc
    Map<String, dynamic> defaultData = {
      'availability': true,
      'currentUser': null,
      'number': userdoc.data['slots'],
      'slotBookedTime': null,
      'status': 'active', // possible values [active, inactive]
    };

    for (int i = 0; i < noOfSlots; i++) {
      defaultData['number']++;
      batch.setData(
          userdoc.reference.collection('slots').document(), defaultData);
    }

    await batch.commit();

    // update the apartment document with increment of no of slots
    await userdoc.reference
        .updateData({'slots': userdoc.data['slots'] + noOfSlots});
    userdoc = await userdoc.reference.get();

    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Successfully added slots')));
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Center(
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 40.0),

                  //implement fields
                  Container(
                    width: MediaQuery.of(context).size.width * .75,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      onSaved: (input) => _slots = int.parse(input),
                      validator: (input) {
                        if (input.isEmpty)
                          return 'please add no.of slots to add';
                        return null;
                      },
                      decoration:
                          textInputDecoration.copyWith(labelText: 'slots'),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  RaisedButton(
                    onPressed: validateAndSubmit,
                    child: Text('Add', style: TextStyle(color: Colors.white)),
                    color: Colors.teal,
                  ),
                ],
              ),
            ),
          );
  }

  void validateAndSubmit() async {
    FormState state = _formkey.currentState;
    if (state.validate()) {
      state.save();
      setState(() {
        _isLoading = true;
      });

      await addSlots(_slots);

      setState(() {
        _isLoading = false;
      });
    }
  }
}
