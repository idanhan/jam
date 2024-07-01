import 'dart:convert';

import 'package:budget_app/friends/friendModel.dart';
import 'package:budget_app/profilepage/ProfileData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../ApiConstants.dart';
import '../friendPage/friendpageScreen.dart';

class FriendController extends ChangeNotifier {
  TextEditingController friendsSearch = TextEditingController();
  ProfileData? friend;
  bool isFriend = false;
  Image? image;
  List<ProfileData> friends = [];
  Map<String, Image> mapfriends = {};
  bool searched = false;

  Future<void> getUsers(String username) async {
    final url = Uri.parse("${constants.baseurl}/friends/search/$username");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final friendJson = json.decode(response.body);
      friend = ProfileData.fromJson(friendJson);
      try {
        await getImages();
      } catch (e) {
        print("no image was found");
      }

      notifyListeners();
    } else if (response.statusCode == 400) {
      print(response.body);
    } else if (response.statusCode == 500) {
      print(response.body);
    }
  }

  void searchedN(bool bin) {
    if (bin) {
      searched = false;
      notifyListeners();
    }
  }

  Future<void> addFriend(String username, String friendname) async {
    final url = Uri.parse("${constants.baseurl}/friends/sendrequest/$username");
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'friendname': friendname}));
    if (response.statusCode == 200) {
      print("request sent");
    }
  }

  Future<void> getImage() async {
    try {
      final url = Uri.parse('${constants.baseurl}/user/image/${friend!.name}');
      final response = await http.get(url).timeout(Duration(seconds: 10));
      if (response.statusCode == 200) {
        if (response.bodyBytes.isNotEmpty) {
          image = Image.memory(response.bodyBytes);
        }
      } else if (response.statusCode == 404) {
        image = null;
        print("image not found");
      } else {
        image = null;
        print("server problem");
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> getImages() async {
    try {
      final url = Uri.parse('${constants.baseurl}/user/image/${friend!.name}');
      final response = await http.get(url).timeout(Duration(seconds: 10));
      if (response.statusCode == 200) {
        if (response.bodyBytes.isNotEmpty) {
          mapfriends.addAll({friend!.name: Image.memory(response.bodyBytes)});
        }
      } else if (response.statusCode == 404) {
        image = null;
        print("image not found");
      } else {
        image = null;
        print("server problem");
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<List<ProfileData>> getListFriends(String username) async {
    final url = Uri.parse("${constants.baseurl}/friends/friendsList/$username");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> item = json.decode(response.body);
      print("here");
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
                urls: Map<String, String>.from(e['urls']),
              ))
          .toList();
      print("this is the name");
      print(friends[0].name);
      notifyListeners();
    }
    return friends;
  }

  Future<void> gotofriendpage(
      BuildContext context, Image image, ProfileData frienddata) async {
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => FriendProfilePage(
              friendImage: image,
              frienddata: frienddata,
            )));
  }
}
