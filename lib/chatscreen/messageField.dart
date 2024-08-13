import 'package:flutter/material.dart';

class MessageField extends StatelessWidget {
  TextEditingController messageController;
  double width;
  MessageField(
      {super.key, required this.messageController, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: width * 0.05, right: width * 0.01),
      width: width * 0.7,
      child: TextFormField(
        controller: messageController,
        obscureText: false,
        keyboardType: TextInputType.name,
        decoration: const InputDecoration(
          filled: true,
          fillColor: Color.fromARGB(255, 245, 244, 245),
          hintText: 'message',
          border: OutlineInputBorder(
              borderRadius: BorderRadius.horizontal(left: Radius.circular(20))),
        ),
      ),
    );
  }
}
