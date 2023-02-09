import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {

  final _controller = TextEditingController();
  var _userEnterMessage = '';

  void _sendMessage(){
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance.collection('chat').add({
      'text' : _userEnterMessage,
      'userID' : user!.uid,
      'time' : Timestamp.now(),
    });
    _controller.clear();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin : EdgeInsets.all(8),
      padding : EdgeInsets.all(8),
      child : Row(
        children: [
          Expanded(
              child: TextField(
                controller: _controller,
                decoration : InputDecoration(
                  labelText: 'Send a Message',
                ) ,
                onChanged: (value){
                  setState(() {
                    _userEnterMessage = value;
                  });
                },
              )
          ),
          IconButton(
              onPressed: _userEnterMessage.trim().isEmpty ? null :_sendMessage,
              icon: Icon(Icons.send),
              color : Colors.blue

          )
        ],
      )
    );
  }
}
