import 'package:auth/services/geolocator_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Position position;

  void getCurrentLocation() async {
    // GeoLocatorService geolocator = GeoLocatorService();
    // position = await geolocator.getLocation();

    position = await GeoLocatorService.getLocation();
    setState(() {});
    return;
  }

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Parking Lots'), centerTitle: true),
      body: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width,
            child: position == null
                ? Center(child: CircularProgressIndicator())
                : GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(position.latitude, position.longitude),
                      zoom: 16.0,
                    ),
                    zoomGesturesEnabled: true,
                  ),
          ),
          SizedBox(height: 20.0),
          Expanded(
              child: StreamBuilder(
            stream: Firestore.instance.collection('Places').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) => Card(
                  child: ListTile(
                    title: Text(snapshot.data.documents[index]['apartmentname']),
                  ),
                ),
              );
            },
          )),
        ],
      ),
    );
  }
}
