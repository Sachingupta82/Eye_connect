// ignore_for_file: non_constant_identifier_names, camel_case_types

import 'dart:io';
import 'package:eye_connect/Utils/device_storage.dart';
import 'package:eye_connect/Utils/navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eye_connect/Utils/uihelper.dart';
import 'package:eye_connect/pages/Signin_Page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final currentYear = DateTime.now().year;
  final uniqueId = "EC01$currentYear";


class SignUp_Page extends StatefulWidget {
  const SignUp_Page({super.key});

  @override
  State<SignUp_Page> createState() => _SignUp_PageState();
}

class _SignUp_PageState extends State<SignUp_Page> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController Name = TextEditingController();
  File? file;
  File? adhaar;
  File? certificate;
  UserCredential? userCredential;
  bool isloading = false;

  //Signup Logic
  Future<void> signup(String email, String password, String Name, File? file,
      File? adhaar, File? certificate) async {
    if (email == "" ||
        password == "" ||
        Name == "" ||
        file == null ||
        adhaar == null ||
        certificate == null) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("!Please Ensure All Deatils Are Filled!"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("OK"))
              ],
            );
          });
    } else {
      try {
        setState(() {
          isloading = true;
        });
        userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        User? user = userCredential!.user;
        if (user != null) {
          storeUid(user.uid);
          String profilePhotoUrl = await uploadImage(
            file,
            'profile_photos/${user.uid}.png',
          );
          String adharCardPhotoUrl =
              await uploadImage(adhaar, 'adhar_cards/${user.uid}.png');
          String certificatePhotoUrl = await uploadImage(
              certificate, 'prof_certificate/${user.uid}.pnh');

          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'name': Name,
            'email': email,
            'profilePhotoUrl': profilePhotoUrl,
            'adharCardPhotoUrl': adharCardPhotoUrl,
            'degreePhotoUrl': certificatePhotoUrl,
            'Id': uniqueId,
            'Total_help' : 0,
            'Helpy_points': 0
          });
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Navbarpage(),
          ),
        );
      } on FirebaseAuthException catch (e) {
        print(e.message);
      }
    }
  }

  Future<String> uploadImage(File image, String path) async {
    Reference StoreReference = FirebaseStorage.instance.ref().child(path);
    UploadTask uploadphoto = StoreReference.putFile(image);
    TaskSnapshot taskSnapshot = await uploadphoto;
    return taskSnapshot.ref.getDownloadURL();
  }
  //-----------End of Signup logic-----------//

  Future<void> image_pick(ImageSource source) async {
    final picker = ImagePicker();
    final pickedfile = await picker.pickImage(source: source);

    setState(() {
      if (pickedfile != null) {
        file = File(pickedfile.path);
      }
    });
  }

  Future<void> image_adhaar(ImageSource source) async {
    final picker = ImagePicker();
    final pickedfile = await picker.pickImage(source: source);

    setState(() {
      if (pickedfile != null) {
        adhaar = File(pickedfile.path);
      }
    });
  }

  Future<void> image_certificate(ImageSource source) async {
    final picker = ImagePicker();
    final pickedfile = await picker.pickImage(source: source);

    setState(() {
      if (pickedfile != null) {
        certificate = File(pickedfile.path);
      }
    });
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
          "SignUp",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: isloading ==false? SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: GestureDetector(
                onTap: () {
                  Uihelper.showAlertBox(context, image_pick);
                },
                child: CircleAvatar(
                  backgroundImage: file != null ? FileImage(file!) : null,
                  radius: 60,
                  child:
                      file == null ? const Icon(Icons.person, size: 60) : null,
                ),
              ),
            ),
            Uihelper.customtextfield(Name, 'Full Name', Icons.person, false),
            Uihelper.customtextfield(email, 'Email', Icons.person, false),
            Uihelper.customtextfield(password, 'Password', Icons.lock, true),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Uihelper.showAlertBox(context, image_adhaar);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12.0),
                          ),
                          color: Colors.transparent,
                          border: Border.all(color: Colors.black, width: 2)),
                      width: 170,
                      height: 170,
                      child: adhaar == null
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.upload),
                                Text("Upload Adhaar"),
                              ],
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Image.file(
                                adhaar!,
                                fit: BoxFit.cover,
                                width: 170,
                                height: 170,
                              ),
                            ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Uihelper.showAlertBox(context, image_certificate);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12.0),
                          ),
                          color: Colors.transparent,
                          border: Border.all(color: Colors.black, width: 2)),
                      width: 170,
                      height: 170,
                      child: certificate == null
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.upload),
                                Text(
                                  "Upload Professional",
                                  style: TextStyle(fontSize: 12.0),
                                ),
                                Text(
                                  'Certificate',
                                  style: TextStyle(fontSize: 12.0),
                                )
                              ],
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Image.file(
                                certificate!,
                                fit: BoxFit.cover,
                                width: 170,
                                height: 170,
                              ),
                            ),
                    ),
                  )
                ],
              ),
            ),
            Uihelper.customButton('Sign Up', () {
              signup(email.text, password.text, Name.text, file, adhaar,
                  certificate);
            }),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Have an account?',
                  style: TextStyle(fontSize: 15),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignIn_Page()));
                    },
                    child: const Text(
                      'Sign In',
                      style: TextStyle(color: Colors.blue),
                    ))
              ],
            ),
          ],
        ),
      ):const Center(child: CircularProgressIndicator()),
    );
  }
}
