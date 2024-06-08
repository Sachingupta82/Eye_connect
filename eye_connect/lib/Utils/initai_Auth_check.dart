import 'package:eye_connect/Utils/navigation_bar.dart';
import 'package:eye_connect/pages/Signin_Page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthChecker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _checkAuthState(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          bool? isLoggedIn = snapshot.data;
          if (isLoggedIn!) {
            return Navbarpage();
          } else {
            return SignIn_Page();
          }
        }
      },
    );
  }

  Future<bool> _checkAuthState() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('uid', user.uid);
      return true;
    } else {
      return false;
    }
  }
}
