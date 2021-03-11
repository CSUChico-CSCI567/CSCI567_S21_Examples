//https://flutter.dev/docs/cookbook/navigation/navigation-basics
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return Text("Something Went Wrong");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return HomePage(title: "Photo Tag");
          }
          return CircularProgressIndicator();
        });
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FixedExtentScrollController scrollController;

  @override
  void initState() {
    scrollController = FixedExtentScrollController();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Widget photo_widget(AsyncSnapshot<QuerySnapshot> snapshot, index) {
    try {
      return Column(
        children: [
          ListTile(title: Text(snapshot.data.docs[index]['labels'][0])),
          Image.network(snapshot.data.docs[index]['downloadURL'], height: 150)
        ],
      );
    } catch (e) {
      print(e);
      return ListTile(title: Text("Error:" + e.toString()));
    }
  }

  Widget getPhotos() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("photos").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error);
          }
          if (!snapshot.hasData) {
            return Text("Loading Photos...");
          }
          if (snapshot.hasData) {
            print("Snapshot Length ${snapshot.data.docs.length}");
            return Expanded(
                child: Scrollbar(
              child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return photo_widget(snapshot, index);
                  }),
            ));
          }
          return CircularProgressIndicator();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [getPhotos()],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/second');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
