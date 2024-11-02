import 'dart:convert';

import 'package:budget_app/calander/calanderController.dart';
import 'package:budget_app/calander/event.dart';
import 'package:budget_app/calander/eventediting.dart';
import 'package:budget_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../ApiConstants.dart';

class EventViewPage extends StatelessWidget {
  final Event event;
  final double height;
  final double width;
  List<Widget> listnamedavatar = [];
  bool happend = false;
  String username;
  String useremail;

  EventViewPage(
      {super.key,
      required this.event,
      required this.height,
      required this.width,
      required this.username,
      required this.useremail});

  @override
  Widget build(BuildContext context) {
    // if (event.friendimage != null && event.friendimage!.isNotEmpty) {
    //   provider.maptolistwidget(
    //       height, context, happend, event, username, listnamedavatar);
    // }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = Provider.of<CalanderController>(context, listen: false);
      if (event.friendimage != null && event.friendimage!.isNotEmpty) {
        provider.maptolistwidget(height, context, happend, event, username,
            listnamedavatar, useremail);
      }
    });
    // if (event.friendimage != null && event.friendimage!.isNotEmpty) {
    //   maptolistwidget(height, context);
    // }
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 121, 121, 221),
        leading: const CloseButton(),
        actions: event.user_created == useremail
            ? buildViewingActions(context, event)
            : [],
      ),
      body:
          Consumer<CalanderController>(builder: (context, controller, widget) {
        print(
            "Listnamedavatar length inside Consumer: ${listnamedavatar.length}");
        return ListView(
          padding: const EdgeInsets.all(32),
          children: [
            ListTile(
              leading: const Text(
                "From:",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              trailing: Text("${Utils.toDate(event.from)}",
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
              trailing: Text("${Utils.toDate(event.to)}",
                  style: const TextStyle(color: Colors.white, fontSize: 16)),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  ListTile(
                    leading: const Text(
                      "Title:",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    trailing: Text("${event.title}",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ],
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
            Wrap(alignment: WrapAlignment.center, children: [
              const ListTile(
                leading: Text(
                  "Description:",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              Text(event.description,
                  textAlign: TextAlign.end,
                  style: const TextStyle(color: Colors.white, fontSize: 16)),
              SizedBox(
                height: height * 0.05,
              )
            ]),
            event.friendimage != null
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
        );
      }),
    );
  }

  List<Widget> buildViewActions(BuildContext context, Event event) {
    return [
      IconButton(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => EventEditingpage(
                    username: username,
                    event: event,
                    emailname: useremail,
                  ))),
          icon: const Icon(Icons.edit))
    ];
  }

  List<Widget> buildViewingActions(
    BuildContext context,
    Event event,
  ) {
    return [
      IconButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EventEditingpage(
                      username: username,
                      event: event,
                      emailname: useremail,
                    )));
          },
          icon: const Icon(
            Icons.edit,
            color: Colors.white,
          )),
      IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Row(children: [
                  Icon(Icons.delete),
                  SizedBox(
                    width: 0.05,
                  ),
                  Text("Delete Event?")
                ]),
                actions: deleteActions(context),
              ),
            );
          },
          icon: const Icon(
            Icons.delete,
            color: Colors.white,
          ))
    ];
  }

  List<Widget> deleteActions(
    BuildContext context,
  ) {
    return [
      TextButton(
          onPressed: () {
            context.read<CalanderController>().delete(event, context);
            deletejam(useremail, event.created_at);
          },
          child: Text("Delete Event")),
      TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Cancel"))
    ];
  }

  void maptolistwidget(double height, BuildContext context) {
    if (!happend) {
      happend = !happend;
      listnamedavatar = event.friendimage!.entries
          .map((e) => username != e.key
              ? Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 4),
                      child: CircleAvatar(
                        radius: height * 0.05,
                        backgroundImage: e.value.image,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: Text(
                        e.key,
                        style: const TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                )
              : Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 4),
                      child: Stack(children: [
                        CircleAvatar(
                          radius: height * 0.05,
                          backgroundImage: e.value.image,
                        ),
                        Positioned(
                            left: 2,
                            child: IconButton(
                              icon: const Icon(
                                Icons.remove_circle,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: const Text(
                                              "remove yourself from this jam?"),
                                          actions: [
                                            TextButton(
                                                onPressed: () {},
                                                child: const Text("Yes")),
                                            TextButton(
                                                onPressed: () {},
                                                child: const Text("No"))
                                          ],
                                        ));
                              },
                            ))
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: Text(
                        e.key,
                        style: const TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ))
          .toList();
    }
  }

  Future<void> deletejam(String useremail, String created_at) async {
    final url = Uri.parse("${constants.baseurl}/deletejam");
    final response = await http.delete(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "user_created": useremail,
          "created_at": created_at,
        }));
  }
}
