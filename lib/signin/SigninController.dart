import 'dart:convert';
import 'dart:math';

import 'package:budget_app/calander/calanderPage.dart';
import 'package:budget_app/mainscreen/mainscreenview.dart';
import 'package:budget_app/profilepage/screenviewer.dart';
import 'package:budget_app/qualificationpage/qualificationController.dart';
import 'package:budget_app/qualificationpage/qualificationview.dart';
import 'package:budget_app/signin/Signinpage.dart';
import 'package:budget_app/signup/signUpScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../ApiConstants.dart';
import '../profilepage/service.dart';
import '../profilepage/ProfileData.dart';
import 'package:http/http.dart' as http;

class SignInController extends ChangeNotifier {
  TextEditingController UsernameController = TextEditingController();
  TextEditingController emailnameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formkey = GlobalKey<FormState>();
  Image? image;
  Map<String, Image> mapfriends = {};
  List<ProfileData> friends = [];

  Future<List<ProfileData>> getListFriends(String username) async {
    print("ppp");
    final url = Uri.parse("${constants.baseurl}/friends/friendsList/$username");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> item = json.decode(response.body);
      print(item.length);
      if (item.isNotEmpty) {
        print("hereashhhhh");
        print(item[0]['instrument']);
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

  Future<void> gotoSignUpScreen(BuildContext context) async {
    await Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SignUpScreen()));
  }

  Future<void> getUser(BuildContext context) async {
    try {
      final ProfileData userdata;
      userdata = await Services()
          .getData(context, UsernameController.text, emailnameController.text);
      // var uri =
      //     Uri.parse('${constants.baseurl}/user/${UsernameController.text}');
      // final response = await http.get(
      //   uri,
      //   headers: {'Content-Type': 'application/json'},
      // );
      // print(response.body);
      // final userdate = json.decode(response.body);
      // if (response.statusCode == 200) {
      //   if (passwordController.text != userdate['password']) {
      //     return;
      //   }
      //   if (emailnameController.text != userdate['email']) {
      //     return;
      //   }
      // await Navigator.of(context).pushReplacement(MaterialPageRoute(
      //     builder: (context) => screenPage(
      //           username: UsernameController.text,
      //           email: emailnameController.text,
      //         ),
      //     settings: const RouteSettings(name: '/CalanderPage')));
      if (userdata.password.compareTo(passwordController.text) == 0 &&
          userdata.name.compareTo(UsernameController.text) == 0) {
        await Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => screenPage(
                  image:
                      image != null ? Image(image: image!.image).image : null,
                  user: userdata,
                  username: UsernameController.text,
                  email: emailnameController.text,
                  friendsimage: mapfriends,
                  friendsdata: friends,
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
}
