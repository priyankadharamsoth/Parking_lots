import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:auth/user/slot.dart';

class Slots extends StatefulWidget {
  final String apartmentID;

  // default constructor
  Slots({@required this.apartmentID});

  @override
  _SlotsState createState() => _SlotsState();
}

class _SlotsState extends State<Slots> {
  _SlotsState();
  bool i;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Slots'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder(
              stream: Firestore.instance
                  .collection('Places')
                  .document(widget.apartmentID)
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
                      onTap: () {
                        if (snapshot.data.documents[index]['availability']) {
                          navigateToBookingPage(snapshot.data.documents[index]);
                        }
                      },
                      trailing: (snapshot.data.documents[index]['availability'])
                          ? Text('Available')
                          : Text(
                              'Unavailable',
                              style: TextStyle(
                                color: Colors.grey[400],
                              ),
                            ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  navigateToBookingPage(DocumentSnapshot ref) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SlotScreen(
          slotDoc: ref,
        ),
      ),
    );
  }
}
