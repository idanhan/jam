import 'package:budget_app/calander/friendaddsearchform.dart';
import 'package:budget_app/maps/locationmodel.dart';
import 'package:budget_app/profilepage/ProfileData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './calanderController.dart';
import '../utils/utils.dart';
import 'package:toggle_switch/toggle_switch.dart';
import './locationform.dart';
import '../maps/listMapevents.dart';

class NewEvent extends StatelessWidget {
  final String username;
  final Image? userimage;
  final String useremail;
  final List<ProfileData>? frienddata;
  final Map<String, Image>? friendimage;
  final String location;
  final MapEvent? mapEvent;
  final List<MapEvent>? events;
  NewEvent(
      {super.key,
      required this.username,
      this.userimage,
      required this.location,
      this.mapEvent,
      this.frienddata,
      this.friendimage,
      this.events,
      required this.useremail});
  final date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Consumer2<CalanderController, ListMapEvents>(
        builder: (context, calandercontroller, listmapcontroller, child) =>
            Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 121, 121, 221),
            leading: CloseButton(
              color: Colors.white,
              onPressed: () {
                calandercontroller.fromDate = DateTime.now();
                calandercontroller.toDate = DateTime.now();
                calandercontroller.fromTime = TimeOfDay.now();
                calandercontroller.toTime = TimeOfDay.now();
                calandercontroller.addedFriends.clear();
                calandercontroller.listnamedavatar.clear();
                Navigator.pop(context);
              },
            ),
            actions: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    shadowColor: Colors.transparent,
                    elevation: 0,
                    backgroundColor: const Color.fromARGB(255, 121, 121, 221)),
                onPressed: () {
                  if (!calandercontroller.public) {
                    calandercontroller.addedFriends.addAll({
                      username: userimage ?? Image.asset("assets/person.jpg")
                    });
                  }
                  if (calandercontroller.locationdesc.text.isEmpty ||
                      calandercontroller.fromDate
                          .isAfter(calandercontroller.toDate) ||
                      calandercontroller.fromDate
                              .compareTo(calandercontroller.toDate) ==
                          0) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            "location is missing or from date to date are wrong!")));

                    return;
                  }
                  listmapcontroller.addtolist(MapEvent(
                      created_at: DateTime.now().toString(),
                      friendsimage:
                          calandercontroller.addedFriends.keys.toList(),
                      from: calandercontroller.fromDate.toString(),
                      location: calandercontroller.locationdesc.text,
                      to: calandercontroller.toDate.toString(),
                      description: calandercontroller.description.text,
                      eventtitle: calandercontroller.eventname1.text));
                  //this line was added
                  if (events != null) {
                    events!.add(MapEvent(
                        created_at: DateTime.now().toString(),
                        friendsimage:
                            calandercontroller.addedFriends.keys.toList(),
                        from: calandercontroller.fromDate.toString(),
                        location: calandercontroller.locationdesc.text,
                        to: calandercontroller.toDate.toString(),
                        description: calandercontroller.description.text,
                        eventtitle: calandercontroller.eventname1.text));
                  }
                  calandercontroller.postjam(
                      MapEvent(
                          created_at: DateTime.now().toString(),
                          friendsimage:
                              calandercontroller.addedFriends.keys.toList(),
                          from: calandercontroller.fromDate.toString(),
                          location: calandercontroller.locationdesc.text,
                          to: calandercontroller.toDate.toString(),
                          description: calandercontroller.description.text,
                          eventtitle: calandercontroller.eventname1.text),
                      useremail);
                  calandercontroller.saveForm(
                      context,
                      calandercontroller.locationdesc.text,
                      calandercontroller.addedFriends,
                      DateTime.now().toString(),
                      useremail);
                },
                label: const Text(
                  "save",
                  style: TextStyle(color: Colors.white),
                ),
                icon: const Icon(
                  Icons.done,
                  color: Colors.white,
                ),
              )
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: calandercontroller.calanderformKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: TextFormField(
                    validator: (value) {
                      return (value != null && value.isEmpty)
                          ? "title cannot be empty"
                          : null;
                    },
                    onTap: () {
                      calandercontroller.direction = TextDirection.rtl;
                      calandercontroller.aligntext();
                    },
                    onChanged: (value) {
                      calandercontroller.tortl(value);
                      calandercontroller.aligntext();
                    },
                    textDirection: calandercontroller.direction,
                    textAlign: calandercontroller.align,
                    controller: calandercontroller.eventname1,
                    style: const TextStyle(fontSize: 24, color: Colors.white),
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: "Add title",
                      hintStyle:
                          TextStyle(color: Color.fromARGB(255, 168, 163, 163)),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                calandercontroller.buildFrom(
                    textDate: Utils.toDateDay(calandercontroller.fromDate),
                    textTime: Utils.toDateTime(calandercontroller.fromDate),
                    Datefunction: () {
                      calandercontroller.pickfromdaytime(
                          initialtime: DateTime.now(),
                          fromEdit: DateTime.now(),
                          toEdit: DateTime.now(),
                          isfromEdit: false,
                          istoEdit: false,
                          fromDatePick: true,
                          fromTimePick: false,
                          toDatePick: false,
                          totimePick: false,
                          context: context);
                    },
                    Timefunction: () {
                      calandercontroller.pickfromdaytime(
                          initialtime: DateTime.now(),
                          fromEdit: DateTime.now(),
                          toEdit: DateTime.now(),
                          isfromEdit: false,
                          istoEdit: false,
                          toDatePick: false,
                          fromDatePick: false,
                          totimePick: false,
                          fromTimePick: true,
                          context: context);
                    },
                    width: width,
                    fromTo: "From"),
                SizedBox(
                  height: height * 0.01,
                ),
                calandercontroller.buildFrom(
                    textDate: Utils.toDateDay(calandercontroller.toDate),
                    textTime: Utils.toDateTime(calandercontroller.toDate),
                    Datefunction: () {
                      calandercontroller.pickfromdaytime(
                          initialtime: DateTime.now(),
                          fromEdit: DateTime.now(),
                          toEdit: DateTime.now(),
                          isfromEdit: false,
                          istoEdit: false,
                          toDatePick: true,
                          fromDatePick: false,
                          totimePick: false,
                          fromTimePick: false,
                          context: context);
                    },
                    Timefunction: () {
                      calandercontroller.pickfromdaytime(
                          initialtime: DateTime.now(),
                          fromEdit: DateTime.now(),
                          toEdit: DateTime.now(),
                          isfromEdit: false,
                          istoEdit: false,
                          toDatePick: false,
                          fromDatePick: false,
                          totimePick: true,
                          fromTimePick: false,
                          context: context);
                    },
                    width: width,
                    fromTo: "To"),
                SizedBox(
                  height: height * 0.01,
                ),
                ToggleSwitch(
                  minWidth: 90,
                  initialLabelIndex: calandercontroller.initialindex,
                  cornerRadius: 20,
                  activeFgColor: Colors.white,
                  inactiveBgColor: Colors.grey,
                  inactiveFgColor: Colors.white,
                  totalSwitches: 2,
                  labels: const ['Public', 'Private'],
                  icons: const [Icons.public, Icons.private_connectivity],
                  activeBgColor: const [Colors.blue, Colors.green],
                  onToggle: (index) {
                    calandercontroller.changepublic(index!);
                  },
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                !calandercontroller.public
                    ? Column(
                        children: [
                          Row(children: [
                            FriendSearchForm(
                              friendcontroller: calandercontroller.friendsearch,
                              width: width,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  calandercontroller.maptolist(
                                      friendimage,
                                      calandercontroller.friendsearch.text,
                                      frienddata);
                                },
                                child: Text("add friend")),
                          ]),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          SizedBox(
                            height: height * 0.2,
                            width: width * 0.9,
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                return Stack(
                                  children: [
                                    calandercontroller.listnamedavatar[index],
                                    IconButton(
                                      onPressed: () {
                                        calandercontroller.removeFriend(index);
                                      },
                                      icon: Icon(Icons.remove),
                                    )
                                  ],
                                );
                              },
                              itemCount:
                                  calandercontroller.listnamedavatar.length,
                              scrollDirection: Axis.horizontal,
                            ),
                          )
                        ],
                      )
                    : const SizedBox(),
                SizedBox(
                  height: height * 0.03,
                ),
                LoactionForm(
                    slocation: calandercontroller.locationdesc,
                    height: height,
                    width: width,
                    locationkey: calandercontroller.locationformkey),
                SizedBox(
                  height: height * 0.05,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(10)),
                  height: height * 0.2,
                  child: TextFormField(
                    onTap: () {
                      calandercontroller.direction = TextDirection.rtl;
                      calandercontroller.aligntext();
                    },
                    onChanged: (value) {
                      calandercontroller.tortl(value);
                      calandercontroller.aligntext();
                    },
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    controller: calandercontroller.description,
                    textAlign: calandercontroller.align,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: " Add a description",
                        hintStyle: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
