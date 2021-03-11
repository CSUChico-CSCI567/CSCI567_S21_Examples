import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:uuid/uuid.dart';


class SecondScreen extends StatefulWidget {
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  File _image;
  final picker = ImagePicker();
  List<String> _labelTexts = [];

  Future detectLabels() async{
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(_image);
    final ImageLabeler cloudLabeler = FirebaseVision.instance.cloudImageLabeler();
    final List<ImageLabel> cloudLabels = await cloudLabeler.processImage(visionImage);

    _labelTexts = new List();
    for (ImageLabel label in cloudLabels) {
      final String text = label.text;
      final String entityId = label.entityId;
      final double confidence = label.confidence;
      print(text);
      _labelTexts.add(text + " " + confidence.toString());
    }
    setState(() {

    });
  }

  Future<String> _uploadFile(filename) async {
    final Reference ref = FirebaseStorage.instance.ref().child('$filename.jpg');
    final metadata = firebase_storage.SettableMetadata(
        contentType: 'image/jpeg',
        contentLanguage: 'en');
    final UploadTask uploadTask = ref.putFile(
      _image,
      metadata,
    );

    final downloadURL = await (await uploadTask).ref.getDownloadURL();
    print(downloadURL);
    return downloadURL.toString();
  }



  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _labelTexts = [];
      } else {
        print('No image selected.');
      }
    });
    await detectLabels();
  }

  Widget getLabels(){
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _labelTexts.length,
        itemBuilder: (BuildContext context, int index){
          return Container(
            height: 25,
            child: Center(
              child: Text('${_labelTexts[index]}'),
            ),
          );
        }
    );
  }

  Future<void> _addItem(String downloadURL, List<String> labels) async {
    await FirebaseFirestore.instance.collection('photos').add(<String, dynamic>{
      'downloadURL': downloadURL,
      'labels': labels,
    });
  }


  void _upload() async{
    if(_labelTexts != null && _image != null){
      var uuid = Uuid();

      final String uid = uuid.v4();
      final String downloadURL = await _uploadFile(uid);
      await _addItem(downloadURL, _labelTexts);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a Photo"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _image == null
              ? Text('No image selected')
              : Image.file(_image, width: 300,),
          Container(
            margin: const EdgeInsets.all(10.0),
            height: 200.0,
            child: getLabels(),
          ),
          ElevatedButton(
              onPressed: _upload,
              child: Text(
              'Submit',))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: "Take Photo",
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
