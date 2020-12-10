import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;

  MessageBubble(this.message, this.isMe);


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Flexible(
          child: Container(
            decoration: BoxDecoration(
              color: isMe ? Colors.grey[400] : Theme
                  .of(context)
                  .accentColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(12),
                bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
              ),
            ),
            padding: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 16,
            ),

            margin: EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 8,
            ),
            child: Text(
              message,
              textAlign: isMe ? TextAlign.end : TextAlign.start,

              style:
              TextStyle(fontSize: 16, color: isMe ? Colors.black : Theme
                  .of(context)
                  .accentTextTheme
                  .headline1
                  .color),
            ),
          ),
        ),
      ],
    );
  }
}
