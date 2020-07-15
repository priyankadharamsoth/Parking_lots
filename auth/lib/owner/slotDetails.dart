import 'package:auth/models/slot.dart';
import 'package:auth/owner/slotHistory.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SlotDetails extends StatefulWidget {
  const SlotDetails({Key key}) : super(key: key);

  @override
  _SlotDetailsState createState() => _SlotDetailsState();
}

class _SlotDetailsState extends State<SlotDetails> {
  FirebaseUser user;
  bool _isLoading = false;
  List<Slot> slotsList;

  void getCurrentUser() async {
    setState(() {
      _isLoading = true;
    });
    user = await FirebaseAuth.instance.currentUser();
    await getSlots();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> getSlots() async {
    CollectionReference slotsRef = Firestore.instance
        .collection('Places')
        .document(user.uid)
        .collection('slots')
        .reference();
    QuerySnapshot slots = await slotsRef.orderBy('number').getDocuments();
    print(slots.documents.length);
    for (DocumentSnapshot doc in slots.documents) {
      slotsList.add(Slot.fromFirestore(doc.data, doc.reference));
    }
  }

  @override
  void initState() {
    slotsList = List<Slot>();
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Slots',
            style: TextStyle(
                fontFamily: 'Lobster', color: Colors.black, fontSize: 25.0)),
        centerTitle: true,
      ),
      body: _isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              child: ListView.builder(
                itemCount: slotsList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 5,
                            offset: Offset(2, 3))
                      ],
                    ),
                    child: ListTile(
                      leading: Icon(Icons.home),
                      title: Text('slot ' + slotsList[index].number.toString()),
                      onTap: () {
                        // navigate to slot history page
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                SlotHistory(slot: slotsList[index])));
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }
}
