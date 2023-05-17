import 'package:cloud_firestore/cloud_firestore.dart';

Future<int> search_user(String phone) async{
  QuerySnapshot snap;
  CollectionReference userref=FirebaseFirestore.instance.collection('users');
  await userref.where('phone',isEqualTo: phone).get().then((value) => snap=value);
  return snap.docs.length;
}

Future<String> get_username(String phone) async{
  QuerySnapshot snap;
  CollectionReference userref=FirebaseFirestore.instance.collection('users');
  await userref.where('phone',isEqualTo: phone).get().then((value) => snap=value);
  return snap.docs.first.data()['username'];
}

Future<int> add_user(String phone,String username) async{
  CollectionReference userref=FirebaseFirestore.instance.collection('users');
  await userref.add({
    'phone':phone,
    'username':username,
    'status':'online'
  }).catchError((e){print(e.toString());});
}

Future<int> create_chatroom(String selfuser,String user2,String self_name,String peer_name) async{
  CollectionReference chatroomref=FirebaseFirestore.instance.collection('Chatrooms');
  await chatroomref.doc('${selfuser}_${user2}').set({
    'ChatroomID':'${selfuser}_${user2}',
    'users':[selfuser,user2],
    '${selfuser}_name':self_name,
    '${user2}_name':peer_name,
    'last_message_time':DateTime.now().millisecondsSinceEpoch,
    '${selfuser}_typing':'false',
    '${user2}_typing':'false',
    '${selfuser}_seen':'false',
    '${user2}_seen':'false',
    'last_message':''
  }).catchError((e){print(e.toString());});
}

Stream<QuerySnapshot> getchat(String chatroomID) {
  CollectionReference chatroomref=FirebaseFirestore.instance.collection('Chatrooms');
  return chatroomref.doc(chatroomID).collection('chats').orderBy('time',descending: false).snapshots();
}

Future<void> sendchat(String chatroomID,String message,String sendBy) async{
  CollectionReference chatroomref=FirebaseFirestore.instance.collection('Chatrooms');
  chatroomref.doc(chatroomID).update({'last_message_time':DateTime.now().millisecondsSinceEpoch});
  DateTime _now = DateTime.now();
  return await chatroomref.doc(chatroomID).collection('chats').add({
    'message': message,
    'sendBy': sendBy,
    'time':_now.millisecondsSinceEpoch,
    'timestamp':'${_now.hour}:${_now.minute}'
  }).catchError((e){print('error in send ${e.toString()}');});
}

Stream<QuerySnapshot> getChatrooms(String username) {
  CollectionReference chatroomref=FirebaseFirestore.instance.collection('Chatrooms');
  return chatroomref.where('users',arrayContains: username).orderBy('last_message_time',descending: true).snapshots();
}

Future<int> checkfriend(String fphone,String self) async{
  var snap;
  CollectionReference chatroomref=FirebaseFirestore.instance.collection('Chatrooms');
  await chatroomref.doc('${fphone}_${self}').get().then((docSnapshot){
    snap=docSnapshot;
  }).catchError((e){print('error in ${e.toString()}');});
  if (snap.exists){
    return 1;
  }
  else {
    print('into else');
    return 0;
  }
}

void setStatus(String phone,String Status) async{
  CollectionReference userref=FirebaseFirestore.instance.collection('users');
  QuerySnapshot snap;
  await userref.where('phone',isEqualTo: phone).get().then((value) => snap=value);
  var id=snap.docs.first.id;
  userref.doc(id).update({'status':Status});
}

Stream<QuerySnapshot> getStatus(String phone) {
  print('phn no is $phone');
  var id;
  CollectionReference userref=FirebaseFirestore.instance.collection('users');
  return userref.where('phone',isEqualTo: phone).snapshots();

}

void setTyping(String ChatroomID,String Typing,String phone) async{
  CollectionReference chatroomref=FirebaseFirestore.instance.collection('Chatrooms');
  await chatroomref.doc(ChatroomID).update({'${phone}_typing':Typing});;
}

Stream<QuerySnapshot> getTyping(String ChatroomID,String phone) {
  CollectionReference chatroomref=FirebaseFirestore.instance.collection('Chatrooms');
  return chatroomref.where('ChatroomID',isEqualTo: ChatroomID).snapshots();

}


void setSeen(String chatroomid,String phone,String Status) async{
  CollectionReference chatroomref=FirebaseFirestore.instance.collection('Chatrooms');
  chatroomref.doc(chatroomid).update({'${phone}_seen':Status});
}

Stream<QuerySnapshot> getSeen(String ChatroomID) {
  CollectionReference chatroomref=FirebaseFirestore.instance.collection('Chatrooms');
  return chatroomref.where('ChatroomID',isEqualTo: ChatroomID).snapshots();

}

void setLastmessage(String chatroomid,String message) async{
  CollectionReference chatroomref=FirebaseFirestore.instance.collection('Chatrooms');
  chatroomref.doc(chatroomid).update({'last_message':message});
}

Stream<QuerySnapshot> getLastmsg(String ChatroomID) {
  CollectionReference chatroomref=FirebaseFirestore.instance.collection('Chatrooms');
  return chatroomref.where('ChatroomID',isEqualTo: ChatroomID).snapshots();

}
