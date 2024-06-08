import 'package:eye_connect/Utils/device_storage.dart';
import 'package:eye_connect/Utils/redirect_to_call.dart';
import 'package:eye_connect/Utils/update_scribe_request.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Recording_Request_ extends StatefulWidget {
  @override
  _Recording_Request_State createState() => _Recording_Request_State();
}

class _Recording_Request_State extends State<Recording_Request_> {
  String? getCurrentUID() {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  Future<void> _showThankYouDialog() async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Icon(Icons.star_border,color: Colors.amberAccent,size: 50),
          content: Text('Thanks For Your Kind Help.'),
          actions: <Widget>[
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ),
          ],
        );
      },
    );
  }

  File? file;

  Future<void> image_pick(ImageSource source,String number,String uid) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        file = File(pickedFile.path);
        _showThankYouDialog(); 
      }
    });
  }

  Future<List<Map<String, dynamic>>> fetchRecording_Request() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('recording_requests')
        .where('url', isNotEqualTo: null )
        // .where('Status', isNotEqualTo: 'completed')
        .get();

    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchRecording_Request(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No scribe requests found.'));
        } else {
          final Recording_Request = snapshot.data!;
          return ListView.builder(
            itemCount: Recording_Request.length,
            itemBuilder: (context, index) {
              final request = Recording_Request[index];
              return Container(
                margin: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Pending ${index + 1}'), // Customize content
                    Container(
                      width: double.infinity,
                      height: 140,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                               Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                 children: [
                                  Row(children: [
                                    Icon(Icons.person),
                                    Text('Person ${index}'),
                                  ],),
                                   Row(
                                    children: [
                                      Icon(Icons.calendar_month),
                                      Text(
                                        " Date : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      Text(request["Request_Date"],
                                          style: TextStyle(fontSize: 16))
                                    ],
                                                                 ),
                                 ],
                               ),
                              Divider(thickness: 2),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                GestureDetector(child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      border: Border.all(width: 0.5),
                                    borderRadius: BorderRadius.circular(50)
                                  ),
                                  child: Icon(Icons.picture_as_pdf)),onTap: () {
                                  
                                },),
                                GestureDetector(child: Container(
                                    width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      border: Border.all(width: 0.5),
                                    borderRadius: BorderRadius.circular(50)
                                  ),
                                  child: Icon(Icons.upload)),onTap: () {
                                },),
                              ],)
                            ]),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border:Border.all(color: Colors.green,width: 3.0),
                          borderRadius:const BorderRadius.all(Radius.circular(20)),
                          ),
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}
