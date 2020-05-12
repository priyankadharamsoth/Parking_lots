//import 'package:auth/services/geolocator_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Parking Lots'), centerTitle: true),
      body: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(16.9947, 79.9750),
                zoom: 16.0,
              ),
              zoomGesturesEnabled: true,
            ),
          ),
        ],
      ),
    );
  }
}
