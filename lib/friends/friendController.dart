import 'dart:convert';

import 'package:budget_app/profilepage/ProfileData.dart';
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
  bool addedfriend = false;
  String friendstatus = "";

  Future<void> getUsers(String username, BuildContext context) async {
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
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("no user was found")));
    }
  }

  Future<void> getsearchedfriend(
      String username, String friendname, BuildContext context) async {
    final url = Uri.parse(
        "${constants.baseurl}/friends/searchandpending/$username,$friendname");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      Map<String, dynamic> mapitems = json.decode(response.body);
      if ((mapitems['status'] as String).toLowerCase() == 'accepted') {
        friendstatus = "friends";
        friend = ProfileData.fromJson(mapitems['friend']);
        try {
          await getImages();
        } catch (e) {
          print(e);
        }
      } else if ((mapitems['status'] as String).toLowerCase() == 'pending') {
        friendstatus = "pending";
        friend = ProfileData.fromJson(mapitems['friend']);
        try {
          await getImages();
        } catch (e) {
          print(e);
        }
      } else {
        friendstatus = "";
        friend = ProfileData.fromJson(mapitems['friend']);
        try {
          await getImages();
        } catch (e) {
          print(e);
        }
      }
      notifyListeners();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("no user was found")));
    }
  }

  Future<void> deletefriend(String username, String friendname) async {
    final url = Uri.parse(
        "${constants.baseurl}/friends/frienddelete/$username,$friendname");
    final response = await http.delete(url);
    if (response.statusCode == 200) {
      print("deleted succssefully");
      friends.removeWhere((element) => element.email == friendname);
      mapfriends.removeWhere((key, value) => key == friendname);
      notifyListeners();
    }
    if (response.statusCode == 400) {
      print(response.body);
    } else {
      print(response.body);
    }
  }

  void searchedN(bool bin) {
    if (bin) {
      searched = false;
      friend = null;
    }
  }

  void orderlist(List<ProfileData> friendlist) {
    friendlist
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  Future<void> addFriend(String username, String friendname) async {
    final url = Uri.parse("${constants.baseurl}/friends/sendrequest/$username");
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'friendname': friendname}));
    if (response.statusCode == 200) {
      friendstatus = "pending";
    }
    addedfriend = true;
    notifyListeners();
  }

  Future<void> getImage() async {
    try {
      final url = Uri.parse('${constants.baseurl}/user/image/${friend!.name}');
      final response = await http.get(url);
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
      final response = await http.get(url);
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
              location: Map<String, double>.from(e['location'])))
          .toList();

      notifyListeners();
    }
    return friends;
  }

  Future<void> gotofriendpage(BuildContext context, Image image,
      ProfileData frienddata, String currentusername, String userEmail) async {
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => FriendProfilePage(
              userEmail: userEmail,
              friendImage: image,
              frienddata: frienddata,
              currentusername: currentusername,
            )));
  }
}
