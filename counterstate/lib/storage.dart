import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class CounterStorage {
  bool _initialized = false;
  FirebaseApp firebaseApp = null;

  // Define an async function to initialize FlutterFire
  Future<void> initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      firebaseApp = await Firebase.initializeApp();
      _initialized = true;
    } catch(e) {
      print(e);
    }
  }

  CounterStorage(){
    initializeFlutterFire();
  } 


  Future<bool> writeCounter(int counter) async {
    if(!_initialized){
      await initializeFlutterFire();
    }
    // Access Firestore using the default Firebase app:
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    firestore
      .collection('example')
      .doc('hFBEJrngHM3SFtSzaXyw')
      .set({
            'count': counter, 
          })
      .then((value) => print("Count Added"))
      .catchError((error) => print("Failed to update count: $error"));
    return true;
  }

  Future<int> readCounter() async {
    if(!_initialized){
      await initializeFlutterFire();
    }
    // Access Firestore using the default Firebase app:
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    DocumentSnapshot value = await firestore
      .collection('example')
      .doc('hFBEJrngHM3SFtSzaXyw').get();
      
    Map<String, dynamic> data = value.data();
    // print(data['count']);
    return data['count'];
 
    //   .catchError((error) => print("Failed to get count: $error"));
      
    // return 0;
  }
}
