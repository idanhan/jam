import 'package:budget_app/calander/calanderPage.dart';
import 'package:budget_app/friends/friendsScreen.dart';
import 'package:budget_app/maps/locationmodel.dart';
import 'package:budget_app/maps/mapscreen.dart';
import 'package:budget_app/page/pageviewcontroller.dart';
import 'package:budget_app/profilepage/ProfileData.dart';
import 'package:budget_app/profilepage/profileScreen.dart';
import 'package:budget_app/profilepage/screenController.dart';
import 'package:budget_app/requests/requestsScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../calander/EventProvider.dart';
import '../calander/event.dart';
import '../chatscreen/chatscreen.dart';
import '../chatscreen/chathistoryscreen.dart';
import '../profilepage/profileController.dart';

class screenPage extends StatelessWidget {
  List<MapEvent>? mapevents;
  String username;
  Image? image;
  String email;
  ProfileData user;
  List<ProfileData>? friendsdata;
  Map<String, Image>? friendsimage;
  List<Event>? eventswithImages;
  final PageController pageController = PageController();
  late Map<String, Image> userimage;
  bool? first;
  int zero = 0;
  screenPage(
      {super.key,
      this.first,
      required this.email,
      required this.username,
      required this.user,
      this.friendsdata,
      this.friendsimage,
      this.image,
      this.mapevents,
      this.eventswithImages});

  @override
  Widget build(BuildContext context) {
    final profileimageprovider =
        Provider.of<ProfileController>(context, listen: true).imageProvidernew;
    List<Event> events =
        Provider.of<EventProvider>(context, listen: false).evetns;
    if (image != null || profileimageprovider != null) {
      userimage = {username: profileimageprovider ?? image!};
    } else {
      userimage = {username: Image.asset('assets/person.jpg')};
    }

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    List<Widget> list = [
      CalanderPage(
        email: email,
        username: username,
        friendsdata: friendsdata,
        friendsimage: friendsimage,
        mapEvents: mapevents,
        eventslist: eventswithImages,
        userimage: profileimageprovider ?? image,
      ),
      ProfileScreen(
        image: profileimageprovider ?? image,
        username: username,
        email: email,
        userData: user,
      ),
      FriendsScreen(
        username: username,
        friendslist: friendsdata,
        friendsimages: friendsimage,
        userEmail: user.email,
      ),
      RequestsScreen(
        username: username,
      ),
      MapScreen(
          mapevents: mapevents,
          friendsimage: friendsimage,
          height: height,
          width: width,
          userimage: userimage),
      ChatHistoryScreen(
        username: username,
        useremail: email,
        friendsImages: friendsimage,
      ),
    ];
    return PopScope(
      canPop: false,
      child: PageView.builder(
          controller: pageController,
          itemBuilder: (context, index) {
            return Consumer<screenController>(
                builder: (context, controller, child) {
              if (events.isNotEmpty && first != null && controller.first) {
                print("now updated");
                List<MapEvent> secmapevents = events
                    .map((e) => MapEvent(
                        friendsimage: e.friendimage!.keys.toList(),
                        from: e.from.toString(),
                        location: e.location,
                        to: e.to.toString(),
                        description: e.description,
                        eventtitle: e.title))
                    .toList();
                mapevents!.addAll(secmapevents);
                controller.changefirst();
              }
              return Scaffold(
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
                    NavigationDestination(
                        icon: Icon(Icons.people), label: "friends"),
                    NavigationDestination(
                        icon: Icon(Icons.person_add), label: "Requests"),
                    NavigationDestination(icon: Icon(Icons.map), label: "map"),
                    NavigationDestination(icon: Icon(Icons.chat), label: "Chat")
                  ],
                ),
              );
            });
          }),
    );
  }
}
