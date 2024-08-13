import 'dart:convert';

import 'package:budget_app/calander/event.dart';
import 'package:budget_app/profilepage/screenviewer.dart';

import 'package:budget_app/signup/signUpScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../ApiConstants.dart';
import '../profilepage/service.dart';
import '../profilepage/ProfileData.dart';
import '../maps/locationmodel.dart';
import '../qualificationpage/authservices.dart';

class SignInController extends ChangeNotifier {
  TextEditingController UsernameController = TextEditingController();
  TextEditingController emailnameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formkey = GlobalKey<FormState>();
  Image? image;
  Map<String, Image> mapfriends = {};
  List<ProfileData> friends = [];
  List<MapEvent> mapevents = [];
  Map<String, Image> mapeventsimages = {};
  List<Event> events = [];

  Future<List<ProfileData>> getListFriends(String username) async {
    final url = Uri.parse("${constants.baseurl}/friends/friendsList/$username");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> item = json.decode(response.body);
      print(item.length);
      if (item.isNotEmpty) {
        friends = item
            .map((e) => ProfileData(
                  name: e['username'],
                  email: e['email'],
                  password: e['password'],
                  country: e['country'],
                  created_at: e['created_at'],
                  city: e['city'],
                  instruments: List<String>.from(e['instrument']),
                  genres: List<String>.from(e['genre']),
                  level: e['level'],
                  urls: (e['urls'] as Map<String, dynamic>)
                      .map((key, value) => MapEntry(key, '$value')),
                ))
            .toList();
        for (int i = 0; i < friends.length; i++) {
          await getImages(friends[i].name);
        }
        print("this is the name");
        print(friends[0].name);
        notifyListeners();
      }
    }

    return friends;
  }

  Future<void> getImages(String friendname) async {
    try {
      final url = Uri.parse('${constants.baseurl}/user/image/${friendname}');
      final response = await http.get(url).timeout(Duration(seconds: 10));
      if (response.statusCode == 200) {
        if (response.bodyBytes.isNotEmpty) {
          mapfriends.addAll({friendname: Image.memory(response.bodyBytes)});
        }
      } else if (response.statusCode == 404) {
        image = Image.asset("assets/person.jpg");
        print("image not found");
      } else {
        image = Image.asset("assets/person.jpg");
        print("server problem");
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> getMapImages(String friendname) async {
    try {
      final url = Uri.parse('${constants.baseurl}/user/image/${friendname}');
      final response = await http.get(url).timeout(Duration(seconds: 10));
      if (response.statusCode == 200) {
        if (response.bodyBytes.isNotEmpty) {
          mapeventsimages
              .addAll({friendname: Image.memory(response.bodyBytes)});
        }
      } else if (response.statusCode == 404) {
        mapeventsimages.addAll({friendname: Image.asset("assets/person.jpg")});
        print("image not found");
      } else {
        mapeventsimages.addAll({friendname: Image.asset("assets/person.jpg")});
        print("server problem");
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> gotoSignUpScreen(BuildContext context) async {
    await Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SignUpScreen()));
  }

  Future<void> getUser(BuildContext context) async {
    try {
      getImage();
    } catch (e) {
      print(e);
    }
    try {
      final ProfileData userdata;
      userdata = await Services()
          .getData(context, UsernameController.text, emailnameController.text);
      if (userdata.password.compareTo(passwordController.text) == 0 &&
          userdata.name.compareTo(UsernameController.text) == 0) {
        print("map friends lennnn");
        print(mapevents.length);
        print(events.length);
        await Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => screenPage(
                  first: true,
                  image: image,
                  user: userdata,
                  username: UsernameController.text,
                  email: emailnameController.text,
                  friendsimage: mapfriends,
                  friendsdata: friends,
                  mapevents: mapevents,
                  eventswithImages: events,
                ),
            settings: const RouteSettings(name: '/CalanderPage')));
      }
    } catch (e) {
      print("error login $e");
    }
  }

  Future<void> getImage() async {
    try {
      final url = Uri.parse(
          '${constants.baseurl}/user/image/${UsernameController.text}');
      final response = await http.get(url).timeout(Duration(seconds: 10));
      if (response.statusCode == 200) {
        if (response.bodyBytes.isNotEmpty) {
          image = Image.memory(response.bodyBytes);

          notifyListeners();
        }
      } else if (response.statusCode == 404) {
        print("image not found");
      } else {
        print("server problem");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getFriends(int userid, int friendid) async {
    try {
      final url = Uri.parse(
          '${constants.baseurl}/friends/sendrequest/${UsernameController.text}');
    } catch (e) {}
  }

  Future<void> getcomingevents(String username) async {
    final url = Uri.parse('${constants.baseurl}/getjams');
    print("the boys");
    print(username);

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> items = json.decode(response.body);
        if (items.isNotEmpty) {
          for (var e in items) {
            // Ensure that 'friends' field is not null and is a list of strings
            final List<String> friends =
                e['friends'] != null ? List<String>.from(e['friends']) : [];

            // Check if the event is public or the user is in the friends list
            if (friends.contains(username) || e['public'] == true) {
              // Fetch images for friends asynchronously
              for (var element in friends) {
                await getMapImages(element);
              }

              // Add event to map events list
              mapevents.add(MapEvent.fromJson(e));

              // Add event to the events list
              events.add(Event(
                  location: e['locationdes'],
                  from: DateTime.parse(e['jamStartTime']),
                  to: DateTime.parse(e['jamEndTime']),
                  title: e['jamTitle'],
                  description: e['jamDescription'],
                  friendimage: Map.from(mapeventsimages))); // Clone the map

              // Clear the map for the next iteration
              mapeventsimages.clear();
            }
          }
        }
      }
      print('done coming events');
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> signin(BuildContext context, String Email, String Password,
      String username) async {
    final authservices = Provider.of<AuthServices>(context, listen: false);
    try {
      await authservices.signInWithEmailPassword(Email, Password);
      await getImage();
      await getListFriends(UsernameController.text); //added this
      await getcomingevents(UsernameController.text);
      await getUser(context);
      UsernameController.clear();
      emailnameController.clear();
      passwordController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
