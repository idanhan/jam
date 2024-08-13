import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  Color color;
  ChatBubble({super.key, required this.message, required this.color});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: const EdgeInsets.all(12),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(10), color: color),
      child: Text(
        message,
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
