import 'package:budget_app/calander/calanderController.dart';
import 'package:budget_app/maps/locationmodel.dart';
import 'package:budget_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class EventViewScreen extends StatelessWidget {
  final MapEvent event;
  final double height;
  final double width;
  bool happend = false;
  final Map<String, Image>? friendimage;
  final Map<String, Image> userimage;
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
      if (event.friendsImages != null) {
        friendimage!.addAll(event.friendsImages!);
      }
      listnamedavatar = friendimage!.entries
          .map((e) => Container(
                margin: const EdgeInsets.only(right: 10, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: height * 0.05,
                      backgroundImage: e.value.image,
                      backgroundColor: Colors.white,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Text(
                        e.key,
                        style: const TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              ))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (friendimage != null && friendimage!.isNotEmpty) {
      maptolistwidget(height);
    }
    final listavatar =
        Provider.of<CalanderController>(context, listen: false).listnamedavatar;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 121, 121, 221),
        leading: const CloseButton(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(32),
        children: [
          ListTile(
            leading: const Text(
              "From",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            trailing: Text(Utils.toDate(DateTime.parse(event.from)),
                style: const TextStyle(color: Colors.white, fontSize: 16)),
          ),
          SizedBox(
            height: height * 0.01,
          ),
          ListTile(
            leading: const Text(
              "To:",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            trailing: Text(Utils.toDate(DateTime.parse(event.to)),
                style: const TextStyle(color: Colors.white, fontSize: 16)),
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Center(
            child: ListTile(
              leading: const Text(
                "Title:",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              trailing: Text(event.eventtitle,
                  style: const TextStyle(color: Colors.white, fontSize: 16)),
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
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: width * 0.01,
              ),
              Text(event.location,
                  style: const TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Wrap(
            children: [
              const ListTile(
                leading: Text(
                  "Description:",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              Text(event.description,
                  style: const TextStyle(color: Colors.white, fontSize: 16))
            ],
          ),
          friendimage != null
              ? SizedBox(
                  height: height * 0.2,
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
