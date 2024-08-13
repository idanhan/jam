import 'package:budget_app/maps/locationmodel.dart';
import 'package:budget_app/utils/utils.dart';
import 'package:flutter/material.dart';
import '../calander/event.dart';

class EventViewScreen extends StatelessWidget {
  final MapEvent event;
  final height;
  final width;
  bool happend = false;
  Map<String, Image>? friendimage;
  Map<String, Image> userimage;
  List<Widget> listnamedavatar = [];

  EventViewScreen(
      {super.key,
      required this.event,
      required this.height,
      required this.width,
      this.friendimage,
      required this.userimage});
  void maptolistwidget(double height) {
    if (!happend) {
      happend = !happend;
      friendimage!.addAll(userimage);
      listnamedavatar = friendimage!.entries
          .map((e) => Container(
                margin: const EdgeInsets.only(right: 4),
                child: CircleAvatar(
                  radius: height * 0.05,
                  backgroundImage: e.value.image,
                  child: Text(e.key),
                ),
              ))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (friendimage != null && friendimage!.isNotEmpty) {
      maptolistwidget(height);
      print("event is here");
      print(listnamedavatar.length);
    }
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 201, 114, 216),
        leading: const CloseButton(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(32),
        children: [
          ListTile(
            leading: const Text(
              "From",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            trailing: Text(event.from,
                style: const TextStyle(color: Colors.black, fontSize: 16)),
          ),
          SizedBox(
            height: height * 0.01,
          ),
          ListTile(
            leading: const Text(
              "To:",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            trailing: Text(event.to,
                style: const TextStyle(color: Colors.black, fontSize: 16)),
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Center(
            child: ListTile(
              leading: const Text(
                "Title:",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              trailing: Text(event.eventtitle,
                  style: const TextStyle(color: Colors.black, fontSize: 26)),
            ),
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Wrap(
            children: [
              SizedBox(
                width: width * 0.04,
              ),
              const Text(
                "Location:",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: width * 0.01,
              ),
              Text(event.location,
                  style: const TextStyle(color: Colors.black, fontSize: 16)),
            ],
          ),
          SizedBox(
            height: height * 0.01,
          ),
          ListTile(
            leading: const Text(
              "Description:",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            trailing: Text(event.description,
                style: const TextStyle(color: Colors.black, fontSize: 16)),
          ),
          friendimage != null
              ? SizedBox(
                  height: height * 0.3,
                  width: width * 0.9,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return listnamedavatar[index];
                    },
                    itemCount: listnamedavatar.length,
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
