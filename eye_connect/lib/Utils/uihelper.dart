import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Uihelper {
  static customtextfield(TextEditingController controller, String name,
      IconData icon, bool value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: TextField(
        controller: controller,
        obscureText: value,
        decoration: InputDecoration(
            prefixIcon: Icon(icon),
            hintText: name,
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0)))),
      ),
    );
  }

  static customButton(String buttonName, VoidCallback onpressfunction) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: SizedBox(
          height: 50,
          width: 300,
          child: ElevatedButton(
            onPressed: onpressfunction,
            style: ElevatedButton.styleFrom(
              elevation: 2,
              backgroundColor: Colors.black,
            ),
            child: Text(
              buttonName,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          )),
    );
  }

  static void showAlertBox(
    BuildContext context,
    Future<void> Function(ImageSource source) imagePickCallback,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select the image from'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: ()async{
                  await imagePickCallback(ImageSource.camera);
                  Navigator.pop(context);
                }, 
                leading: Icon(Icons.camera),
                title: Text('Camera'),
              ),
              ListTile(
                onTap: ()async{
                  await imagePickCallback(ImageSource.gallery);
                  Navigator.pop(context);
                }, 
                leading: Icon(Icons.photo),
                title: Text('Gallery'),
              )
            ],
          ),
        );
      },
    );
  }

}
