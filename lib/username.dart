import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled3/database.dart';
import 'package:untitled3/Chatroom.dart';
import 'package:untitled3/SharedPrerences.dart';

class Username extends StatelessWidget {
  String phn_no;
  TextEditingController _controller=TextEditingController();
  Username(this.phn_no);
  @override
  Widget build(BuildContext context) {
    var h=MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: h,
          color: Color.fromRGBO(34, 45, 54, 1),
          padding: EdgeInsets.all(40),
          child: Column(
            children: [
              SizedBox(height: h/3,),
              Text(
                  'Username',
              style: TextStyle(fontSize: 40,color: Colors.white),),
              SizedBox(height: 10,),
              TextField(
                style: TextStyle(color: Colors.white),
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Pick a username',
                  hintStyle: TextStyle(color: Colors.white)
                ),
              ),
              SizedBox(height: 10,),
              ElevatedButton(onPressed: (){
                //set shared prefernces
                Sprefs.setLoginState(true);
                add_user('+91${phn_no}', _controller.text);
                Sprefs.setUsername(_controller.text);
                Sprefs.setPhoneNo('+91${phn_no}');
                Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context)=>Chatroom()),(Route<dynamic> route)=>false);
              }, child: Text('Submit'),style: ElevatedButton.styleFrom(
              primary: Color.fromRGBO(0, 175, 157, 1),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
        ),)
            ],
          ),
        ),
      ),
    );
  }
}
