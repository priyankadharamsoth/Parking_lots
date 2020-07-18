import 'package:auth/models/slot.dart';
import 'package:auth/models/slotOrder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SlotHistory extends StatefulWidget {
  final Slot slot;
  const SlotHistory({Key key, @required this.slot}) : super(key: key);

  @override
  _SlotHistoryState createState() => _SlotHistoryState();
}

class _SlotHistoryState extends State<SlotHistory> {
  bool _isLoading = false;
  List<SlotOrder> slotOrderList = List<SlotOrder>();

  void getHistory() async {
    QuerySnapshot history =
        await widget.slot.slotRef.collection('history').getDocuments();

    slotOrderList.clear();
    for (DocumentSnapshot doc in history.documents) {
      slotOrderList.add(SlotOrder.fromFirestore(doc.data));
    }

    setState(() {});
  }

  @override
  void initState() {
    getHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Slot ${widget.slot.number}',
            style: GoogleFonts.lobster(color: Colors.black, fontSize: 25.0)),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // user column
                  Expanded(
                    child: Column(
                      children: [
                        // user text
                        Container(
                          height: 45,
                          alignment: Alignment.center,
                          color: Colors.blue,
                          child: Text('User'),
                        ),

                        // user names
                        Expanded(
                          child: ListView.builder(
                            itemCount: slotOrderList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return FutureBuilder<DocumentSnapshot>(
                                  future: Firestore.instance
                                      .collection('Users')
                                      .document(slotOrderList[index].customerId)
                                      .get(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<DocumentSnapshot>
                                          snapshot) {
                                    return snapshot.connectionState ==
                                            ConnectionState.done
                                        ? Container(
                                            decoration: BoxDecoration(
                                                border: Border.all()),
                                            alignment: Alignment.center,
                                            height: 45,
                                            child: Text(
                                              snapshot.data.data['username'],
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                        : Container(
                                            child: Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          );
                                  });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // book date
                  Expanded(
                    child: Column(
                      children: [
                        // user text
                        Container(
                          height: 45,
                          alignment: Alignment.center,
                          color: Colors.blue,
                          child: Text('Book Date'),
                        ),

                        // booking dates
                        Expanded(
                          child: ListView.builder(
                            itemCount: slotOrderList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                decoration: BoxDecoration(border: Border.all()),
                                alignment: Alignment.center,
                                height: 45,
                                child: Text(
                                  slotOrderList[index]
                                          .bookedDate
                                          .day
                                          .toString() +
                                      '/' +
                                      slotOrderList[index]
                                          .bookedDate
                                          .month
                                          .toString() +
                                      '/' +
                                      slotOrderList[index]
                                          .bookedDate
                                          .year
                                          .toString(),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // start time
                  Expanded(
                    child: Column(
                      children: [
                        // user text
                        Container(
                          height: 45,
                          alignment: Alignment.center,
                          color: Colors.blue,
                          child: Text('Start time'),
                        ),

                        // start times
                        Expanded(
                          child: ListView.builder(
                            itemCount: slotOrderList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                decoration: BoxDecoration(border: Border.all()),
                                alignment: Alignment.center,
                                height: 45,
                                child: Text(
                                  slotOrderList[index].startTime.hour > 12
                                      ? (slotOrderList[index].startTime.hour -
                                                  12)
                                              .toString() +
                                          ' pm'
                                      : slotOrderList[index]
                                              .startTime
                                              .hour
                                              .toString() +
                                          ' am',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // duration time
                  Expanded(
                    child: Column(
                      children: [
                        // user text
                        Container(
                          height: 45,
                          alignment: Alignment.center,
                          color: Colors.blue,
                          child: Text('Duration'),
                        ),

                        // duration text
                        Expanded(
                          child: ListView.builder(
                            itemCount: slotOrderList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                decoration: BoxDecoration(border: Border.all()),
                                alignment: Alignment.center,
                                height: 45,
                                child: Text(
                                  slotOrderList[index]
                                          .duration
                                          .inHours
                                          .toString() +
                                      ' hours',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
    );
  }
}
