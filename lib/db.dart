import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> add_user(String mail,String username) async{
  CollectionReference userref=FirebaseFirestore.instance.collection('users');
  await userref.doc('$mail').set({
    'username':username,
  }).catchError((e){print(e.toString());});
}