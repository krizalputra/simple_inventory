import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../main.dart';

class AddItem extends StatefulWidget {    
  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String itemName;
  int itemQuantity;  

  File _image;    
  String _uploadedFileURL; 

  String numberValidator(String value) {
    if(value == null) {
      return null;
    }
    final n = num.tryParse(value);
    if(n == null) {
      return '"$value" is not a valid number';
    }
    return null;
  }

  String nameValidator(String value){
    if (value.isEmpty) {
      return 'Please enter item name';
    }
    return null;
  }

  void createRecord(BuildContext context) async{    
    List<String> caseSearchList = List();
    String imageUrl = "";
    String temp = "";
    for (int i = 0; i < itemName.length; i++) {
      temp = temp + itemName[i];
      caseSearchList.add(temp.toLowerCase());
    }

    if(_image != null){
      await uploadFIle();
      imageUrl = _uploadedFileURL;
    }
    
    DocumentReference ref = await Firestore.instance.collection("items")
      .add({
        'name': itemName,
        'quantity': itemQuantity,
        'imageUrl': imageUrl,
        'caseSearchList' : caseSearchList
      });  
      
      Navigator.push(context, 
        new MaterialPageRoute(builder: (context) => MyHomePage())
      );
  }

  Future imageFromGallery() async {      
    var selectedImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {    
      _image = selectedImage;   
      _uploadedFileURL = basename(_image.path); 
    });  
  }  

  Future imageFromCamera() async {      
    var selectedImage = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {    
      _image = selectedImage;   
      _uploadedFileURL = basename(_image.path); 
    });  
  }  

  Future<String> uploadFIle() async{
    StorageReference ref = FirebaseStorage.instance.ref().child('items/'+_uploadedFileURL);
    StorageUploadTask uploadTask =  ref.putFile(_image);

    var downUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    var url = downUrl.toString();

    setState(() {    
      _uploadedFileURL = url;    
    }); 

    print("Download URL: " + url);

    return "";
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Item'),
      ),
      body: Builder(
        builder: (context) => new Container(
          padding: new EdgeInsets.all(20.0),
          child: new Form(
            key: this._formKey,
            child: new ListView(
              children: <Widget>[                
                _image == null? (                              
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RaisedButton(
                        color: Colors.grey,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.camera, color: Colors.white,),
                            Text("From Camera",
                              style: new TextStyle(
                                color: Colors.white
                              ),
                            ),
                          ],
                        ),                         
                        onPressed: imageFromCamera,
                      ),
                      Container(),
                      RaisedButton(
                        color: Colors.blue,
                        child:Row(
                          children: <Widget>[
                            Icon(Icons.image, color: Colors.white,),
                            Text("From Gallery",
                              style: new TextStyle(
                                color: Colors.white
                              ),
                            ),
                          ],
                        ),
                        onPressed: imageFromGallery,
                      )
                    ],
                  ))
                  : Image.file(
                    _image, 
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  ),                
                new TextFormField(
                  validator: nameValidator,
                  decoration: new InputDecoration(
                    labelText: 'Item Name'
                  ),
                  onSaved: (String val){
                    itemName = val;
                  },
                ),
                new TextFormField(
                  keyboardType: TextInputType.number, 
                  validator: numberValidator, 
                  decoration: new InputDecoration(
                    labelText: 'Initial Stock Quantity'
                  ),
                  onSaved: (String val){
                    itemQuantity = int.tryParse(val);
                  },
                ),
                new Container(
                  width: screenSize.width,
                  child: new RaisedButton(
                    child: new Text(
                      'Add New Item',
                      style: new TextStyle(
                        color: Colors.white
                      ),
                    ),
                    onPressed: (){
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        Scaffold.of(context).showSnackBar(SnackBar(content: Text("Saving Data")));
                        LinearProgressIndicator();
                        createRecord(context);                        
                      }
                    },
                    color: Colors.purple,
                  ),
                  margin: new EdgeInsets.only(
                    top: 20.0
                  ),
                ),
              ],
            ),
          ),
        ),
      ),      
    );
  }

}