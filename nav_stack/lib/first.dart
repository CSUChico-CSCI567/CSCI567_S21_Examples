//https://flutter.dev/docs/cookbook/navigation/navigation-basics
import 'package:flutter/material.dart';
import 'package:nav_stack/drawer.dart';

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Screen'),
      ),
      drawer: MyDrawer(),
      body: Center(
        child: ElevatedButton(
          child: Text('Launch screen'),
          onPressed: () {
            // Navigate to the second screen when tapped.
            Navigator.pushNamed(context, '/second');
          },
        ),
      ),
    );
  }
}