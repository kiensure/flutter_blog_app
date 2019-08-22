import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UploadPhotoPage extends StatefulWidget {
  @override
  _UploadPhotoPageState createState() => _UploadPhotoPageState();
}

class _UploadPhotoPageState extends State<UploadPhotoPage> {
  File sampleImage;
  String _myValue;
  final formKey = new GlobalKey<FormState>();
  
  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    
    setState(() {
      sampleImage = tempImage;
    });
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    if(form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Page"),
        centerTitle: true,
      ),
      body: Center(
        child: sampleImage == null ? Text("Select an Image") : enableUpload(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Add Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
  
  Widget enableUpload(){
    return Container(
      padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
      child: new Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            Image.file(sampleImage, height: 310.0, width: 660.0,),
            SizedBox(height: 15.0),
            TextFormField(
              decoration: new InputDecoration(labelText: 'Description', labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              validator: (value) {
                return value.isEmpty ? 'Description is required' : null;
              },
              onSaved: (value) {
                return _myValue = value;
              },
            ),
            SizedBox(height: 15.0),
            RaisedButton(
              elevation: 10.0,
              child: Text("Add a New Post"),
              textColor: Colors.white,
              color: Colors.pink,
              onPressed: validateAndSave
            )
          ],
        ),
      ),
    );
  }
}
