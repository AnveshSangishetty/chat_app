import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled3/Constants.dart';
import 'package:untitled3/database.dart';

class ChatScreen extends StatefulWidget {
  String chatroomID;
  ChatScreen(this.chatroomID);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  Stream ChatStream;
  Stream StatusStream;
  Stream TypingStream;
  Stream SeenStream;
  String friend;
  TextEditingController _controller=TextEditingController();

  Widget Chats(){
    //get previous messages
    return StreamBuilder(
      stream: ChatStream,
        builder: (context,snapshot){
        if(snapshot.hasData){
          var l=snapshot.data.docs.length;
          setSeen(widget.chatroomID,Constants.myphn,'true');
        return ListView.builder(
          reverse: true,
          shrinkWrap: true,
          itemCount: l,
            itemBuilder: (context,index){
            index=l-index-1;
            String date=DateTime.fromMillisecondsSinceEpoch(snapshot.data.docs[index].data()['time']).toString();
            var list=date.split(' ')[0].split('-');
              return MessageTile(snapshot.data.docs[index].data()['message'],snapshot.data.docs[index].data()['sendBy']==Constants.myphn,snapshot.data.docs[index].data()['timestamp'],"${Constants.months[int.parse(list[1])-1]} ${list[2]}");
            });}
        else{
          return Container();
        }
        }
    );
  }

  @override
  void initState() {
    var stream=getchat(widget.chatroomID);
    List<String> users=widget.chatroomID.split('_');
    users.remove(Constants.myphn);
    String frnd=users[0];
    var stream2=getStatus(frnd);
    var stream3=getTyping(widget.chatroomID, Constants.myphn);
    var stream4=getSeen(widget.chatroomID);
    setState(() {
      friend=frnd;
      ChatStream=stream;
      StatusStream=stream2;
      TypingStream=stream3;
      SeenStream=stream4;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(16, 29, 36, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(35, 45, 54, 1),
        leading: IconButton(icon:Icon(Icons.arrow_back),onPressed: (){Navigator.pop(context);},),
        title: StreamBuilder(
          stream: StatusStream,
          builder: (context, snapshot1){
            return StreamBuilder(
                stream: TypingStream,
                builder: (context, snapshot2){
                  if(snapshot1.hasData && snapshot2.hasData)
                  {
                    String text;
                    var typing=snapshot2.data.docs[0].data()['${friend}_typing'];
                    String status=snapshot1.data.docs[0].data()['status'];
                    if(status!='online'){
                      var time=status.split('_');
                      var current_time=DateTime.now();
                      if(time[0]==current_time.day.toString() && time[1]==current_time.month.toString() && time[2]==current_time.year.toString()){
                        text='last seen today at ${time[3]}:${time[4]}';
                      }
                      else text='last seen ${time[0]}/${time[1]}/${time[2]} at ${time[3]}:${time[4]}';
                    }
                    return Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(friend),
                          if(typing=='true') Text('typing...',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),)
                          else if(status=='online') Text(status,style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),)
                          else Text(text,style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300))

                        ],
                      ),
                    );
                  }
                else return Container(color:Color.fromRGBO(35, 45, 54, 1) ,);
                  }
                );
            },
          ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Column(
          children: [
            Expanded(child: Chats()),
            StreamBuilder(
                stream: SeenStream,
                builder: (context, snapshot4){
                  if(snapshot4.hasData){
                    String seen=snapshot4.data.docs[0].data()['${friend}_seen'];
                    return seen=='true'?Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.centerRight,
                      height: 20,
                      child: Text('seen',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w100),),
                    ):SizedBox(height: 10,);
                  }
                  else return SizedBox(height: 10,);
                } ),
            Container(
              decoration: BoxDecoration(color: Colors.grey,borderRadius: BorderRadius.circular(30),),
              child: Row(
                children: [
                  SizedBox(width: 10,),
                  Expanded(
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        controller: _controller,
                        decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: 'Type a message..'
                        ),
                        onChanged: (text){
                          if(text!=''){
                            setTyping(widget.chatroomID, 'true', Constants.myphn);
                          }
                          else setTyping(widget.chatroomID, 'false', Constants.myphn);
                        },
                      )),
                  Material(
                    borderRadius: BorderRadius.circular(30),
                    color:Colors.grey,
                    child: IconButton(
                      splashColor: Colors.grey,
                      icon:Icon(Icons.send),
                      onPressed: (){
                        if(_controller.text.isNotEmpty){
                          sendchat(widget.chatroomID,_controller.text , Constants.myphn);
                          setLastmessage(widget.chatroomID, _controller.text);
                          _controller.text='';
                          setTyping(widget.chatroomID, 'false', Constants.myphn);
                          setSeen(widget.chatroomID, friend, 'false');
                        }

                      },
                      iconSize: 24,
                      splashRadius: 24,),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,)
          ],
        ),
      )
    );
  }
}

//message box
class MessageTile extends StatelessWidget {
  String date;
  String message;
  bool sendByme;
  String time;
  MessageTile(this.message,this.sendByme,this.time,this.date);
  @override
  Widget build(BuildContext context) {
    var w=MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 3),
      padding: EdgeInsets.symmetric(horizontal: 3),
      alignment: sendByme?Alignment.centerRight:Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 7),
        constraints: BoxConstraints(maxWidth: w*0.8),
        decoration: sendByme?BoxDecoration(color: Color.fromRGBO(5, 70, 64,1),borderRadius:BorderRadius.only(topLeft: Radius.circular(10),bottomRight: Radius.circular(5)))
        :BoxDecoration(color: Color.fromRGBO(33, 46, 54,1),borderRadius:BorderRadius.only(topRight: Radius.circular(10),bottomLeft: Radius.circular(5))),
        child: Column(
          crossAxisAlignment: sendByme?CrossAxisAlignment.end:CrossAxisAlignment.start,
          children: [
            Wrap(
              alignment: WrapAlignment.end,
              crossAxisAlignment:WrapCrossAlignment.end,
              children: [
                Text(message,style: TextStyle(fontSize: 17,color: Colors.white,fontWeight: FontWeight.w300),),
                SizedBox(width: 2,),

              ],
            ),
            Text('$date $time',style: TextStyle(fontSize: 8,color: Colors.white,fontWeight: FontWeight.w300))
          ],
        ),
      ),
    );
  }
}

