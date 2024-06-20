import 'package:budget_app/friends/friendController.dart';
import 'package:budget_app/friends/friendForm.dart';
import 'package:budget_app/profilepage/ProfileData.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("search Jamit"),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Consumer<FriendController>(
        builder: (context, controller, child) => SingleChildScrollView(
          child: FutureBuilder(
            future: controller.getListFriends(username),
            builder: (context, snapshot) => Column(children: [
              SizedBox(
                height: height * 0.05,
              ),
              Wrap(children: [
                FriendsForm(
                  controller: controller,
                  width: width,
                ),
                ElevatedButton.icon(
                    onPressed: () async {
                      await controller.getUsers(controller.friendsSearch.text);
                      searched = true;
                    },
                    icon: const Icon(Icons.search),
                    label: const Text("Search"))
              ]),
              SizedBox(
                height: height * 0.05,
              ),
              Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                height: height * 0.62,
                child: searched
                    ? GestureDetector(
                        onTap: () {
                          final image = controller.image ??
                              Image.asset("assets/person.jpg");
                          controller.gotofriendpage(
                              context, image, controller.friend!);
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Image(
                              image: controller.image != null
                                  ? controller.image!.image
                                  : Image.asset("assets/person.jpg").image,
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
                      )
                    : snapshot.hasData
                        ? ListView.builder(
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  final image = controller.mapfriends[
                                          controller.friends[index].name] ??
                                      Image.asset("assets/person.jpg");
                                  controller.gotofriendpage(context, image,
                                      controller.friends[index]);
                                },
                                child: ListTile(
                                  // leading: CircleAvatar(
                                  //   child: s,
                                  // ),
                                  title: Text(snapshot.data![index].name),
                                  trailing: ElevatedButton(
                                      onPressed: () {},
                                      child: const Text("Add Friend")),
                                ),
                              );
                            },
                            itemCount: controller.friends.length,
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
