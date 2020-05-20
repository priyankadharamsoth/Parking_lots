import 'package:auth/services/geolocator_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Position position;
  GoogleMapController mapController;
  List<Marker> allMarkers=[]; 
 // final  BitmapDescriptor customIcon;
 
  void getCurrentLocation() async {
    position = await GeoLocatorService.getLocation();
    setState(() {});
    return;
  }

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
    allMarkers.add(Marker(
      markerId: MarkerId('mymarker'),
      draggable:false,
      position:LatLng(16.9947,79.9750),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final geoService = GeoLocatorService();
    return Scaffold(
      appBar: AppBar(
        title: Text('Parking Lots'),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: position == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height / 3,
                  width: MediaQuery.of(context).size.width,
                  child: GoogleMap(
                    onMapCreated: (GoogleMapController controller) {
                      mapController = controller;
                    },
                    initialCameraPosition: CameraPosition(
                      target: LatLng(position.latitude, position.longitude),
                      zoom: 16.0,
                    ),
                    markers: Set.from(allMarkers),
                    zoomGesturesEnabled: true,
                  ),
                ),
                SizedBox(height: 20.0),
                Expanded(
                    child: StreamBuilder(
                  stream: Firestore.instance.collection('Places').snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData)
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    return ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (BuildContext context, int index) =>
                          FutureProvider(
                        create: (context) => geoService.getDistance(
                          position.latitude,
                          position.longitude,
                          double.parse(
                            snapshot.data.documents[index]['latitude'],
                          ),
                          double.parse(
                            snapshot.data.documents[index]['longitude'],
                          ),
                        ),
                        child: Card(
                          child: Consumer<double>(
                              builder: (context, meters, widget) {
                            return (meters != null)
                                ? (meters < 1000.0)
                                    ? ListTile(
                                        title: Text(snapshot.data
                                            .documents[index]['apartmentname']),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text('dist:${(meters.round())}mts')
                                          ],
                                        ),
                                        trailing: IconButton(
                                          icon: Icon(Icons.directions),
                                          color: Colors.orange,
                                          onPressed: () {
                                            _launchMapsUrl(
                                              double.parse(
                                                snapshot.data.documents[index]
                                                    ['latitude'],
                                              ),
                                              double.parse(
                                                snapshot.data.documents[index]
                                                    ['longitude'],
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    : Container()
                                : Container();
                          }),
                        ),
                      ),
                    );
                  },
                )),
              ],
            ),
    );
  }

  void _launchMapsUrl(double lat, double lng) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
