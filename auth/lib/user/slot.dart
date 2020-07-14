import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SlotScreen extends StatefulWidget {
  final DocumentSnapshot slotDoc;
  SlotScreen({@required this.slotDoc});

  @override
  _SlotScreenState createState() => _SlotScreenState();
}

class _SlotScreenState extends State<SlotScreen> {
  bool _isLoading = false;
  TimeOfDay _starttime;
  TimeOfDay _endtime;
  DateTime _bookingDate;
  QuerySnapshot history;

  void getHistory() async {
    setState(() {
      _isLoading = true;
    });

    // get the history of slot
    history =
        await widget.slotDoc.reference.collection('history').getDocuments();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _bookingDate = DateTime.now();
    _starttime = TimeOfDay.now();
    _endtime = TimeOfDay.now();
    getHistory();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('booking of slot ${widget.slotDoc.data['number']}')),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Pick date: '),
                        Text(
                            '${_bookingDate.year}/${_bookingDate.month}/${_bookingDate.day}')
                      ],
                    ),
                    trailing: Icon(Icons.keyboard_arrow_down),
                    onTap: _pickDate,
                  ),
                  ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Start time: '),
                        Text('${_starttime.hour}:${_starttime.minute}'),
                      ],
                    ),
                    trailing: Icon(Icons.keyboard_arrow_down),
                    onTap: _pickTime,
                  ),
                  ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('end time: '),
                        Text('${_endtime.hour}:${_endtime.minute}'),
                      ],
                    ),
                    trailing: Icon(Icons.keyboard_arrow_down),
                    onTap: _picktime,
                  ),
                  RaisedButton(
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });

                      // get the current user
                      FirebaseUser user =
                          await FirebaseAuth.instance.currentUser();

                      // book the slot
                      Map<String, dynamic> data = {
                        'booked date': _bookingDate,
                        'start time': DateTime(
                            _bookingDate.year,
                            _bookingDate.month,
                            _bookingDate.day,
                            _starttime.hour,
                            _starttime.minute),
                        'end time': DateTime(
                            _bookingDate.year,
                            _bookingDate.month,
                            _bookingDate.day,
                            _endtime.hour,
                            _endtime.minute),
                        'user': user.uid,
                      };

                      widget.slotDoc.reference.collection('history').add(data);
                      setState(() {
                        _isLoading = false;
                      });
                    },
                    child: Text('book'),
                  )
                ],
              ),
            ),
    );
  }

  _pickTime() async {
    TimeOfDay t = await showTimePicker(
      context: context,
      initialTime: _starttime,
    );
    if (t != null) {
      setState(() {
        _starttime = t;
      });
    }
  }

  _picktime() async {
    TimeOfDay t1 = await showTimePicker(
      context: context,
      initialTime: _endtime,
    );
    if (t1 != null) {
      setState(() {
        _endtime = t1;
      });
    }
  }

  _pickDate() async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 14)),
      initialDate: _bookingDate,
    );
    if (date != null) {
      setState(() {
        _bookingDate = date;
      });
    }
  }
}
