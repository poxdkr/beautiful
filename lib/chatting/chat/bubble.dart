import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble(this.message,this.isMe, {Key? key}) : super(key: key);

  final String message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: !isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          decoration : BoxDecoration(
            color : isMe ? Colors.grey[300] : Colors.blue,
            borderRadius: BorderRadius.only(
                topLeft:Radius.circular(12),
                topRight: Radius.circular(12),
                bottomRight: isMe ? Radius.circular(12) : Radius.circular(0),
                bottomLeft: isMe ? Radius.circular(0) : Radius.circular(12)
            ),
            ),
          width : 145,
          padding : EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          margin : EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child : Text(message,
          style : TextStyle(
            fontWeight: FontWeight.bold,
            color : isMe ? Colors.black : Colors.white,
          ),
          )
        ),
      ],
    );
  }
}
