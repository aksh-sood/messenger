import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore=FirebaseFirestore.instance;
User loggedInUser;
bool userOnline=false;
final _auth=FirebaseAuth.instance;
class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController=TextEditingController();


  String messageText;
  // void getMessages() async {
  //   final messages = await _firestore.collection('message').get();
  //   for (var message in messages.docs) {
  //     print(message.data());
  //   }
  // }


void messageStreams()async{
  await for (var snapshot in  _firestore.collection("message").snapshots()){
    for(var message in snapshot.docs){
      print(message.data().cast());
    }
  }
}


  void getCurrentUser()async{
    try{
      final user=await _auth.currentUser;
      if(user!=null){
        loggedInUser= user;
        print(loggedInUser.email);
      }}catch(e){
      print(e);
    }
  }
  @override
  void initState() {

    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: ()
              {messageStreams();
                //Implement logout functionality
                // _auth.signOut();
                // Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      controller: messageTextController,
                      onChanged: (value) {
                   messageText=value;

                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      _firestore.collection('message').add(
                        {
                          'text': messageText,
                           'sender':loggedInUser.email,
                          'timestamp':FieldValue.serverTimestamp(),
                        }
                      );
                      messageTextController.clear();
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      builder: (context,snapshot){
        if(!snapshot.hasData){
          return Column(
            children: [
              SizedBox(height: 320,),
              Center(
                child:CircularProgressIndicator(
                  backgroundColor: Colors.blue,
                ) ,
              ),
            ],
          );
        }else{
          final messages=snapshot.data.docs;
          List<MessageBubble> messageWidgets=[];
          for(var message in messages){
            final messageText=message.get('text');
            final messageTime=(message.get('timestamp') as Timestamp).toDate();
            final  messageSender=message.data()['sender'];
            final currentUser=loggedInUser.email;
//             if (currentUser==messageSender){
// userOnline=true;
//             }

            final messageWidget=
            MessageBubble(sender: messageSender,time:messageTime,text: messageText,isMe:currentUser==messageSender );
            messageWidgets.add(messageWidget);
          }
          return Expanded(

            child: ListView(
reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
              children: messageWidgets,
            ),
          );
        }
      },
      stream: _firestore.collection("message").orderBy('timestamp',descending: true).snapshots(),
    );
  }
}


class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender,this.time,this.text,this.isMe});
  final String sender;
  final String text;
  final DateTime time;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: isMe?CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [

          Material(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
              bottomLeft: isMe?Radius.circular(30):Radius.circular(0),
              bottomRight: isMe?Radius.circular(0):Radius.circular(30),
            ),
            
            color:isMe?Colors.lightBlueAccent:Colors.white,
            
            child:Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical:8.0,horizontal: 20),
                  child: Text(
                  '$text',
                  style: TextStyle(
                    color: isMe?Colors.white:Colors.black,
                    fontSize: 17,
                  ),),
                ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     Text(
              //       '$time',
              //       style: TextStyle(
              //         color: Colors.grey,
              //       ),
              //     ),
              //   ],
              // ),
              ],
            ),),

          Text(sender,
            style: TextStyle(
              color: Colors.grey,
            ),),

          SizedBox(height: 10,),
        ],
      ),
    );
  }
}

