import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../chatscreen/chatservice.dart';

class ChatHistoryController extends ChangeNotifier {
  final firestoreinst = FirebaseFirestore.instance;
  final chatservice = ChatService();

  Widget getLatestChats(String UserEmail, double height) {
    print("username");
    print(UserEmail);
    chatservice.getHistory(UserEmail);
    return StreamBuilder(
        stream: chatservice.getUserChatRooms(UserEmail),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text("No Chat History"),
            );
          } else if (snapshot.hasData) {
            return Container(
              height: height * 0.3,
              child: ListView.builder(
                itemBuilder: (context, index) => ListTile(
                  leading: Text(snapshot.data![index]['message']),
                ),
                itemCount: snapshot.data!.length,
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  Widget getLatestChats2(
      String userEmail,
      double height,
      BuildContext context,
      Map<String, Image>? friendsimages,
      String username,
      ChatService provider) {
    late Image image;
    final messageList = provider.messagelist;
    return Container(
      height: height * 0.5,
      child: ListView.builder(
        itemBuilder: (context, index) {
          if (friendsimages != null) {
            if (friendsimages
                .containsKey(messageList[index].receiverusername)) {
              image = friendsimages[messageList[index].receiverusername]!;
            } else if (friendsimages
                .containsKey(messageList[index].senderusername)) {
              image = friendsimages[messageList[index].senderusername]!;
            }
          } else {
            image = Image.asset("assets/person.jpg");
          }
          return ListTile(
            title: messageList[index].receiverusername.compareTo(username) == 0
                ? Text(messageList[index].senderusername)
                : Text(messageList[index].receiverusername),
            subtitle: Text(messageList[index].message),
            leading: CircleAvatar(backgroundImage: image.image),
          );
        },
        itemCount: messageList.length,
      ),
    );
  }

  // Widget getlatestusermessages(){

  // }
}
