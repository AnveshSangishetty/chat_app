import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled3/database.dart';
import 'package:untitled3/otpscreen.dart';


class Authenticate extends StatelessWidget {
  const Authenticate({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //DEvice height and width
    var h=MediaQuery.of(context).size.height;
    var w=MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 1,
      child: Scaffold(
          body: Container(
            child: Column(
              children: [
                Container(
                    margin: MediaQuery.of(context).padding,
                    height: h*0.2,
                    width: w,
                    decoration: BoxDecoration(
                        color:Color.fromRGBO(34, 45, 54, 1),
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [Text(
                        'Welcome',
                        style: TextStyle(fontSize: 40,color: Colors.white,letterSpacing: 4,),
                      ),
                        SizedBox(height: 10,),
                        TabBar(
                            indicatorColor: Colors.white,
                            tabs: [
                              Tab(text:'Log in'),
                            ]
                        ),
                      ],
                    )
                ),
                Expanded(
                  child: TabBarView(children: [
                    Login(),
                  ]),
                ),
              ],
            ),
          )
      ),
    );
  }
}


class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _controller1=TextEditingController();

  int _state=0;
  bool newUser;

  @override
  Widget build(BuildContext context) {
    var h=MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,

          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Container(
            height: h,
            color: Color.fromRGBO(34, 45, 54, 1),
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
                children: [
                  SizedBox(height: 90,),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: _controller1,
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.phone,color: Colors.white,),
                      prefixText: '+91',
                      prefixStyle: TextStyle(color: Colors.white,fontSize: 17),
                      hintText: 'Phone number',
                      hintStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w100),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 2),),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 2)),
                    )
                  ),
                  SizedBox(height: 10,),
                  SizedBox(
                    width: 400,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(0, 175, 157, 1),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                      ),
                        onPressed: () async{
                        if(_controller1.text.length==10){
                          setState(() {
                            _state=1;
                          });
                          //search if user is already registerd
                          var value=await search_user('+91${_controller1.text}');
                          //if user is new---> verify screen->username screen->Chats screen
                          if(value==0){newUser=true;}
                          //else--->verify screen->Chats screen
                          else{newUser=false;}
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>verify(_controller1.text,newUser)));
                        }
                        else{
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Enter a valid mobile number')));
                        }


                        },
                        child:_state==0?Text('Get otp'):CircularProgressIndicator(color: Colors.white,)
                    ),
                  ),


                ],

            ),
          ),
        ),
    );
  }
}

