import 'package:eye_connect/Utils/initai_Auth_check.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
    apiKey: 'AIzaSyCg2XkugwdD7L1T3VAZlZEItp230okFIqg',
    appId: '1:471654402450:android:01972f967d22abc943994b',
    messagingSenderId: '471654402450',
    projectId: 'eyeconnect-4dcb2',
    storageBucket: 'eyeconnect-4dcb2.appspot.com',
  )
  );
  runApp(const Main());
}

class Main extends StatelessWidget{
  const Main({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eye_Connect',
      theme: ThemeData.light(useMaterial3: true),
      home: AuthChecker(),
    );
  }
}