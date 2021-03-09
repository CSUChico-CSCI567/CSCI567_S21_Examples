import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Navigation is Awesome'),
            decoration: BoxDecoration(
              color: Colors.purple,
            ),
          ),
          ListTile(
            title: Text('home'),
            onTap: () {
              if(ModalRoute.of(context).settings.name != "/"){
                Navigator.of(context).pop();
              }
            },
          ),
          ListTile(
            title: Text('Page 2'),
            onTap: () {
              if(ModalRoute.of(context).settings.name != "/second"){
                Navigator.pushNamed(context, '/second');
              }
            },
          ),
        ],
      ),
    );
  }
}
