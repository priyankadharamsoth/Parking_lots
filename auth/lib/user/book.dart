import 'package:flutter/material.dart';

class Book extends StatefulWidget {
  @override
  _BookState createState() => _BookState();
}

class _BookState extends State<Book> {
  TimeOfDay starttime;
  TimeOfDay endtime;
  DateTime _dateTime;

  @override
  void initState() {
    super.initState();
    _dateTime = DateTime.now();
    starttime = TimeOfDay.now();
    endtime = TimeOfDay.now();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('booking')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ListTile(
              title: Text(
                  'start date:${_dateTime.year},${_dateTime.month},${_dateTime.day}'),
              trailing: Icon(Icons.keyboard_arrow_down),
              onTap: _pickDate,
            ),
            ListTile(
              title: Text('start time:${starttime.hour}:${starttime.minute}'),
              trailing: Icon(Icons.keyboard_arrow_down),
              onTap: _pickTime,
            ),
            ListTile(
              title: Text('end time:${endtime.hour}:${endtime.minute}'),
              trailing: Icon(Icons.keyboard_arrow_down),
              onTap: _picktime,
            ),
            RaisedButton(
              onPressed: () {},
              child: Text('book'),
            )
          ],
        ),
      ),
    );
  }

  _pickTime() async {
    TimeOfDay t =
        await showTimePicker(context: context, initialTime: starttime);
    if (t != null) {
      setState(() {
        starttime = t;
      });
    }
  }

  _picktime() async {
    TimeOfDay t1 = await showTimePicker(
      context: context,
      initialTime: endtime,
    );
    if (t1 != null) {
      setState(() {
        endtime = t1;
      });
    }
  }

  _pickDate() async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year + 1),
      initialDate: _dateTime,
    );
    if (date != null) {
      setState(() {
        _dateTime = date;
      });
    }
  }
}
