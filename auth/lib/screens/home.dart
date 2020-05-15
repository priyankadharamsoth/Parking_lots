import 'package:auth/services/geolocator_service.dart';
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
        ],
      ),
    );
  }
}
