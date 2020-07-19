import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessagingWidget extends StatefulWidget {
  @override
  _MessagingWidgetState createState() => _MessagingWidgetState();
}

class _MessagingWidgetState extends State<MessagingWidget> {
  Future<List<DocumentSnapshot>> getNotifications() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var firestore = Firestore.instance;
    QuerySnapshot query = await firestore
        .collection('Users')
        .document(user.uid)
        .collection("notifications")
        .getDocuments();
    return query.documents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: getNotifications(),
        builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                DateTime date = snapshot.data[index].data['time'].toDate();
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.calendar_today),
                    title: Text(snapshot.data[index].data["title"]),
                    subtitle: Text(snapshot.data[index].data["message"]),
                    trailing: Container(
                      width: MediaQuery.of(context).size.width * .15,
                      child: Text(
                        date.day.toString() +
                            '/' +
                            date.month.toString() +
                            '/' +
                            date.year.toString(),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
