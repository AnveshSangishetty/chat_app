import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:untitled3/Chatroom.dart';
import 'package:untitled3/SharedPrerences.dart';
import 'package:untitled3/Splash.dart';
import 'log in.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
      home:MyApp()
  )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool IsUserLoggedIn;
  String phone;

  @override
  void initState() {
    getUserloginState();
    super.initState();
  }

  //to check if user is logged in
  void getUserloginState() async{
    var val=await Sprefs.getLoginState()??false;
    setState(() {
      IsUserLoggedIn=val;
    });
  }

  @override
  Widget build(BuildContext context) {

    //until we get value of IsUserLoggedIn--->splash screen
    //if user is logged in-->Homepage
    //else--->Loginpage
    return IsUserLoggedIn==null?Splash():IsUserLoggedIn==false?Authenticate():Chatroom();
  }
}
