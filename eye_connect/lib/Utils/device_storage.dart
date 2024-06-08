import 'package:shared_preferences/shared_preferences.dart';


void storeUid(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_uid', uid);
}

Future<String?> getUid() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? uid = prefs.getString('uid');
  return uid;
}