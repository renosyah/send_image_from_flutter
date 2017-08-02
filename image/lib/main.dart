import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';


void main() {
  runApp(new MaterialApp(home: new MyHomePage(),));
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File imageFile;
  String image_encode= 'image encoder';



  getImage() async {
    var _fileName = await ImagePicker.pickImage();
    setState(() {
      imageFile = _fileName;
    });
    Stream<List<int>> stream = imageFile.openRead();
    stream.transform(BASE64.encoder)
        .transform(const LineSplitter())
        .listen((line){
      setState((){
        image_encode = line;
      });
    });
  }




  sendimage() async {

    var httpclient = createHttpClient();
    var data = {"nama":"default","gambar":image_encode};
    var send = await httpclient.post("http://192.168.23.1:8080/file",body: data);// dont forget to change its server target
    Map respon = JSON.decode(send.body);

    bool status = respon["Stats"];
    if (status){

    }else{

    }
    setState((){
      image_encode = '';
      imageFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    var isi_menu_home = [];
    isi_menu_home.add(
        imageFile == null
        ? new Text('No image selected.')
        : new Image.file(imageFile));
    isi_menu_home.add(new Text("\n"));
    isi_menu_home.add(new RaisedButton(onPressed: sendimage,child: new Text("send"),));


    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Image Picker Example'),
      ),
      body: new Center(child :new ListView(children: isi_menu_home)),
      floatingActionButton: new FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: new Icon(Icons.add_a_photo),
      ),
    );
  }
}


