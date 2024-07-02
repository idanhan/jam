import 'package:budget_app/friendPage/friendpageController.dart';
import 'package:budget_app/profilepage/ProfileData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FriendProfilePage extends StatelessWidget {
  Image friendImage;
  ProfileData frienddata;
  FriendProfilePage(
      {super.key, required this.friendImage, required this.frienddata});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Consumer<friendPagecontroller>(
            builder: (context, controller, child) {
          controller.initialvidoes(frienddata.urls, height, frienddata.name);
          return Container(
            height: height,
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.01,
                ),
                Wrap(
                  children: [
                    SizedBox(
                      width: width * 0.1,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: width * 0.01,
                        ),
                        CircleAvatar(
                          radius: 70,
                          backgroundImage: friendImage.image,
                        ),
                        SizedBox(
                          width: width * 0.06,
                        ),
                        Text(
                          frienddata.name,
                          style: const TextStyle(fontSize: 30),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: width * 0.1,
                    ),
                    Wrap(
                      alignment: WrapAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: width * 0.01,
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: height * 0.04,
                              ),
                              Row(children: [
                                const Text("country: "),
                                Text(frienddata.country),
                              ]),
                              Row(children: [
                                const Text("city: "),
                                Text(frienddata.city),
                              ]),
                              Wrap(children: [
                                const Text("instruments: "),
                                Wrap(
                                  children: frienddata.instruments
                                      .map((e) => Text("$e  "))
                                      .toList(),
                                )
                              ]),
                              Row(
                                children: [
                                  const Text("level: "),
                                  Text(frienddata.level),
                                ],
                              ),
                              Wrap(
                                children: [
                                  const Text("genres: "),
                                  Wrap(
                                    children: frienddata.genres
                                        .map((e) => Text("$e  "))
                                        .toList(),
                                  )
                                ],
                              ),
                            ]),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    const Divider(),
                    Container(
                      height: height * 0.50,
                      margin: EdgeInsets.all(height * 0.01),
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return controller.listwid[index];
                        },
                        itemCount: controller.listwid.length,
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
