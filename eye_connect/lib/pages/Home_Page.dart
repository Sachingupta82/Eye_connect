// import 'package:flutter/material.dart';

// class Home_Page extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(centerTitle: true,title: Text("Eye_connect_Scribe",style: TextStyle(color: Colors.white),),backgroundColor: Colors.black,),
//       backgroundColor: Colors.black,
//       body: PopScope(
//         canPop: false,
//         child: Column(children: [
//           Container(
//           width: 200,
//           height: 240,
//           child: Icon(Icons.android, size: 60, color: Colors.grey[100]),
//           decoration: BoxDecoration(
//               borderRadius: const BorderRadius.all(Radius.circular(42)),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.deepOrange[400]!,
//                   offset: const Offset(0, 20),
//                   blurRadius: 30,
//                   spreadRadius: -5,
//                 ),
//               ],
//               gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Colors.deepOrange[200]!,
//                     Colors.deepOrange[300]!,
//                     Colors.deepOrange[500]!,
//                     Colors.deepOrange[500]!,
//                   ],
//                   stops: const [
//                     0.1,
//                     0.3,
//                     0.9,
//                     1.0
//                   ])),
//         ),

//         ],)
//       ),
//     );
//   }
// }\

import 'package:eye_connect/Utils/fetchin_scribe_active.dart';
import 'package:eye_connect/Utils/fethcing_scribe_request.dart';
import 'package:eye_connect/Utils/recording_request.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int number = 3;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          leading: const Icon(Icons.remove_red_eye_rounded,size: 30,color: Colors.white),
          title: const Text('Scriber',style: TextStyle(color: Colors.white)),
          actions: [
            GestureDetector(
              onTap: null,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: const Icon(Icons.help,color: Colors.white),
              ),
              ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.list_alt_rounded,color: Colors.white,), text: 'Scribe'),
              Tab(icon: Icon(Icons.hourglass_empty_rounded,color: Colors.white), text: 'Active'),
              Tab(icon: Icon(Icons.lyrics_outlined,color: Colors.white), text: 'Recording'),
            ],
            labelColor: Colors.white,
            indicatorColor: Colors.white,
          ),
        ),
        body: TabBarView(
          children: [
            ScribeRequestsTab(),
            ScribeActiveRequest(),

           Recording_Request_(),
          ],
        ),
      ),
    );
  }
}

