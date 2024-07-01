import 'package:budget_app/calander/calanderPage.dart';
import 'package:budget_app/friends/friendsScreen.dart';
import 'package:budget_app/maps/mapscreen.dart';
import 'package:budget_app/models/User.dart';
import 'package:budget_app/page/pageview.dart';
import 'package:budget_app/profilepage/ProfileData.dart';
import 'package:budget_app/profilepage/profileScreen.dart';
import 'package:budget_app/profilepage/screenController.dart';
import 'package:budget_app/profilepage/service.dart';
import 'package:budget_app/requests/requestsScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class screenPage extends StatelessWidget {
  String username;
  ImageProvider? image;
  String email;
  ProfileData user;
  List<ProfileData>? friendsdata;
  Map<String, Image>? friendsimage;
  screenPage(
      {super.key,
      required this.email,
      required this.username,
      required this.user,
      this.friendsdata,
      this.friendsimage,
      this.image});

  @override
  Widget build(BuildContext context) {
    print("herrrr");
    List<Widget> list = [
      CalanderPage(
        email: email,
        username: username,
      ),
      ProfileScreen(
        image: image,
        username: username,
        email: email,
        userData: user,
      ),
      FriendsScreen(
        username: username,
        friendslist: friendsdata,
        friendsimages: friendsimage,
      ),
      RequestsScreen(
        username: username,
      ),
      MapScreen()
    ];
    return PageView.builder(itemBuilder: (context, index) {
      return Consumer<screenController>(
        builder: (context, controller, child) => Scaffold(
          body: list[controller.current],
          bottomNavigationBar: NavigationBar(
            selectedIndex: controller.current,
            onDestinationSelected: (value) {
              controller.setIndex(value);
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.schedule),
                label: "schedule",
              ),
              NavigationDestination(
                  icon: Icon(Icons.person), label: "MyProfile"),
              NavigationDestination(icon: Icon(Icons.people), label: "friends"),
              NavigationDestination(
                  icon: Icon(Icons.person_add), label: "Requests"),
              NavigationDestination(icon: Icon(Icons.map), label: "map")
            ],
          ),
        ),
      );
    });
  }
}
