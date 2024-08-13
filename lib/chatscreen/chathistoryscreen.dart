import 'package:budget_app/chatscreen/chatcontroller.dart';
import 'package:budget_app/chatscreen/chathistorycontroller.dart';
import 'package:budget_app/chatscreen/messagemodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import './chatservice.dart';

class ChatHistoryScreen extends StatelessWidget {
  final String useremail;
  final String username;
  final Map<String, Image>? friendsImages;
  const ChatHistoryScreen(
      {super.key,
      required this.useremail,
      required this.friendsImages,
      required this.username});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final provider = Provider.of<ChatService>(context, listen: false);
    late Image image;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Chat History'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: provider.getUserChatRooms2(useremail),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else if (!snapshot.hasData) {
              return const Center(
                child: Text("no recent history"),
              );
            } else if (snapshot.hasData) {
              return Container(
                margin: EdgeInsets.only(top: height * 0.01),
                height: height * 0.5,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    if (friendsImages != null) {
                      if (friendsImages!.containsKey(
                          snapshot.data![index].receiverusername)) {
                        image = friendsImages![
                            snapshot.data![index].receiverusername]!;
                      } else if (friendsImages!
                          .containsKey(snapshot.data![index].senderusername)) {
                        image = friendsImages![
                            snapshot.data![index].senderusername]!;
                      } else {
                        image = Image.asset("assets/person.jpg");
                      }
                    } else {
                      image = Image.asset("assets/person.jpg");
                    }
                    return GestureDetector(
                      onTap: () {
                        String otherusername = username.contains(
                                snapshot.data![index].receiverusername)
                            ? snapshot.data![index].senderusername
                            : snapshot.data![index].receiverusername;
                        String receiverEmail = useremail.contains(
                                snapshot.data![index].receiveruserEmail)
                            ? snapshot.data![index].senderEmail
                            : snapshot.data![index].receiveruserEmail;
                        provider.gotomessagepage(context, otherusername,
                            username, useremail, receiverEmail, width);
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                            bottom: height * 0.02, left: width * 0.01),
                        child: Wrap(
                          alignment: WrapAlignment.start,
                          spacing: width * 0.1,
                          children: [
                            CircleAvatar(
                              backgroundImage: image.image,
                              radius: height * 0.05,
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  height: height * 0.015,
                                ),
                                snapshot.data![index].receiverusername
                                            .compareTo(username) ==
                                        0
                                    ? Text(
                                        snapshot.data![index].senderusername,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: width * 0.05),
                                      )
                                    : Text(
                                        snapshot.data![index].receiverusername,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: width * 0.05)),
                                Text(snapshot.data![index].message),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: snapshot.data!.length,
                ),
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
