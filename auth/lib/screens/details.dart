import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Details extends StatefulWidget {
  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
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
              stream: Firestore.instance.collection('Places').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());
                return ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (BuildContext context, int index) => Card(
                          child: ListTile(
                            title:
                                Text(snapshot.data.documents[index]['slots']),
                            trailing: RaisedButton(
                                onPressed: () {},
                                child: Text('Book',
                                    style: TextStyle(color: Colors.white)),
                                color: Colors.green),
                          ),
                        ));
              },
            ),
          ),
        ],
      ),
    );
  }
}
