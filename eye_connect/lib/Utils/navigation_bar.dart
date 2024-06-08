import 'package:eye_connect/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:get/get.dart';
import 'package:eye_connect/pages/Home_Page.dart';

class NavbarController extends GetxController {
  var selectedIndex = 0.obs;

  void setIndex(int index) {
    selectedIndex.value = index;
  }
}

class Navbarpage extends StatelessWidget {
  final NavbarController navbarController = Get.put(NavbarController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: GetBuilder<NavbarController>(
        builder: (controller) => Container(
          child: CurvedNavigationBar(
            color: const Color.fromARGB(255, 198, 196, 196),
            index: controller.selectedIndex.value,
            height: 65, 
            backgroundColor: Color.fromARGB(255, 6, 5, 5),
            items: <Widget>[
              Icon(Icons.home, size: 30),
              Icon(Icons.person, size: 30),
            ],
            onTap: (index) {
              controller.setIndex(index);
            },
          ),
        ),
      ),
      body: Obx(() {
        switch (navbarController.selectedIndex.value) {
          case 0:
            return HomePage();
          case 1:
            return UserProfileScreen();
          default:
            return HomePage(); // Handle other cases if needed
        }
      }),
    );
  }
}
