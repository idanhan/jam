import 'dart:convert';

import 'package:budget_app/profilepage/ProfileData.dart';
import 'package:budget_app/profilepage/screenviewer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../ApiConstants.dart';
import '../utils/signupmixin.dart';
import '../calander/calanderPage.dart';
import './dropdownbuttons/insDropItem.dart';

class qualificationController extends ChangeNotifier with Usersignupmixin {
  List<instrumentDropItem> instlist = [];

  Future<void> register(
      String userName,
      String Email,
      String password,
      String created_at,
      String country,
      String city,
      List<String> instrument,
      String level,
      List<String> genre) async {
    var uri = Uri.parse("${constants.baseurl}/user");

    // if (formkey.currentState!.validate() != true) {
    //   return;
    // }

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': userName,
        'email': Email,
        'password': password,
        'created_at': created_at,
        'country': country,
        'city': city,
        'instrument': instrument,
        'level': level,
        'genre': genre
      }),
    );

    if (response.statusCode == 400) {
      print(response.body);
    }
    if (response.statusCode == 500) {
      print(response.body);
    }
    notifyListeners();
  }

  Future<void> addJamMeeting(
      String title, String description, String start, String end) async {
    var uri = Uri.parse("${constants.baseurl}/user");
  }

  Future<void> gotoCalander(
      BuildContext context, String email, String username) async {
    await Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => CalanderPage(
              username: username,
              email: email,
            ),
        settings: const RouteSettings(name: '/CalanderPage')));
  }

  Future<void> gotoScreenview(
      BuildContext context,
      String userName,
      String Email,
      String password,
      String created_at,
      String country,
      String city,
      List<String> instrument,
      String level,
      List<String> genre) async {
    final user = ProfileData(
        name: userName,
        email: Email,
        password: password,
        created_at: created_at,
        country: country,
        city: city,
        instruments: instrument,
        level: level,
        genres: genre);
    await Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) =>
            screenPage(email: Email, username: userName, user: user)));
  }
}
