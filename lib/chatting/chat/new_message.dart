import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:ntp/ntp.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {

  final _controller = TextEditingController();
  var _userEnterMessage = '';

  void _sendMessage() async {
    //메시지를 보내고 나면 unfocuing 처리
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance.collection('user').doc(user!.uid).get();

    //스마트폰 위치상의 네트워크 타임 가져오기 ntp 의존성 주입 필요
    DateTime now = await NTP.now();
    var time = now.format('H:i');

    // FirbaseStore DB 'chat'에 해당 Map을 저장하기 {key:value}
    FirebaseFirestore.instance.collection('chat').add({
      'text' : _userEnterMessage,
      'userID' : user!.uid,
      'userName' : userData.data()!['username'],
      'time' : time,
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
                maxLines: null,
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
