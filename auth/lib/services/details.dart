import 'package:auth/screens/homeOwner.dart';
import 'package:auth/screens/slots.dart';
import 'package:auth/screens/welcome.dart';
import 'package:flutter/material.dart';

class Details extends StatefulWidget {
  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
              onTap: 
                navigateToSlotspage,
            
            
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                navigateToWelcomepage();
                
              },
            ),
          ],
        ),
      ),
    );
  }
  navigateToWelcomepage(){
     Navigator.push(
        context, MaterialPageRoute(builder: (context) => Welcome()));
  }
  navigateToSlotspage(){
     Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomeOwner()));
  }
}