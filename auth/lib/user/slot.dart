import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

enum _State { noneSelected, dateSelected, startTimeSelceted, durationSelected }

class SlotScreen extends StatefulWidget {
  final DocumentSnapshot slotDoc;
  SlotScreen({@required this.slotDoc});

  @override
  _SlotScreenState createState() => _SlotScreenState();
}

class _SlotScreenState extends State<SlotScreen> {
  bool _isLoading = false;
  DateTime _bookingDate;
  QuerySnapshot history;
  _State _state = _State.noneSelected;
  int _startTime;
  int _duration;

  List<int> possibleDurationList;
  Map<int, int> possibleHourMap;
  int get startTime => _startTime;
  int get duration => _duration;

  set startTime(int value) {
    _startTime = value;
    _state = _State.startTimeSelceted;
    calculatePossibleRemainingDuration();
  }

  set duration(int value) {
    _duration = value;
    setState(() {
      _state = _State.durationSelected;
    });
  }

  set bookingDate(DateTime date) {
    _bookingDate = date;
    history = null;
    if (date != null) {
      getHistory(date);
    }
  }

  void calculatePossibleRemainingDuration() {
    // calculate the remaining time
    int possibleDuration = 24 - startTime;
    for (DocumentSnapshot doc in history.documents) {
      DateTime orderStartTime = doc.data['starttime'].toDate();
      if (startTime > orderStartTime.hour) continue;
      if (possibleDuration > (orderStartTime.hour - startTime))
        possibleDuration = orderStartTime.hour - startTime;
    }
    possibleDurationList.clear();
    for (var i = 1; i <= possibleDuration; i++) {
      possibleDurationList.add(i);
    }
    setState(() {});
  }

  void getHistory(DateTime date) async {
    setState(() {
      _isLoading = true;
    });

    // get the history of slot
    history = await widget.slotDoc.reference
        .collection('history')
        .where('starttime', isGreaterThanOrEqualTo: date)
        .where('starttime', isLessThanOrEqualTo: date.add(Duration(days: 1)))
        .orderBy('starttime')
        .getDocuments();

    // calculate possible hours
    possibleHourMap.clear();
    for (var i = 0; i < 24; i++) {
      possibleHourMap[i] = i;
    }
    for (DocumentSnapshot doc in history.documents) {
      DateTime orderStartTime = doc.data['starttime'].toDate();
      // remove the start time from the possible hours
      int orderDuration = doc.data['duration'] - 1;
      while (orderDuration >= 0) {
        possibleHourMap.remove(orderStartTime.hour + orderDuration);
        orderDuration--;
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _bookingDate = DateTime.now();
    possibleDurationList = List<int>();
    for (var i = 1; i < 24; i++) {
      possibleDurationList.add(i);
    }
    possibleHourMap = Map<int, int>();
  }

  Widget _buildDatePicker() {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Pick date: '),
          Text('${_bookingDate.year}/${_bookingDate.month}/${_bookingDate.day}')
        ],
      ),
      trailing: Icon(Icons.keyboard_arrow_down),
      onTap: _pickDate,
    );
  }

  Widget _buildTimePicker() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      width: MediaQuery.of(context).size.width * .85,
      height: 250,
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: 35,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Text('Pick Time'),
          ),

          // time picker
          Expanded(
            child: ListView.builder(
              itemCount: possibleHourMap.length,
              itemBuilder: (BuildContext context, int index) {
                return RadioListTile(
                  value: possibleHourMap.values.elementAt(index),
                  groupValue: startTime,
                  onChanged: (value) {
                    setState(() {
                      _state = _State.startTimeSelceted;
                      startTime = value;
                    });
                  },
                  title: possibleHourMap.values.elementAt(index) > 12
                      ? Text((possibleHourMap.values.elementAt(index) - 12)
                              .toString() +
                          ' PM')
                      : Text(
                          possibleHourMap.values.elementAt(index).toString() +
                              ' AM'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationPicker() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      margin: EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          // text
          Container(
            width: double.infinity,
            height: 35,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              color: Colors.blue,
            ),
            child: Text('Pick Duration in hours'),
          ),
          // duration picker
          Container(
            child: DropdownButton<int>(
              items: possibleDurationList
                  .map(
                    (int value) => DropdownMenuItem<int>(
                      value: value,
                      child: Text(value.toString()),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                duration = value;
              },
              value: duration,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return RaisedButton(
      onPressed: () async {
        setState(() {
          _isLoading = true;
        });

        // get the current user
        FirebaseUser user = await FirebaseAuth.instance.currentUser();

        // book the slot
        Map<String, dynamic> data = {
          'starttime': DateTime.parse(_bookingDate.toIso8601String())
              .add(Duration(hours: startTime)),
          'duration': duration,
          'user': user.uid,
        };

        await widget.slotDoc.reference.collection('history').add(data);
        setState(() {
          _isLoading = false;
        });

        Map<String, dynamic> notificationData = {
          'time': DateTime.parse(_bookingDate.toIso8601String())
              .add(Duration(hours: startTime)),
          'message': 'Your slot is booked successfully',
          'title': 'Booked',
        };

        // add the same to notification
        await Firestore.instance
            .collection('Users')
            .document(user.uid)
            .collection('notifications')
            .add(notificationData);

        Navigator.of(context).pop();
      },
      child: Text('book'),
    );
  }

  List<Widget> _buildContents() {
    if (_state == _State.noneSelected)
      return [
        _buildDatePicker(),
      ];
    if (_state == _State.dateSelected)
      return [_buildDatePicker(), _buildTimePicker()];
    if (_state == _State.startTimeSelceted)
      return [_buildDatePicker(), _buildTimePicker(), _buildDurationPicker()];
    return [
      _buildDatePicker(),
      _buildTimePicker(),
      _buildDurationPicker(),
      _buildSubmitButton()
    ];
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('booking of slot ${widget.slotDoc.data['number']}',
            style: GoogleFonts.lobster(color: Colors.black, fontSize: 25.0)),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: _buildContents(),
                ),
              ),
            ),
    );
  }

  _pickDate() async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        Duration(days: 14),
      ),
      initialDate: _bookingDate,
      selectableDayPredicate: (DateTime day) {
        return true;
      },
    );
    if (date != null) {
      bookingDate = date;
      setState(() {
        _state = _State.dateSelected;
      });
    }
  }
}
