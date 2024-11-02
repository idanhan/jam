import 'package:budget_app/calander/calanderPage.dart';
import 'package:budget_app/friends/friendsScreen.dart';
import 'package:budget_app/landingpage/landingpage.dart';
import 'package:budget_app/maps/locationmodel.dart';
import 'package:budget_app/maps/mapscreen.dart';
import 'package:budget_app/profilepage/ProfileData.dart';
import 'package:budget_app/profilepage/profileScreen.dart';
import 'package:budget_app/profilepage/screenController.dart';
import 'package:budget_app/requests/requestsScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../calander/EventProvider.dart';
import '../calander/event.dart';
import '../chatscreen/chathistoryscreen.dart';
import '../profilepage/profileController.dart';

// ignore: must_be_immutable
class screenPage extends StatelessWidget {
  final List<MapEvent>? mapevents;
  final String username;
  final Image? image;
  final String email;
  final ProfileData user;
  final List<ProfileData>? friendsdata;
  final Map<String, Image>? friendsimage;
  final List<Event>? eventswithImages;
  final PageController pageController = PageController();
  late Map<String, Image> userimage;
  final bool? first;
  final int zero = 0;
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
      LandingView(
        user: user,
      ),
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
        friendslist: friendsdata,
        friendsmap: friendsimage,
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
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          itemBuilder: (context, index) {
            return Consumer<screenController>(
                builder: (context, controller, child) {
              if (events.isNotEmpty && first != null && controller.first) {
                List<MapEvent> secmapevents = events
                    .map((e) => MapEvent(
                        created_at: e.created_at,
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
                        icon: Icon(Icons.home), label: "Home"),
                    NavigationDestination(
                      icon: Icon(Icons.schedule),
                      label: "Schedule",
                    ),
                    NavigationDestination(
                        icon: Icon(Icons.person), label: "Profile"),
                    NavigationDestination(
                        icon: Icon(Icons.people), label: "Friends"),
                    NavigationDestination(
                        icon: Icon(Icons.person_add), label: "Requests"),
                    NavigationDestination(icon: Icon(Icons.map), label: "Map"),
                    NavigationDestination(icon: Icon(Icons.chat), label: "Chat")
                  ],
                ),
              );
            });
          }),
    );
  }
}
