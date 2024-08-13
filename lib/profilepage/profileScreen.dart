import 'dart:io';
import 'dart:ui';

import 'package:budget_app/profilepage/ProfileData.dart';
import 'package:budget_app/profilepage/desform.dart';
import 'package:budget_app/profilepage/videosform.dart';
import 'package:budget_app/qualificationpage/authservices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import './profileController.dart';

class ProfileScreen extends StatelessWidget {
  int? current = 0;
  String username;
  Image? image;
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
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final provider = Provider.of<AuthServices>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: false,
        actions: [
          const Text("log-out"),
          IconButton(
              onPressed: () async {
                await provider.signout();
                // await Navigator.of(context).pushReplacement(
                //     MaterialPageRoute(builder: (context) => SignInScreen()));
                Navigator.pop(context); //needs to clear everything after logout
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.red,
              ))
        ],
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Consumer<ProfileController>(
              builder: (context, controller, child) {
            print("null or not");
            print(image == null);
            controller.initialvidoes(userData.urls, height, width);
            return Container(
              height: height,
              child: Column(
                children: [
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
                              backgroundImage: controller.imageProvidernew !=
                                      null
                                  ? controller.imageProvidernew!.image
                                  : image != null
                                      ? image!.image
                                      : Image.asset('assets/person.jpg').image),
                          Positioned(
                              right: 10,
                              bottom: 10,
                              child: IconButton(
                                  onPressed: () async {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title:
                                                  Text("Edit or delete image"),
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
                                                    icon:
                                                        const Icon(Icons.edit),
                                                    label: const Text("Edit")),
                                                ElevatedButton.icon(
                                                    onPressed: () {
                                                      controller.delete();
                                                      Navigator.pop(context);
                                                    },
                                                    icon: const Icon(
                                                        Icons.delete),
                                                    label: const Text("Delete"))
                                              ],
                                            ));
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Color.fromARGB(255, 211, 217, 233),
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
                    height: height * 0.01,
                  ),
                  VideoForm(width: width, controller: controller),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Desform(width: width, controller: controller, height: height),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        controller.addplayer(
                            controller.youtubeurlController.text,
                            controller.Desccontroller.text,
                            username,
                            height,
                            width);
                      },
                      child: const Text("add youtube video")),
                  const Divider(),
                  Container(
                    color: Theme.of(context).primaryColor,
                    height: height * 0.4,
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
