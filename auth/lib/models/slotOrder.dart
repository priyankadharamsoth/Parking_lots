import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SlotOrder {
  String customerId;
  DateTime bookedDate;
  TimeOfDay startTime;
  Duration duration;

  SlotOrder(
      {@required this.customerId,
      @required this.startTime,
      @required this.duration});

  SlotOrder.fromFirestore(Map<String, dynamic> mapData) {
    this.customerId = mapData['user'];
    // get the start time
    this.bookedDate = mapData['starttime'].toDate();
    this.startTime = TimeOfDay.fromDateTime(bookedDate);
    this.duration = Duration(hours: mapData['duration']);
  }
}
