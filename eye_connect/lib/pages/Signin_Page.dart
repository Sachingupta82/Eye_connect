import 'package:eye_connect/Utils/device_storage.dart';
import 'package:eye_connect/Utils/navigation_bar.dart';
import 'package:eye_connect/Utils/uihelper.dart';
import 'package:eye_connect/pages/Signup_Page.dart';
import 'package:eye_connect/pages/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignIn_Page extends StatefulWidget {
  @override
  State<SignIn_Page> createState() => _SignIn_PageState();
}

class _SignIn_PageState extends State<SignIn_Page> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<dynamic> error_dialog(String error_message) {
    return showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text(error_message),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: const Text("OK"))
        ],
      );
    });
  }

  Future<void>signIn (String username,String password)async{
    if(username == "" || password ==""){
      error_dialog("Please ensure no fields are empty!");
    }else{
      try{
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: username, password: password);
      User? user = userCredential.user;
      if(user != null){
        storeUid(user.uid);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Navbarpage()));
      }
      }on FirebaseAuthException catch (e){
        error_dialog(e.message!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
        ),
        title: const Text(
          "SignIn",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 200,
                child: Image.asset('assets/blind_person.png'),
              ),
              Uihelper.customtextfield(email, 'Email', Icons.person, false),
              Uihelper.customtextfield(password, 'Password', Icons.lock, true),
              Uihelper.customButton('Login', () {
                signIn(email.text, password.text);
              }),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Dont have an account?',
                    style: TextStyle(fontSize: 15),
                  ),
                  TextButton(onPressed: (){
                    Navigator.push(context,MaterialPageRoute(builder: (context)=> SignUp_Page()));
                  }, child: Text('Sign Up',style: TextStyle(color: Colors.blue),))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
