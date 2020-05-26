import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Disable extends StatefulWidget {
  final String apartment;
  Disable({@required this.apartment});

  @override
  _DisableState createState() => _DisableState();
}

class _DisableState extends State<Disable> {
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
                  .document(widget.apartment)
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

                      trailing:(snapshot.data.documents[index]['availability'])? RaisedButton(
                          onPressed: () {},
                          child: Text('Enable',
                              style: TextStyle(color: Colors.white)),
                          color: Colors.green)
                          :RaisedButton(
                          onPressed: () {},
                          child: Text('Disable',
                              style: TextStyle(color: Colors.white)),
                          color: Colors.red)
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
}

      
  