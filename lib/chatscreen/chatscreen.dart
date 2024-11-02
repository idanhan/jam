import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './chatcontroller.dart';

class ChatScreen extends StatelessWidget {
  final String username;
  final String otherusername;
  final String receiverEmail;
  final String userEmail;
  final double width;
  const ChatScreen(
      {super.key,
      required this.otherusername,
      required this.username,
      required this.width,
      required this.receiverEmail,
      required this.userEmail});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Consumer<Chatcontroller>(
          builder: (context, controller, child) => Column(
            children: [
              Expanded(
                child: controller.buildMessageList(userEmail, receiverEmail),
              ),
              controller.buildMessageInput(width, otherusername, height,
                  username, receiverEmail, userEmail),
            ],
          ),
        ),
      ),
    );
  }
}
