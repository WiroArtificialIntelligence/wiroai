import 'package:flutter/material.dart';

class TextBubble extends StatelessWidget {
  final String message;
  final bool fromUser;

  const TextBubble({Key? key, required this.message, required this.fromUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: fromUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        decoration: BoxDecoration(
          color: fromUser ? Colors.blueAccent : Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.0),
            topRight: Radius.circular(12.0),
            bottomLeft: fromUser ? Radius.circular(12.0) : Radius.zero,
            bottomRight: fromUser ? Radius.zero : Radius.circular(12.0),
          ),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: fromUser ? Colors.white : Colors.black87,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}
