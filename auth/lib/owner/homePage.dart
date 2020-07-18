import 'package:auth/owner/DisableSlots.dart';
import 'package:auth/owner/addSlots.dart';
import 'package:auth/owner/slotDetails.dart';

import 'package:auth/screens/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home',
            style: GoogleFonts.lobster(color: Colors.black, fontSize: 25.0)),
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
              child: Center(child: Text('Details:')),
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
            ),
            ListTile(
              title: Text('Add Slots'),
              onTap: navigateToSlotspage,
              trailing: Icon(Icons.add),
            ),
            // ListTile(
            //   title: Text('disable Slots'),
            //   onTap: navigateToDisablepage,
            //   trailing: Icon(Icons.remove),
            // ),
            ListTile(
              title: Text('Slots'),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SlotDetails()));
              },
              trailing: Icon(Icons.person_pin_circle),
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
      body: FutureBuilder<FirebaseUser>(
        future: FirebaseAuth.instance.currentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return FutureBuilder<DocumentSnapshot>(
              future: Firestore.instance
                  .collection('Places')
                  .document(snapshot.data.uid)
                  .get(),
              builder: (context, docSnapshot) {
                if (docSnapshot.connectionState != ConnectionState.done)
                  return Container(
                    child: CircularProgressIndicator(),
                  );
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * .75,
                        width: MediaQuery.of(context).size.width,
                        child: GoogleMap(
                          onMapCreated: (GoogleMapController controller) {
                            mapController = controller;
                          },
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                              double.parse(docSnapshot.data.data['latitude']),
                              double.parse(docSnapshot.data.data['longitude']),
                            ),
                            zoom: 16.0,
                          ),
                          zoomGesturesEnabled: true,
                        ),
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      Text('Welcome ${docSnapshot.data.data['apartmentname']}'),
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  navigateToWelcomepage() {
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => Welcome()), (route) => false);
  }

  navigateToSlotspage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomeOwner()));
  }

  navigateToDisablepage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Disable()));
  }
}
