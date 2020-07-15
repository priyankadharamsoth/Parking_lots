import 'package:auth/owner/DisableSlots.dart';
import 'package:auth/owner/addSlots.dart';
import 'package:auth/owner/slotDetails.dart';

import 'package:auth/screens/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details',
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
              //TODO change the name
              child: Center(child: Text('Blank')),
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
            ),
            ListTile(
              title: Text('Add Slots'),
              onTap: navigateToSlotspage,
              trailing: Icon(Icons.add),
            ),
            ListTile(
              title: Text('disable Slots'),
              onTap: navigateToDisablepage,
              trailing: Icon(Icons.remove),
            ),
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
    );
  }

  navigateToWelcomepage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Welcome()));
  }

  navigateToSlotspage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomeOwner()));
  }

  navigateToDisablepage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Disable()));
  }
}
