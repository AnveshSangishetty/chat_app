import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:untitled3/About.dart';
import 'package:untitled3/Chat_screen.dart';
import 'package:untitled3/Constants.dart';
import 'package:untitled3/SharedPrerences.dart';
import 'package:untitled3/database.dart';
import 'package:untitled3/main.dart';
import 'package:untitled3/search.dart';

class Chatroom extends StatefulWidget {
  @override
  _ChatroomState createState() => _ChatroomState();
}

class _ChatroomState extends State<Chatroom> with WidgetsBindingObserver {

  Stream chatrooms;

  Widget Chatroomslist(){
    //stream to get all chats of user
    return StreamBuilder(
        stream:chatrooms,
        builder: (context,snapshot) {
          if(!snapshot.hasData) return Center(child:CircularProgressIndicator());
          return ListView.builder(
            itemCount: snapshot.data.docs.length,
              itemBuilder: (context,index){
              String cid=snapshot.data.docs[index].data()['ChatroomID'];
                List<dynamic> users=snapshot.data.docs[index].data()['users'];
                users.remove(Constants.myphn);
                String friend=users[0];
              return ChatroomTile(snapshot.data.docs[index].data()['${friend}_name'],cid,snapshot.data.docs[index].data()['last_message'],snapshot.data.docs[index].data()['last_message_time'],snapshot.data.docs[index].data()['${Constants.myphn}_seen']);
              });
        }
    );
  }

  @override
  void initState() {
    initials();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }



  //to set online status
  @override
  void didChangeAppLifecycleState(AppLifecycleState state){
    if(state==AppLifecycleState.resumed){
      setStatus(Constants.myphn, 'online');
    }
    else{
      var time_=DateTime.now();
      setStatus(Constants.myphn, '${time_.day}_${time_.month}_${time_.year}_${time_.hour}_${time_.minute}');
    }
  }

  initials() async{
    //get shared preferences
    //save them as constants
    Constants.myphn=await Sprefs.getPhoneNo();
    Constants.myname=await Sprefs.getUsername();
    var s=getChatrooms(Constants.myphn);
    setStatus(Constants.myphn, 'online');
    setState(() {
      chatrooms=s;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(16, 29, 36, 1),
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 70,
        backgroundColor: Color.fromRGBO(34, 45, 54, 1),
        title: Text(
            'Chats',
        style: TextStyle(fontSize: 30,letterSpacing: 3),),
        /////////////LOG OUT///////////
        actions: [
          PopupMenuButton(
            color: Color.fromRGBO(34, 45, 54, 1),
            icon: Icon(Icons.more_vert),
              itemBuilder: (BuildContext context)=><PopupMenuEntry>[
                PopupMenuItem(
                  value: 'About',
                    child: ListTile(
                      onTap: (){
                        Navigator.pop(context,'About');
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => About()
                        ));
                      },
                      title: Text('About',style: TextStyle(color: Colors.white),),
                    )),
                PopupMenuItem(
                  value: 'Signout',
                    child: ListTile(
                      title: Text('Sign Out',style: TextStyle(color: Colors.white)),
                      onTap:(){
                        Navigator.pop(context,'Signout');
                        showDialog(context: context,
                            builder: (BuildContext context){
                              return AlertDialog(
                                title: Text('Are you sure?'),
                                actions: [
                                  TextButton(onPressed: () async {
                                    await Sprefs.setLoginState(false);
                                    FirebaseAuth.instance.signOut();
                                    Navigator.pushReplacement(
                                        context, MaterialPageRoute(builder: (context) => MyApp()));
                                  }, child: Text('Confirm')),
                                  TextButton(onPressed:(){ Navigator.pop(context);}, child:Text('Cancel'))
                                ],
                              );
                            });
                      },
                    )),
              ]
          )
        ],
        ////////////LOG OUT//////////////
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(0, 175, 157, 1),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Search()));
        },
        child: Icon(Icons.add_outlined)),
      body: DefaultTabController(
    length:1,
    child:Column(
      children: [
        Container(
          color: Color.fromRGBO(34, 45, 54, 1),
          child: TabBar(
            labelColor: Color.fromRGBO(0, 175, 157, 1),
              indicatorColor: Color.fromRGBO(0, 175, 157, 1),
              tabs: [
                Tab(text:'Chats'),
              ]
          ),
        ),
        Expanded(child: TabBarView(children: [Container(child: Chatroomslist()),],))
      ],
    )
    )
      
    );
  }
}

class ChatroomTile extends StatefulWidget {
  String username;
  String chatroomID;
  String msg;
  String seen;
  int time;
  ChatroomTile(this.username,this.chatroomID,this.msg,this.time,this.seen);

  @override
  _ChatroomTileState createState() => _ChatroomTileState();
}

class _ChatroomTileState extends State<ChatroomTile> {

  @override
  Widget build(BuildContext context) {
    //to convert from Millisecondssinceepoch to readable format
    var tym=DateTime.fromMillisecondsSinceEpoch(widget.time).toString();
    var list=tym.split(' ');
    var date=list[0].split('-');
    var tym_list=list[1].split(':');

    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => ChatScreen(widget.chatroomID)
        ));
      },
      child: Column(
        children: [
          Container(
            color: Color.fromRGBO(16, 29, 36, 0.95),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child:
                Row(
                  children: [
                    Icon(Icons.account_circle,color: Colors.white,),
                    SizedBox(
                      width: 12,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.username,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontFamily: 'OverpassRegular',
                                fontWeight: FontWeight.w300)),
                        widget.msg.length>30?Text('${widget.msg.substring(0,30)}...',style: TextStyle(color: Colors.white,fontWeight: widget.seen=='false'?FontWeight.bold:FontWeight.w300),)
                            :Text(widget.msg,style: TextStyle(color: Colors.white,fontWeight:  widget.seen=='false'?FontWeight.bold:FontWeight.w300),)
                      ],
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("${Constants.months[int.parse(date[1])-1]} ${date[2]} ${tym_list[0]}:${tym_list[1]}",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w100),),
                        widget.seen=='false'?Container(
                          height: 30,
                          decoration: BoxDecoration(color: Colors.blue,shape: BoxShape.circle),
                          child: Text('   '),
                        ):SizedBox.shrink()
                      ],
                    )

                  ],
                ),

          ),
          Divider(color: Colors.white70,height: 1,)
        ],
      ),
    );
  }
}

