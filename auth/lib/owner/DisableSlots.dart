import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Disable extends StatefulWidget {
  @override
  _DisableState createState() => _DisableState();
}

class _DisableState extends State<Disable> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Slots'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: <Widget>[
                Expanded(
                  child: StreamBuilder(
                    stream: Firestore.instance
                        .collection('Places')
                        .document(userdoc.documentID)
                        .collection('slots')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData)
                        return Center(child: CircularProgressIndicator());
                      return ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (BuildContext context, int index) => Card(
                          child: ListTile(
                              title: Text(
                                  'slot${snapshot.data.documents[index]['number'].toString()}'),

                              //  (snapshot.data.documents[index]['availability'] == true)

                              trailing: (snapshot.data.documents[index]
                                      ['availability'])
                                  ? RaisedButton(
                                      onPressed: () {},
                                      child: Text('Enable',
                                          style:
                                              TextStyle(color: Colors.white)),
                                      color: Colors.green)
                                  : RaisedButton(
                                      onPressed: () {},
                                      child: Text('Disable',
                                          style:
                                              TextStyle(color: Colors.white)),
                                      color: Colors.red)),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
