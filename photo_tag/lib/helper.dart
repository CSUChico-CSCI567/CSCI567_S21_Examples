import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:toast/toast.dart';
//import 'package:path_provider/path_provider.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class SecondScreenState extends State<SecondScreen> {

  File _image;
  List<String> _labelTexts;

  @override
  void initState() {
    _labelTexts=null;
    super.initState();
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

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    _image = image;
    _labelTexts = null;
    setState(() {

    });
    await detectLabels();
    setState(() {

    });
  }

  Future detectLabels() async {
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(
        _image);
    final ImageLabeler cloudLabeler = FirebaseVision.instance.cloudImageLabeler();

    final List<ImageLabel> cloudLabels = await cloudLabeler.processImage(visionImage);
    final TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
    final VisionText visionText = await textRecognizer.processImage(visionImage);

    String text = visionText.text;
    for (TextBlock block in visionText.blocks) {
      final Rect boundingBox = block.boundingBox;
      final List<Offset> cornerPoints = block.cornerPoints;
      final String text = block.text;
      final List<RecognizedLanguage> languages = block.recognizedLanguages;
      print(text);

      for (TextLine line in block.lines) {
        // Same getters as TextBlock
        for (TextElement element in line.elements) {
          // Same getters as TextBlock
        }
      }
    }

//    print(cloudLabels);

    _labelTexts = new List();
    for (ImageLabel label in cloudLabels) {
      final String text = label.text;
      final String entityId = label.entityId;
      final double confidence = label.confidence;
      print(text);
      _labelTexts.add(text + " " + confidence.toString());
    }
  }

  Future<String> _uploadFile(filename) async {
//    final File file = _image;
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

  Future<void> _addItem(String downloadURL, List<String> labels) async {
    await FirebaseFirestore.instance.collection('photos').add(<String, dynamic>{
      'downloadURL': downloadURL,
      'labels': labels,
    });
  }

  Widget getLabels(){
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _labelTexts.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 25,
//          color: Colors.amber[colorCodes[index]],
            child: Center(child: Text('${_labelTexts[index]}')),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null
                ? Text('No image selected.')
                : Image.file(_image,width: 300),
            Container(
                margin: const EdgeInsets.all(10.0),
                height: 200.0,
                child:_labelTexts==null
                    ? Text('No image selected.')
                    :getLabels()
            ),
            RaisedButton(
              onPressed: () {
                _upload();
              },
              child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 20)
              ),
            )
          ]
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}

class SecondScreen extends StatefulWidget {
  SecondScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  SecondScreenState createState() => new SecondScreenState();

}