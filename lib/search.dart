import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:untitled3/Chat_screen.dart';
import 'package:untitled3/Constants.dart';
import 'package:untitled3/database.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController _controller=TextEditingController();
  int _state=0;
  int val=0;
  String searched;
  String searched_username;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(16, 29, 36, 1),
      body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
        child: Container(
          margin: MediaQuery.of(context).padding,
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(height: 10,),
              Container(
                decoration: BoxDecoration(color: Colors.grey,borderRadius: BorderRadius.circular(30),),
                child: Row(
                  children: [
                    Material(
                      borderRadius: BorderRadius.circular(30),
                        color:Colors.grey,
                        child:IconButton(icon: Icon(Icons.arrow_back_ios_rounded), onPressed: (){Navigator.pop(context);},iconSize: 20,splashRadius: 20,splashColor: Colors.grey,)),
                    Expanded(
                        child: TextField(
                          controller: _controller,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: 'Search by Phone number'
                          ),
                        )),
                    Material(
                      borderRadius: BorderRadius.circular(30),
                      color:Colors.grey,
                      child: IconButton(
                        splashColor: Colors.grey,
                        icon:Icon(Icons.search),
                        onPressed: () async{
                          if(_controller.text.length!=0){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Loading...'),backgroundColor: Colors.grey[700],));
                            var value=await search_user(_controller.text);
                            if(value!=0){searched_username=await get_username(_controller.text);}
                            setState(() {
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              val=value;
                              _state=1;
                              searched=_controller.text;
                            });
                          }
                          else{
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter phone number')));
                          }


                        },
                        iconSize: 24,
                        splashRadius: 24,),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30,),
              _state==0? Expanded(
                child: Container(
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Enter a phone number',style: TextStyle(color: Colors.white),),
                              Text(' with country code',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,letterSpacing: 1),)
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("For ex, type ",style: TextStyle(color: Colors.white)),
                              Text("'+911234567890'",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                              Text(" and click on  ",style: TextStyle(color: Colors.white)),
                              Icon(Icons.search,color: Colors.white,)
                            ],
                          )
                        ],
                      ),
                  ),
              )
              :val!=0?ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: [
                  Container(
                    decoration: BoxDecoration(color:Colors.grey[400],borderRadius: BorderRadius.all(Radius.circular(20))),
                  child:ListTile(
                    subtitle: Text('${searched}'),
                    title: Text(searched_username),
                    trailing: Material(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                        color: Colors.blueGrey[100],
                        child:IconButton(
                          icon: Icon(Icons.chat_outlined),
                          onPressed: () async{
                            var i=await checkfriend(searched, Constants.myphn);
                            if(i==0) {
                              create_chatroom(Constants.myphn, searched,Constants.myname,searched_username);
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ChatScreen('${Constants.myphn}_$searched')));
                            }
                            else {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ChatScreen('${searched}_${Constants.myphn}')));}

                          },)
                    ),
                  )
                  )],
              ):Expanded(
                child: Container(
                  child:Center(child: Text('Not found',style: TextStyle(color: Colors.white),),),
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}
