import 'dart:convert';

import 'package:api_integration/Models/Photoes.dart';
import 'package:api_integration/views/UploadImage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PhotosScreen extends StatefulWidget {
  const PhotosScreen({super.key});

  @override
  State<PhotosScreen> createState() => _PhotosScreenState();
}

class _PhotosScreenState extends State<PhotosScreen> {
  List<Photos> photoList = [];

  Future<List<Photos>> getPhotosApi() async {
    var response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/photos'),
    );
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      photoList.clear();
      for (Map i in data) {
        Photos photos = Photos(title: i['title'], url: i['url'], id: i['id']);
        photoList.add(photos);
      }
      return photoList;
    } else {
      return photoList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Photos API')),
      body: FutureBuilder<List<Photos>>(
        future: getPhotosApi(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data found'));
          } else {
            final photoList = snapshot.data!;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Uploadimage()),
                      );
                    },
                    child: Text('User Api'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // button background color
                        foregroundColor: Colors.white, // text/icon color
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16), // rounded corners
                        ),
                        elevation: 5, // shadow
                      )
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: photoList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(photoList[index].url),
                        ),
                        title: Text('Notes id: ${photoList[index].id}'),
                        subtitle: Text(photoList[index].title),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
