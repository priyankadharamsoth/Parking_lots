import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseService {
  final String uid;
  DataBaseService({this.uid});

  final CollectionReference placesCollection =
      Firestore.instance.collection('Places');
  Future updateOwnerData(
      String apartmentName, String latitude, String longitude,int slots,String role) async {
    return await placesCollection.document(uid).setData({
      'apartmentname': apartmentName,
      'latitude': latitude,
      'longitude': longitude,
      'slots':slots,
      'role' : role,
    },);
  }
  
}


