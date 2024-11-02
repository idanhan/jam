import 'package:budget_app/friends/friendController.dart';
import 'package:budget_app/friends/friendForm.dart';
import 'package:budget_app/profilepage/ProfileData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../requests/requestsController.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen(
      {super.key,
      required this.username,
      this.friendsimages,
      this.friendslist,
      required this.userEmail});
  final String username;
  final List<ProfileData>? friendslist;
  final Map<String, Image>? friendsimages;
  final String userEmail;
  final bool searched = false;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          child: Consumer2<FriendController, RequestsController>(
              builder: (context, friendcontroller, requestcontroller, child) {
            return SingleChildScrollView(
              child: Column(children: [
                SizedBox(
                  height: height * 0.05,
                ),
                Row(children: [
                  SizedBox(
                    width: width * 0.02,
                  ),
                  FriendsForm(
                    controller: friendcontroller,
                    width: width,
                    searched: friendcontroller.searched,
                  ),
                  GestureDetector(
                    onTap: () async {
                      // await friendcontroller.getUsers(
                      //     friendcontroller.friendsSearch.text, context);
                      await friendcontroller.getsearchedfriend(username,
                          friendcontroller.friendsSearch.text, context);
                      friendcontroller.searched = true;
                    },
                    child: Container(
                      width: width * 0.25,
                      height: height * 0.07,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          color: Theme.of(context).primaryColor,
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
                ]),
                SizedBox(
                  height: height * 0.05,
                ),
                const Divider(),
                SizedBox(
                  height: height * 0.02,
                ),
                SizedBox(
                  height: height * 0.62,
                  child: (friendcontroller.friend != null)
                      ? SizedBox(
                          height: height * 0.12,
                          child: ListView(children: [
                            Container(
                              height: height * 0.1,
                              child: GestureDetector(
                                onTap: () {
                                  final image = friendcontroller.mapfriends[
                                          friendcontroller
                                              .friendsSearch.text] ??
                                      Image.asset("assets/person.jpg");
                                  // friendcontroller.image
                                  // ??
                                  //     Image.asset("assets/person.jpg");
                                  friendcontroller.gotofriendpage(
                                      context,
                                      image,
                                      friendcontroller.friend!,
                                      username,
                                      userEmail);
                                },
                                child: Card(
                                  semanticContainer: false,
                                  margin: const EdgeInsets.all(10),
                                  elevation: 5,
                                  child: Center(
                                    child: ListTile(
                                      leading: FittedBox(
                                        fit: BoxFit.cover,
                                        child: CircleAvatar(
                                          backgroundImage: friendcontroller
                                                          .mapfriends[
                                                      friendcontroller
                                                          .friendsSearch
                                                          .text] !=
                                                  null
                                              ? friendcontroller
                                                  .mapfriends[friendcontroller
                                                      .friendsSearch.text]!
                                                  .image
                                              : Image.asset("assets/person.jpg")
                                                  .image,
                                        ),
                                      ),
                                      title:
                                          Text(friendcontroller.friend!.name),
                                      trailing: friendcontroller
                                              .friendstatus.isEmpty
                                          ? ElevatedButton(
                                              onPressed: () {
                                                friendcontroller.addFriend(
                                                    username,
                                                    friendcontroller
                                                        .friend!.name);
                                              },
                                              child: const Text("Add Friend"),
                                            )
                                          : Text(
                                              friendcontroller.friendstatus,
                                              style: TextStyle(
                                                  fontSize: height * 0.015),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ]),
                        )
                      : (friendslist != null && friendslist!.isNotEmpty)
                          ? SizedBox(
                              height: height * 0.12,
                              child: ListView.builder(
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      final image = (friendsimages != null &&
                                              friendsimages!.isNotEmpty &&
                                              friendsimages![friendslist![index]
                                                      .name] !=
                                                  null)
                                          ? friendsimages![
                                              friendslist![index].name]!
                                          : Image.asset("assets/person.jpg");
                                      friendcontroller.gotofriendpage(
                                          context,
                                          image,
                                          friendslist![index],
                                          username,
                                          userEmail);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          bottom: height * 0.01),
                                      height: height * 0.1,
                                      child: Card(
                                        elevation: 5,
                                        child: Center(
                                          child: ListTile(
                                            leading: FittedBox(
                                              fit: BoxFit.cover,
                                              child: CircleAvatar(
                                                radius: 40,
                                                backgroundImage: (friendsimages !=
                                                            null &&
                                                        friendsimages!
                                                            .isNotEmpty &&
                                                        friendsimages![
                                                                friendslist![
                                                                        index]
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
                                            title:
                                                Text(friendslist![index].name),
                                            trailing: ElevatedButton(
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder:
                                                          (context) =>
                                                              AlertDialog(
                                                                content: Text(
                                                                    "Do you like to remove ${friendslist![index].name} from your friends list?"),
                                                                actions: [
                                                                  TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        print(
                                                                            userEmail);
                                                                        print(friendslist![index]
                                                                            .email);
                                                                        friendcontroller.deletefriend(
                                                                            userEmail,
                                                                            friendslist![index].email);
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      child: const Text(
                                                                          "Delete")),
                                                                  TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      child: const Text(
                                                                          "Cancel"))
                                                                ],
                                                              ));
                                                },
                                                child: const Text("Remove")),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                itemCount: friendslist!.length,
                              ),
                            )
                          : const Center(
                              child: Text("search Friends"),
                            ),
                ),
              ]),
            );
          }),
        ),
      ),
    );
  }
}
