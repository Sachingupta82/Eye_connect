import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> updateAssignedTokey(String number, String currentuseruid) async {
  try {
    await FirebaseFirestore.instance
        .collection('Scribe Need Request')
        .doc(number)
        .update({'AssignedTo': currentuseruid});
    print('Document successfully updated');
  } catch (e) {
    print('Error updating document: $e');
  }
}


// Future<void> updateStatus(String number, String currentuseruid) async {
//   try {
//     await FirebaseFirestore.instance
//         .collection('Scribe Need Request')
//         .doc(number)
//         .update({'AssignedTo': null,'assigned':currentuseruid})
//         ;
//     print('Document successfully updated');
//   } catch (e) {
//     print('Error updating document: $e');
//   }
// }