import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled3/Chatroom.dart';
import 'package:untitled3/SharedPrerences.dart';
import 'package:untitled3/database.dart';
import 'package:untitled3/main.dart';
import 'package:untitled3/username.dart';

class verify extends StatefulWidget {
  final String phone;
  final bool newUser;
  verify(this.phone,this.newUser);
  @override
  _verifyState createState() => _verifyState();
}

class _verifyState extends State<verify> {
  TextEditingController _controller=TextEditingController();
  String _code;
  @override
  Widget build(BuildContext context) {
    String phn_no='+91${widget.phone}';
    return Scaffold(
      backgroundColor:Color.fromRGBO(34, 45, 54, 1),
      appBar: AppBar(
        backgroundColor:Color.fromRGBO(34, 45, 54, 1),
        title: Text('OTP verification'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  'Sms code has been sent to +91${widget.phone}',
              style: TextStyle(fontSize: 17,color: Colors.white),),
              SizedBox(height:20,),
              TextField(
                maxLength: 6,
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                controller: _controller,
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w100),
                  hintText: 'Enter otp'
                ),
              ),
              SizedBox(height: 20,),
              MaterialButton(
                color: Color.fromRGBO(0, 175, 157, 1),
                  onPressed: () async{
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please wait..')));
                  try{
                    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: _code, smsCode: _controller.text);
                    await FirebaseAuth.instance.signInWithCredential(credential)
                        .then((value) async {
                      if(value.user!=null){
                        print('user logged in');
                      }

                    });
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    if(widget.newUser==true){
                      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>Username(widget.phone)));
                    }
                    else{
                      //set Shared preferences
                      var userName=await get_username(phn_no);
                      Sprefs.setUsername(userName);
                      Sprefs.setPhoneNo(phn_no);
                      Sprefs.setLoginState(true);
                      Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context)=>Chatroom()),(Route<dynamic> route)=>false);
                    }
                    
                  }
                  catch(e){
                    print(e.toString());
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid otp')));
                }},
              child: Text(
                  'Validate OTP',
              style: TextStyle(color: Colors.white),),),
              TextButton(onPressed: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyApp()));
              }, child: Text("Didn't receive? Try again"))
            ],
          ),
      ),
    );
  }

  verifyphone() async{
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91${widget.phone}',
      verificationCompleted: (PhoneAuthCredential credential) async{
        await FirebaseAuth.instance.signInWithCredential(credential)
            .then((value) async {
              if(value.user!=null){
              }

        });
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${e.message}')));
      },
      codeSent: (String verificationId, int resendToken) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Code sent')));
        setState(() {
          _code=verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print('tymout');
      },
      timeout: Duration(seconds: 0)
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    verifyphone();
  }
}


