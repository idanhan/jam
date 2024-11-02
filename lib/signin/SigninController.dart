import 'dart:convert';

import 'package:budget_app/calander/event.dart';
import 'package:budget_app/profilepage/screenviewer.dart';

import 'package:budget_app/signup/signUpScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ApiConstants.dart';
import '../profilepage/service.dart';
import '../profilepage/ProfileData.dart';
import '../maps/locationmodel.dart';
import '../qualificationpage/authservices.dart';

class SignInController extends ChangeNotifier {
  TextEditingController UsernameController = TextEditingController();
  TextEditingController emailnameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Image? image;
  Map<String, Image> mapfriends = {};
  List<ProfileData> friends = [];
  List<MapEvent> mapevents = [];
  Map<String, Image> mapeventsimages = {};
  List<Event> events = [];
  List<ProfileData> pending = [];
  List<String> friendsnames = [];
  List<ProfileData> appendingfriends = [];

  Future<List<ProfileData>> getListFriends(String username) async {
    final url = Uri.parse("${constants.baseurl}/friends/friendsList/$username");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> item = json.decode(response.body);
      if (item.isNotEmpty) {
        friends = item.map((e) {
          friendsnames.add(e['username']);
          return ProfileData(
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
              location: (e['location'] as Map<String, double>)
                  .map((key, value) => MapEntry(key, value)));
        }).toList();
        // for (int i = 0; i < friends.length; i++) {
        //   await getImages(friends[i].name);
        // }
        mapfriends = await getallfriendsimages();
        notifyListeners();
      }
    }

    return friends;
  }

  Future<void> getImages(String friendname) async {
    try {
      final url = Uri.parse('${constants.baseurl}/user/image/${friendname}');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        if (response.bodyBytes.isNotEmpty) {
          mapfriends.addAll({friendname: Image.memory(response.bodyBytes)});
        }
      } else if (response.statusCode == 404) {
        mapfriends.addAll({friendname: Image.asset("assets/person.jpg")});
        print("image not found");
      } else {
        // image = Image.asset("assets/person.jpg");
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
      final response = await http.get(url);
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

  Future<Map<String, Image>> getallfriendsimages() async {
    final namelist = friendsnames.join(",");
    final url = Uri.parse("${constants.baseurl}/user/friendimages/$namelist");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      Map<String, dynamic> imagesmap = json.decode(response.body);

      return imagesmap.map((key, value) {
        if (value != null) {
          return MapEntry(key, Image.memory(base64Decode(value)));
        } else {
          return MapEntry(key, Image.asset('assets/person.jpg'));
        }
      });
    } else {
      throw Exception('Failed to load images');
    }
  }

  Future<void> gotoSignUpScreen(BuildContext context) async {
    await Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SignUpScreen()));
  }

  Future<void> getUser(BuildContext context,
      {String? username, String? password, String? useremail}) async {
    try {
      final ProfileData userdata;
      final String name;
      final String email;
      final String Password;
      if (UsernameController.text.isEmpty) {
        name = username!;
      } else {
        name = UsernameController.text;
      }
      if (emailnameController.text.isEmpty) {
        email = useremail!;
      } else {
        email = emailnameController.text;
      }
      if (passwordController.text.isEmpty) {
        Password = password!;
      } else {
        Password = passwordController.text;
      }
      if (image == null) {
        print("is null");
      } else {
        print("not null ");
      }
      userdata = await Services().getData(context, name, email);
      if (userdata.password.compareTo(Password) == 0 &&
          userdata.name.compareTo(name) == 0) {
        await Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => screenPage(
                  first: true,
                  image: image,
                  user: userdata,
                  username: name,
                  email: email,
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

  Future<void> getImage({String? username}) async {
    try {
      final name = username ?? UsernameController.text;
      final url = Uri.parse('${constants.baseurl}/user/image/$name');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        if (response.bodyBytes.isNotEmpty) {
          image = Image.memory(response.bodyBytes);

          notifyListeners();
        }
      } else if (response.statusCode == 404) {
        image = Image.asset("assets/person.jpg");
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
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> items = json.decode(response.body);
        if (items.isNotEmpty) {
          print("now");
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
                  friendimage: Map.from(mapeventsimages),
                  created_at: e['created_at'] as String,
                  user_created: e['user_created'] as String)); // Clone the map
              // Clear the map for the next iteration
              mapeventsimages.clear();
            }
          }
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> getuserevents(String username) async {
    final url = Uri.parse('${constants.baseurl}/getjamsbyusername/$username');
    Map<String, Image> mapfriendstemp = {};
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> items = json.decode(response.body);
        if (items.isNotEmpty) {
          for (var e in items) {
            final List<String> friends =
                e['friends'] != null ? List<String>.from(e['friends']) : [];

            if (friends.contains(username) || e['public'] == true) {
              for (String friend in friends) {
                if (mapfriends.containsKey(friend)) {
                  mapeventsimages.addAll({
                    friend:
                        mapfriends[friend] ?? Image.asset("assets/person.jpg")
                  });
                } else {
                  await getMapImages(friend);
                }
              }

              mapevents.add(MapEvent.fromJson(e));

              events.add(Event(
                  location: e['locationdes'],
                  from: DateTime.parse(e['jamStartTime']),
                  to: DateTime.parse(e['jamEndTime']),
                  title: e['jamTitle'],
                  description: e['jamDescription'],
                  friendimage: Map.from(mapeventsimages),
                  created_at: e['created_at'] as String,
                  user_created: e['user_created'] as String));
            }
            mapeventsimages.clear();
          }
        }
      } else {
        print("error here");
        print(response.body);
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> getuserrequests(String username) async {
    final url =
        Uri.parse("${constants.baseurl}/friends/userrRequests/$username");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> items = json.decode(response.body);
      friends = items.map((e) => ProfileData.fromJson(e)).toList();
    }
  }

  Future<void> signin(BuildContext context, String Email, String Password,
      String username) async {
    final authservices = Provider.of<AuthServices>(context, listen: false);
    try {
      final String emails =
          emailnameController.text.isEmpty ? Email : emailnameController.text;
      final String usernames =
          UsernameController.text.isEmpty ? username : UsernameController.text;
      final String passwords =
          passwordController.text.isEmpty ? Password : passwordController.text;
      final cred = await authservices.signInWithEmailPassword(Email, Password);
      if (UsernameController.text.isNotEmpty &&
          emailnameController.text.isNotEmpty &&
          passwordController.text.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();

        await prefs.setString('UserEmail', emailnameController.text);
        await prefs.setString('UserPassword', passwordController.text);
        await prefs.setString('UserName', UsernameController.text);
      }
      if (context.mounted) {
        ProfileData userdata2 =
            await Services().getData(context, usernames, emails);
        if (userdata2.name.isEmpty && userdata2.email.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("email address is wrong!")));
          return;
        }
        if (userdata2.password.compareTo(passwords) != 0) {
          print(userdata2.password);
          print(passwords);
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("password is wrong!")));
          return;
        }
        if (userdata2.name.compareTo(usernames) != 0) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("username is wrong!")));
          return;
        }

        await getImage(username: usernames);
        await getListFriends(usernames); //added this
        await getuserevents(usernames);
        await getUser(context,
            useremail: emails, username: usernames, password: passwords);
        UsernameController.clear();
        emailnameController.clear();
        passwordController.clear();
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
