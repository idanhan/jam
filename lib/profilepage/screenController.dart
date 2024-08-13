import 'package:budget_app/calander/event.dart';
import 'package:budget_app/profilepage/ProfileData.dart';
import 'package:flutter/material.dart';
import '../maps/locationmodel.dart';
import './service.dart';

class screenController with ChangeNotifier {
  bool first = true;
  int current = 0;
  void setIndex(int val) {
    current = val;
    notifyListeners();
  }

  Future<ProfileData> getdata(
      BuildContext context, String username, String email) {
    return Services().getData(context, username, email);
  }

  void changefirst() {
    first = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void getallevents(List<Event> events, List<MapEvent>? mapevents) {
    if (first && events.isNotEmpty) {
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
      first = false;
    }
  }
}
