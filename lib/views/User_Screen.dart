import 'dart:convert';

import 'package:api_integration/Models/user_model.dart';
import 'package:api_integration/views/Photos_Screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  List<UserModel> userModelList = [];
  Future<List<UserModel>> getUserApi() async {
    var response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/users'),
    );
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      for (Map i in data) {
        userModelList.add(UserModel.fromJson(i));
      }
      return userModelList;
    }
    return userModelList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Api')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PhotosScreen()),
                );
              },
              child: Text('Photos Api'),
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
            child: FutureBuilder(
              future: getUserApi(),
              builder: (context, AsyncSnapshot<List<UserModel>> snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                } else {
                  return ListView.builder(
                    itemCount: userModelList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              ReuseFulRow(title: 'Name', value: snapshot.data![index].name.toString()),
                              ReuseFulRow(title: 'UserName', value: snapshot.data![index].username.toString()),
                              ReuseFulRow(title: 'Email', value: snapshot.data![index].email.toString()),
                              ReuseFulRow(title: 'Address', value: snapshot.data![index].address!.geo.lat.toString())


                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],

      ),
    );
  }
}

class ReuseFulRow extends StatelessWidget {
  String title,value;
  ReuseFulRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Text(value),
      ],
    );

  }
}
