import 'dart:ffi';
import 'dart:io';

import 'package:counterstate/storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: MyHomePage(title: 'Flutter Demo', storage: CounterStorage()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title, this.storage}) : super(key: key);

  final String title;
  final CounterStorage storage;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = -1;
  Position position = null;
  double latitude = 0;
  double longitude = 0;
  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void getCount() async {
    int counter = await widget.storage.readCounter();
    setState(() {
      _counter = counter;
    });
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  void getPlacemarks() async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    print(placemarks);
  }

  @override
  void initState() {
    super.initState();
    getCount();
    _determinePosition().then((value) {
      setState(() {
        position = value;
        latitude = position.latitude;
        longitude = position.longitude;
        getPlacemarks();
      });
      // print(value);
    }).catchError((error) => print("$error"));
  }

  Future<void> _incrementCounter() async {
    setState(() {
      _counter++;
    });
    widget.storage.writeCounter(_counter);
  }

  Future<void> _decrementCounter() async {
    setState(() {
      _counter--;
    });
    widget.storage.writeCounter(_counter);
  }

  // void _incrementCounter() {
  //   setState(add);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null
                ? Text('No image selected.')
                : SizedBox(
                    width: 200.0, height: 300.0, child: FittedBox(child:Image.file(_image), fit: BoxFit.fill)),
            position == null
                ? CircularProgressIndicator()
                : Column(
                    children: [
                      Text('$latitude, $longitude'),
                    ],
                  ),
            _counter == -1
                ? CircularProgressIndicator()
                : Column(
                    children: [
                      Text('Like Count:'),
                      Text('$_counter'),
                    ],
                  ),
            Padding(
                padding: const EdgeInsets.all(40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: _counter <= 0 ? null : _decrementCounter,
                        child: Text("-")),
                    // ElevatedButton(
                    //     onPressed: _counter >= 10 ? null : _incrementCounter,
                    //     child: Icon(
                    //       Icons.favorite,
                    //       color: _counter < 10? Colors.red: Colors.grey
                    //     ),
                    //     ),
                    IconButton(
                      onPressed: _counter >= 10 ? null : _incrementCounter,
                      icon: Icon(Icons.favorite,
                          color: _counter < 10 ? Colors.red : Colors.grey),
                    ),
                  ],
                ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
