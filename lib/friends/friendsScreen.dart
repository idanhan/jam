import 'package:budget_app/friends/friendController.dart';
import 'package:budget_app/friends/friendForm.dart';
import 'package:budget_app/profilepage/ProfileData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import './friendMod.dart';

class FriendsScreen extends StatelessWidget {
  FriendsScreen(
      {super.key,
      required this.username,
      this.friendsimages,
      this.friendslist});
  final String username;
  List<ProfileData>? friendslist;
  Map<String, Image>? friendsimages;
  bool searched = false;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("search Jamit"),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: Consumer<FriendController>(
          builder: (context, controller, child) => SingleChildScrollView(
            child: Column(children: [
              SizedBox(
                height: height * 0.05,
              ),
              Row(children: [
                SizedBox(
                  width: width * 0.02,
                ),
                FriendsForm(
                  controller: controller,
                  width: width,
                  searched: controller.searched,
                ),
                GestureDetector(
                  onTap: () async {
                    await controller.getUsers(controller.friendsSearch.text);
                    controller.searched = true;
                  },
                  child: Container(
                    width: width * 0.25,
                    height: height * 0.07,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        color: const Color.fromARGB(255, 245, 244, 245),
                        borderRadius: const BorderRadius.horizontal(
                          right: Radius.circular(20),
                        )),
                    child: Center(
                      child: Row(children: [
                        SizedBox(
                          width: width * 0.015,
                        ),
                        const Icon(Icons.search),
                        const Text("search")
                      ]),
                    ),
                  ),
                ),
                // ElevatedButton(
                //     onPressed: () async {
                //       await controller.getUsers(controller.friendsSearch.text);
                //       searched = true;
                //     },
                //     style: const ButtonStyle(
                //       backgroundColor: MaterialStatePropertyAll<Color>(Color.fromARGB(255, 245, 244, 245)),

                //     ),
                //     child: ,)
              ]),
              SizedBox(
                height: height * 0.05,
              ),
              const Divider(),
              SizedBox(
                height: height * 0.02,
              ),
              Container(
                // decoration:
                //     BoxDecoration(border: Border.all(color: Colors.black)),
                height: height * 0.62,
                child: controller.searched
                    ? GestureDetector(
                        onTap: () {
                          final image = controller.image ??
                              Image.asset("assets/person.jpg");
                          controller.gotofriendpage(
                              context, image, controller.friend!);
                        },
                        child: Container(
                          height: height * 0.12,
                          child: Card(
                            elevation: 5,
                            child: Center(
                              child: ListTile(
                                leading: CircleAvatar(
                                  child: Image(
                                    image: controller.image != null
                                        ? controller.image!.image
                                        : Image.asset("assets/person.jpg")
                                            .image,
                                  ),
                                ),
                                title: Text(controller.friend!.name),
                                trailing: ElevatedButton(
                                  onPressed: () {
                                    controller.addFriend(
                                        username, controller.friend!.name);
                                  },
                                  child: const Text("Add Friend"),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : (friendslist != null && friendslist!.isNotEmpty)
                        ? ListView.builder(
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  final image = (friendsimages != null &&
                                          friendsimages!.isNotEmpty &&
                                          friendsimages![
                                                  friendslist![index].name] !=
                                              null)
                                      ? friendsimages![
                                          friendslist![index].name]!
                                      : Image.asset("assets/person.jpg");
                                  controller.gotofriendpage(
                                      context, image, friendslist![index]);
                                },
                                child: Container(
                                  height: height * 0.13,
                                  child: Card(
                                    margin: EdgeInsets.all(10),
                                    elevation: 5,
                                    child: Center(
                                      child: ListTile(
                                        leading: FittedBox(
                                          fit: BoxFit.cover,
                                          child: CircleAvatar(
                                            radius: 40,
                                            backgroundImage: (friendsimages !=
                                                        null &&
                                                    friendsimages!.isNotEmpty &&
                                                    friendsimages![
                                                            friendslist![index]
                                                                .name] !=
                                                        null)
                                                ? friendsimages![
                                                        friendslist![index]
                                                            .name]!
                                                    .image
                                                : Image.asset(
                                                    "assets/person.jpg",
                                                  ).image,
                                          ),
                                        ),
                                        title: Text(friendslist![index].name),
                                        trailing: ElevatedButton(
                                            onPressed: () {},
                                            child: const Text("Remove")),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: friendslist!.length,
                          )
                        : const Center(
                            child: Text("search Friends"),
                          ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
