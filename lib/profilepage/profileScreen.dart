import 'dart:io';

import 'package:budget_app/profilepage/ProfileData.dart';
import 'package:budget_app/profilepage/desform.dart';
import 'package:budget_app/profilepage/videosform.dart';
import 'package:budget_app/youtubeplayer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../calander/calanderPage.dart';
import './profileController.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatelessWidget {
  int? current = 0;
  String username;
  ImageProvider? image;
  String email;
  ProfileData userData;
  ProfileScreen(
      {super.key,
      this.current,
      this.image,
      required this.username,
      required this.email,
      required this.userData});

  @override
  Widget build(BuildContext context) {
    // current = current ?? 0;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    // return Scaffold(
    // bottomNavigationBar: NavigationBar(
    //   selectedIndex: current!,
    //   onDestinationSelected: (value) {
    //     switch (value) {
    //       case 0:
    //         Navigator.of(context).pop(current);
    //     }
    //   },
    //   destinations: const [
    //     NavigationDestination(
    //       icon: Icon(Icons.schedule),
    //       label: "schedule",
    //     ),
    //     NavigationDestination(icon: Icon(Icons.person), label: "MyProfile"),
    //     NavigationDestination(icon: Icon(Icons.people), label: "friends"),
    //     NavigationDestination(icon: Icon(Icons.settings), label: "settings"),
    //   ],
    // ),
    // backgroundColor: Color.fromARGB(255, 231, 220, 220),
    // appBar: AppBar(),
    // body: SingleChildScrollView(
    // child: Consumer<ProfileController>(
    //   builder: (context, controller, child) => FutureBuilder(
    //       future: controller.getPostdata(context, username, email),
    //       builder: (context, snapshot) {
    //         // if (snapshot.connectionState == ConnectionState.waiting) {
    //   return CircularProgressIndicator();
    // } else if (snapshot.hasError) {
    //   return Text("there is an error ${snapshot.error}");
    // } else {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        child:
            Consumer<ProfileController>(builder: (context, controller, child) {
          controller.initialvidoes(userData.urls, height);
          return Container(
            height: height,
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.07,
                ),
                Wrap(children: [
                  SizedBox(
                    width: width * 0.1,
                  ),
                  Row(children: [
                    SizedBox(
                      width: width * 0.01,
                    ),
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 70,
                          backgroundImage: controller.croppedFile != null
                              ? Image.file(File(controller.croppedFile!.path))
                                  .image
                              : image ?? Image.asset('assets/person.jpg').image,
                        ),
                        Positioned(
                            right: 10,
                            bottom: 10,
                            child: IconButton(
                                onPressed: () async {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: Text("Edit or delete image"),
                                            actions: [
                                              ElevatedButton.icon(
                                                  onPressed: () async {
                                                    await controller
                                                        .pickimage();
                                                    await controller.cropp();
                                                    Navigator.pop(context);
                                                    if (controller
                                                            .croppedFile !=
                                                        null) {
                                                      await controller
                                                          .uploadImage(
                                                              context,
                                                              username,
                                                              File(controller
                                                                  .croppedFile!
                                                                  .path));
                                                    } else {
                                                      print("is null");
                                                    }
                                                  },
                                                  icon: const Icon(Icons.edit),
                                                  label: const Text("Edit")),
                                              ElevatedButton.icon(
                                                  onPressed: () {
                                                    controller.delete();
                                                    Navigator.pop(context);
                                                  },
                                                  icon:
                                                      const Icon(Icons.delete),
                                                  label: const Text("Delete"))
                                            ],
                                          ));
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Color.fromARGB(255, 247, 242, 242),
                                ))),
                      ],
                    ),
                    SizedBox(
                      width: width * 0.06,
                    ),
                    Text(
                      username,
                      style: const TextStyle(fontSize: 30),
                    ),
                  ]),
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
                              height: height * 0.01,
                            ),
                            Row(children: [
                              const Text("country: "),
                              Text(userData.country),
                            ]),
                            Row(children: [
                              const Text("city: "),
                              Text(userData.city),
                            ]),
                            Wrap(children: [
                              const Text("instruments: "),
                              Wrap(
                                children: userData.instruments
                                    .map((e) => Text("$e  "))
                                    .toList(),
                              )
                            ]),
                            Row(
                              children: [
                                const Text("level: "),
                                Text(userData.level),
                              ],
                            ),
                            Wrap(
                              children: [
                                const Text("genres: "),
                                Wrap(
                                  children: userData.genres
                                      .map((e) => Text("$e  "))
                                      .toList(),
                                )
                              ],
                            ),
                          ]),
                    ],
                  )
                ]),
                SizedBox(
                  height: height * 0.02,
                ),
                VideoForm(width: width, controller: controller),
                SizedBox(
                  height: height * 0.02,
                ),
                Desform(width: width, controller: controller, height: height),
                SizedBox(
                  height: height * 0.02,
                ),
                ElevatedButton(
                    onPressed: () {
                      controller.addplayer(controller.youtubeurlController.text,
                          controller.Desccontroller.text, username, height);
                      print("done");
                    },
                    child: const Text("add youtube video")),
                const Divider(),
                Container(
                  height: height * 0.30,
                  margin: EdgeInsets.all(height * 0.01),
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      print(controller.listwid.length);
                      return controller.listwid[index];
                    },
                    itemCount: controller.listwid.length,
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
                // }
//               }),
//         ),
//       ),
//     );
//   }
// }
