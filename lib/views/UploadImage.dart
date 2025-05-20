import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart' as http;


class Uploadimage extends StatefulWidget {
  const Uploadimage({super.key});

  @override
  State<Uploadimage> createState() => _UploadimageState();
}

class _UploadimageState extends State<Uploadimage> {
  File? image;
  final _image = ImagePicker();
  bool showSpinner = false;


  Future getImage() async {
    final pickedFile = await _image.pickImage(source: ImageSource.gallery,imageQuality: 80);
    if(pickedFile != null){
      image = File(pickedFile.path);
      setState(() {

      });
    }else{
      print('NO image is selected');
    }
  }
  Future<void> uploadImage() async{
    setState(() {
      showSpinner = true;
    });

    var stream = new http.ByteStream(image!.openRead());
    stream.cast();

    var length = await image!.length();

    var uri = Uri.parse('https://fakestoreapi.com/products');

    var request = http.MultipartRequest('POST', uri);

    request.fields['title'] = 'Static Title';
    var multiport =  new http.MultipartFile('image', stream, length);
    request.files.add(multiport);
    var response = await request.send();
    if(response.statusCode == 200){
      setState(() {
        showSpinner = false;
      });
      print("Image Uploaded");
    }else{
      showSpinner = false;
      print('Failed');

    }

  }
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child:Scaffold(
      appBar: AppBar(title: Text('Upload Image')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: (){
              getImage();
            },
            child: Container(
              child:
                  image == null
                      ? Center(child: Text('Pick Image'))
                      : Container(
                        child: Center(
                          child: Image.file(
                            File(image!.path).absolute,
                            height: 100,
                            width: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
            ),
          ),
          SizedBox(height: 150,),
          GestureDetector(
            onTap: (){
              uploadImage();
            },
            child: Container(
              height: 50,
              color: Colors.green,
              child: Center(child: Text('Upload')),
            ),
          )
        ],
      ),
    ));
  }
}
