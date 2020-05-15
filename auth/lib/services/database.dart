import 'package:cloud_firestore/cloud_firestore.dart';


class DataBaseService{
  final String uid;
  DataBaseService({this.uid});

final CollectionReference placesCollection = Firestore.instance.collection('apartmentName');
Future updateOwnerData(String apartmentName,int latitude, int longitude) async{
  return await placesCollection.document(uid).setData({
   'apartmentname': apartmentName,
   'latitude': latitude,
   'longitude':longitude,
  });

}

}