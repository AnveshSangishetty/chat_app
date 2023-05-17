import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(16, 29, 36, 1),
      appBar: AppBar(
        title: Text('About'),
      backgroundColor: Color.fromRGBO(34, 45, 54, 1),),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            Text('Created by Anvesh Sangishetty using:',style: TextStyle(color: Colors.white,fontSize: 20,letterSpacing: 2),),
            SizedBox(height: 50,),
            Row(
              children: [
                Image(image:AssetImage("assets/flutter.png"),width: 200,height: 110,),
                Text('FLUTTER',style: TextStyle(color: Colors.white,letterSpacing: 2),)
              ],
            ),
            Row(
              children: [
                Image(image:AssetImage("assets/firebase.png"),width: 200,),
                Text('FIREBASE',style: TextStyle(color: Colors.white,letterSpacing: 2),)
              ],
            )
          ],
        ),
      ),
    );
  }
}
