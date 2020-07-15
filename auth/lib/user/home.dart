import 'package:auth/screens/welcome.dart';
import 'package:auth/services/geolocator_service.dart';
import 'package:auth/user/slotsList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  BitmapDescriptor _markerIcon;
  List<Marker> allMarkers = List<Marker>();
  // final  BitmapDescriptor customIcon;

  void getCurrentLocation() async {
    position = await GeoLocatorService.getLocation();
    setState(() {});
    return;
  }

  @override
  void initState() {
    getCurrentLocation();
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(100, 1000)),
            'assets/images/parking3.jpg')
        .then((value) {
      setState(() {
        _markerIcon = value;
      });
    });
    super.initState();
  }

  void addMarkers(QuerySnapshot snapshot) {
    if (snapshot == null) return;

    for (DocumentSnapshot doc in snapshot.documents) {
      allMarkers.add(
        Marker(
          icon: _markerIcon != null ? _markerIcon : Icons.card_travel,
          markerId: MarkerId(doc.documentID),
          draggable: false,
          infoWindow: InfoWindow(title: doc['apartmentname']),
          position: LatLng(
            double.parse(doc['latitude']),
            double.parse(
              doc['longitude'],
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final geoService = GeoLocatorService();
    return WillPopScope(
      onWillPop: () {
        return showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Center(
                child: Text('Are you sure'),
              ),
              content: Text('want to close the app?'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Not Yet'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text('Yes'),
                  onPressed: () {
                    // return exit(0);
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                ),
              ],
            );
          },
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Parking Lots',
              style: TextStyle(
                  fontFamily: 'Lobster', color: Colors.black, fontSize: 25.0)),
          centerTitle: true,
        ),
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text('Drawer Header'),
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColor),
              ),
              ListTile(
                title: Text('Logout'),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  navigateToWelcomepage();
                },
                trailing: Icon(Icons.person),
              ),
            ],
          ),
        ),
        body: position == null
            ? Center(child: CircularProgressIndicator())
            : StreamBuilder(
                stream: Firestore.instance.collection('Places').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  // To add the markers on to the google maps
                  addMarkers(snapshot.data);

                  return Column(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height / 3,
                        width: MediaQuery.of(context).size.width,
                        child: GoogleMap(
                          onMapCreated: (GoogleMapController controller) {
                            mapController = controller;
                          },
                          initialCameraPosition: CameraPosition(
                            target:
                                LatLng(position.latitude, position.longitude),
                            zoom: 16.0,
                          ),
                          markers: Set.from(allMarkers),
                          zoomGesturesEnabled: true,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Expanded(
                        child: !snapshot.hasData
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : ListView.builder(
                                itemCount: snapshot.data.documents.length,
                                itemBuilder:
                                    (BuildContext context, int index) =>
                                        FutureProvider(
                                  create: (context) => geoService.getDistance(
                                    position.latitude,
                                    position.longitude,
                                    double.parse(
                                      snapshot.data.documents[index]
                                          ['latitude'],
                                    ),
                                    double.parse(
                                      snapshot.data.documents[index]
                                          ['longitude'],
                                    ),
                                  ),
                                  child: Card(
                                    child: Consumer<double>(
                                      builder: (context, meters, widget) {
                                        return (meters != null)
                                            // TODO: change the check condition before production
                                            ? (meters < 1000.0 || true)
                                                ? ListTile(
                                                    title: Text(snapshot.data
                                                            .documents[index]
                                                        ['apartmentname']),
                                                    subtitle: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                            'dist:${(meters.round())}mts')
                                                      ],
                                                    ),
                                                    onTap: () {
                                                      navigateToDetails(
                                                          apartmentId: snapshot
                                                              .data
                                                              .documents[index]
                                                              .documentID);
                                                    },
                                                    trailing: IconButton(
                                                      icon: Icon(
                                                          Icons.directions),
                                                      color: Colors.teal,
                                                      onPressed: () {
                                                        _launchMapsUrl(
                                                          double.parse(
                                                            snapshot.data
                                                                    .documents[
                                                                index]['latitude'],
                                                          ),
                                                          double.parse(
                                                            snapshot.data
                                                                        .documents[
                                                                    index]
                                                                ['longitude'],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  )
                                                : Container()
                                            : Container();
                                      },
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ],
                  );
                },
              ),
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

  navigateToDetails({@required String apartmentId}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Slots(
                  apartmentID: apartmentId,
                )));
  }

  void navigateToWelcomepage() {
    // navigate to welcome page
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Welcome()), (route) => false);
  }
}
