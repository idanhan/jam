import 'dart:ui';

import 'package:budget_app/calander/friendaddsearchform.dart';
import 'package:budget_app/calander/namedcircleavatar.dart';
import 'package:budget_app/maps/locationmodel.dart';
import 'package:budget_app/profilepage/ProfileData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import './event.dart';
import './calanderController.dart';
import '../utils/utils.dart';
import 'package:toggle_switch/toggle_switch.dart';
import './locationform.dart';
import '../maps/listMapevents.dart';

class NewEvent extends StatelessWidget {
  String username;
  Image? userimage;
  String useremail;
  List<ProfileData>? frienddata;
  Map<String, Image>? friendimage;
  String location;
  MapEvent? mapEvent;
  List<MapEvent>? events;
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
            backgroundColor: const Color.fromARGB(255, 201, 114, 216),
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
                    backgroundColor: const Color.fromARGB(255, 201, 114, 216)),
                onPressed: () {
                  if (!calandercontroller.public) {
                    calandercontroller.addedFriends.addAll({
                      username: userimage ?? Image.asset("assets/person.jpg")
                    });
                  }
                  listmapcontroller.addtolist(MapEvent(
                      friendsimage:
                          calandercontroller.addedFriends.keys.toList(),
                      from: calandercontroller.fromDate.toString(),
                      location: calandercontroller.locationdesc.text,
                      to: calandercontroller.toDate.toString(),
                      description: calandercontroller.description.text,
                      eventtitle: calandercontroller.eventname1.text));
                  calandercontroller.postjam(
                      MapEvent(
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
                      calandercontroller.addedFriends);
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
                  key: calandercontroller.formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: TextFormField(
                    validator: (value) => value != null && value.isEmpty
                        ? "title cannot be empty"
                        : null,
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
                  labels: ['Public', 'Private'],
                  icons: [Icons.public, Icons.private_connectivity],
                  activeBgColor: [Colors.blue, Colors.green],
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
                    : SizedBox(),
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
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    controller: calandercontroller.description,
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
