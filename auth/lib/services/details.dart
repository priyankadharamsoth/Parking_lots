import 'package:auth/owner/DisableSlots.dart';
import 'package:auth/owner/addSlots.dart';

import 'package:auth/screens/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Details extends StatefulWidget {
  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Details')),
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
              decoration: BoxDecoration(
                color: Colors.blue,
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
              title: Text('View Users'),
              onTap: () {},
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
