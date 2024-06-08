import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late User _currentUser;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser!;
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    DocumentSnapshot userDataSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUser.uid)
        .get();
    setState(() {
      _userData = userDataSnapshot.data() as Map<String, dynamic>?;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 12, 12, 12),
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(0.8), // Adjust height as needed
          child: Container(
            color: Colors.grey[600], 
            height: 1.0, 
          ),
        ),
        automaticallyImplyLeading: true,
        backgroundColor: Color.fromARGB(255, 12, 12, 12),
        title: Text(
          'Account',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _userData == null
          ? Center(child: CircularProgressIndicator())
          : _buildUserProfile(),
    );
  }

  Widget _buildUserProfile() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(_userData!['profilePhotoUrl']),
          ),
          SizedBox(height: 20),
      
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                  color: Color.fromARGB(255, 67, 67, 67),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                height: 100,
                width: 120,
                padding: EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.handshake,
                      size: 30,
                      color: Colors.blue,
                    ),
      
                    Text(
                      "Helps",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    // SizedBox(height: 4),
                    Text(
                      _userData != null
                          ? _userData!['Total_help'].toString()
                          : '0',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                  color: Color.fromARGB(255, 67, 67, 67),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                height: 100,
                width: 120,
                padding: EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.wallet_giftcard,
                      size: 30,
                      color: Colors.blue,
                    ),
                    // SizedBox(height: 2),
                    Text(
                      "Helpy Points",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    // SizedBox(height: 4),
                    Text(
                      _userData != null
                          ? _userData!['Helpy_points'].toString()
                          : '0',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
                color: Color.fromARGB(255, 67, 67, 67),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.5),
                  width: 1,
                ),
              ),
              height: MediaQuery.of(context).size.height * 0.44,
              width: double.infinity,
              padding: EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text("Scribe Id : ",
                          style: TextStyle(fontSize: 20, color: Colors.blue)),
                      Text(
                        _userData!['Id'],
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text("Name      : ",
                          style: TextStyle(fontSize: 20, color: Colors.blue)),
                      Text(
                        _userData!['name'],
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Email       : ",
                        style: TextStyle(fontSize: 20, color: Colors.blue),
                      ),
                      Text(
                        _userData!['email'],
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      )
                    ],
                  ),
                  QrImageView(
                    data: 'Scribe Assigned for ______ student',
                    version: QrVersions.auto,
                    size: 190,
                    gapless: false,
                    // foregroundColor: const Color.fromARGB(255, 220, 219, 219),
                    backgroundColor: Colors.white,
                  ),
                  Row(
                    children: [
                      Text(
                        "Languages: ",
                        style: TextStyle(fontSize: 20, color: Colors.blue),
                      ),
                      Text(
                        // _userData!['email'],
                        '[English , Hindi]',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
      
          // Add more fields as needed
        ],
      ),
    );
  }
}
