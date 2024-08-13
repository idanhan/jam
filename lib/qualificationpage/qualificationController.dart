import 'dart:convert';

import 'package:budget_app/profilepage/ProfileData.dart';
import 'package:budget_app/profilepage/screenviewer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../ApiConstants.dart';
import '../utils/signupmixin.dart';
import '../calander/calanderPage.dart';
import './dropdownbuttons/insDropItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './authservices.dart';

class qualificationController extends ChangeNotifier with Usersignupmixin {
  List<instrumentDropItem> instlist = [];
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
        'genre': genre,
        'urls': [],
        'urldes': [],
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

  void signup(BuildContext context, String Email, String Password) async {
    final authservices = Provider.of<AuthServices>(context, listen: false);

    try {
      await authservices.signUpWithEmailAndPassword(Email, Password);
      print("signup");
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> signin(
      BuildContext context, String Email, String Password) async {
    final authservices = Provider.of<AuthServices>(context, listen: false);
    try {
      await authservices.signInWithEmailPassword(Email, Password);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  // Future<void> gotoCalander(
  //     BuildContext context, String email, String username) async {
  //   await Navigator.of(context).pushReplacement(MaterialPageRoute(
  //       builder: (context) => CalanderPage(
  //             username: username,
  //             email: email,
  //           ),
  //       settings: const RouteSettings(name: '/CalanderPage')));
  // }

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
      genres: genre,
      urls: {},
    );
    _firestore.collection('users').doc(userName).set({
      'username': userName,
      'email': Email,
    });
    print(user.email);
    await Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => screenPage(
              email: Email,
              username: userName,
              user: user,
            )));
  }
}
