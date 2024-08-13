import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import './messageField.dart';
import './chatservice.dart';
import './chat_bubbe.dart';

class Chatcontroller extends ChangeNotifier {
  final firestoreinst = FirebaseFirestore.instance;
  TextEditingController messageController = TextEditingController();
  final ChatService chatService = ChatService();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  void sendmessage(String receiverusername, String message, String username,
      String receiverEmail, String userEmail) async {
    if (messageController.text.isNotEmpty) {
      print("now here");
      print(receiverEmail);
      await chatService.sendmessage(
          receiverusername, message, username, receiverEmail, userEmail);
      notifyListeners();
      messageController.clear();
    }
  }

  Widget buildMessageInput(double width, String receiverusername, double height,
      String username, String receiverEmail, String userEmail) {
    return Row(
      children: [
        Expanded(
            child: MessageField(
                messageController: messageController, width: width)),
        IconButton(
            onPressed: () {
              sendmessage(receiverusername, messageController.text, username,
                  receiverEmail, userEmail);
            },
            icon: const Icon(
              Icons.arrow_upward,
              size: 40,
            )),
        SizedBox(
          height: height * 0.14,
        )
      ],
    );
  }

  Widget buildMessageList(String userEmail, String otheruserEmail) {
    return StreamBuilder(
        stream: chatService.getMessages(userEmail, otheruserEmail),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error${snapshot.error}');
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Text("waiting"),
            );
          } else {
            return ListView(
              children: snapshot.data!.docs
                  .map((document) => buildMessageItem(document))
                  .toList(),
            );
          }
        });
  }

  Widget buildMessageItem(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    print("username here");
    print(data['senderemail']);
    print(firebaseAuth.currentUser!.uid);

    var alignment = (data['senderemail'] == firebaseAuth.currentUser!.email)
        ? Alignment.centerRight
        : Alignment.centerLeft;
    var color = (data['senderemail'] == firebaseAuth.currentUser!.email)
        ? Colors.blue
        : Colors.grey;

    return Container(
      margin: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
      alignment: alignment,
      child: Column(
        children: [
          Text(
            data['senderusername'],
            style: const TextStyle(color: Colors.black),
          ),
          ChatBubble(
            message: data['message'],
            color: color,
          ),
        ],
      ),
    );
  }
}
