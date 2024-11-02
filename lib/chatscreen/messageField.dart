import 'package:budget_app/chatscreen/chatservice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageField extends StatelessWidget {
  final TextEditingController messageController;
  final double width;
  const MessageField(
      {super.key, required this.messageController, required this.width});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatService>(
      builder: (context, controller, widget) => Container(
        margin: EdgeInsets.only(left: width * 0.05, right: width * 0.01),
        width: width * 0.7,
        child: TextFormField(
          controller: messageController,
          obscureText: false,
          keyboardType: TextInputType.name,
          onChanged: (value) {
            controller.tortl(value);
          },
          textDirection: controller.direction,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Color.fromARGB(255, 245, 244, 245),
            hintText: 'message',
            border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.horizontal(left: Radius.circular(20))),
          ),
        ),
      ),
    );
  }
}
