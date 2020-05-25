import 'package:auth/shared/constants.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeOwner extends StatefulWidget {
  @override
  _HomeOwnerState createState() => _HomeOwnerState();
}

class _HomeOwnerState extends State<HomeOwner> {
  int _slots;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  // fireauth instance
  final FirebaseAuth auth = FirebaseAuth.instance;

  bool _isLoading = false;
  DocumentSnapshot userdoc;

  void getUserdata() async {
    final FirebaseUser user = await auth.currentUser();
    userdoc =
        await Firestore.instance.collection('Places').document(user.uid).get();
    setState(() {});
  }

  @override
  void initState() {
    getUserdata();
    super.initState();
  }

  Future<void> addSlot() async {
    // create a new slot in the slots collection of the appartment doc
    await userdoc.reference.collection('slots').add(
      {
        'availability': true,
        'currentUser': null,
        'number': userdoc.data['slots'] + 1,
        'slotBookedTime': null,
        'status': 'active', // possible values [active, inactive]
      },
    );

    // update the apartment document with increment of no of slots
    await userdoc.reference.updateData({'slots': userdoc.data['slots'] + 1});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('details')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: Form(
                key: _formkey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 30.0),
                    //implement fields
                    TextFormField(
                      onSaved: (input) => _slots = int.parse(input),
                      validator: (input) {
                        if (input.isEmpty) return 'please add no.of slots to add';
                        return null;
                      },
                      decoration:
                          textInputDecoration.copyWith(labelText: 'slots'),
                    ),
                    SizedBox(height: 10.0),
                    RaisedButton(
                      onPressed: validateAndSubmit,
                      child: Text('Add'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void validateAndSubmit() async {
    FormState state = _formkey.currentState;
    if (state.validate()) {
      setState(() {
        _isLoading = true;
      });

      for (int i = 0; i < _slots; i++) {
        await addSlot();
      }
    }
  }
}
