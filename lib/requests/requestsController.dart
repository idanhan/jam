import 'dart:convert';

import 'package:budget_app/models/User.dart';
import 'package:budget_app/profilepage/ProfileData.dart';
import 'package:budget_app/utils/usermod.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../ApiConstants.dart';

class RequestsController extends ChangeNotifier {
  List<ProfileData> friends = [];
  List<UserModel> usersfriends = [];
  Map<String, Image> images = {};
  Image? image;
  int i = 0;

  Future<List<ProfileData>> getRequests(String username) async {
    final url =
        Uri.parse("${constants.baseurl}/friends/friendsRequsets/$username");
    final response = await http.get(url);
    print(response.statusCode);

    if (response.statusCode == 200) {
      final List<dynamic> item = json.decode(response.body);
      print(item[0]);
      friends = item.map((e) {
        getImages(e['username']);
        return ProfileData(
            name: e['username'],
            email: e['email'],
            password: e['password'],
            created_at: e['created_at'],
            country: e['country'],
            city: e['city'],
            instruments: List<String>.from(e['instrument']),
            level: e['level'],
            genres: List<String>.from(e['genre']));
      }).toList();
      for (int i = 0; i < friends.length; i++) {
        print(friends[i].name);
        await getImages(friends[i].name);
      }
      print("herrrree");
      print(friends[0].email);
      return friends;
    }
    print("error");
    return friends;
  }

  Future<void> getImages(String username) async {
    try {
      final url = Uri.parse('${constants.baseurl}/user/image/${username}');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        if (response.bodyBytes.isNotEmpty) {
          image = Image.memory(response.bodyBytes);
          images.addAll({username: image ?? Image.asset("assets/person.jpg")});
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

  Future<void> removeRequest(String username, String friendname) async {
    try {
      final url = Uri.parse(
        '${constants.baseurl}/friends/delete/$username',
      );
      final response = await http.delete(url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'friendname': friendname,
          }));
      if (response.statusCode == 200) {
        print("Request deleted");
        friends.removeWhere((element) => element.name == friendname);
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> acceptrequest(String username, String friendname) async {
    try {
      final url = Uri.parse('${constants.baseurl}/friends/put/$username');
      final response = await http.put(url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'friendname': friendname,
          }));
      if (response.statusCode == 200) {
        friends.removeWhere((element) => element.name == friendname);
        print(response.body);
        print("fuck oofff");
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }
}
