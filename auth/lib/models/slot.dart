import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Slot {
  bool availability;
  int number;
  DocumentReference slotRef;

  Slot(
      {@required this.availability,
      @required this.number,
      @required this.slotRef});

  Slot.fromFirestore(Map<String, dynamic> mapData, DocumentReference docRef)
      : availability = mapData['availability'],
        number = mapData['number'],
        slotRef = docRef;
}
