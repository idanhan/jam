import 'dart:convert';

import 'package:budget_app/calander/event.dart';
import 'package:budget_app/maps/locationmodel.dart';
import 'package:budget_app/profilepage/ProfileData.dart';
import 'package:budget_app/profilepage/screenviewer.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ApiConstants.dart';
import '../utils/signupmixin.dart';
import './dropdownbuttons/insDropItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './authservices.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart' as geolocator;

class qualificationController extends ChangeNotifier with Usersignupmixin {
  List<instrumentDropItem> instlist = [];
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<MapEvent> mapevents = [];
  List<Event> events = [];
  String location = "";
  Map<String, double> locmap = {};

  Future<void> permissionhandle(String country, String city) async {
    PermissionStatus status = await Permission.location.request();
    if (status.isGranted) {
      geolocator.Position currentpos =
          await geolocator.Geolocator.getCurrentPosition(
              desiredAccuracy: geolocator.LocationAccuracy.high);
      location = "POINT(${currentpos.longitude} ${currentpos.latitude})";
      locmap['latitude'] = currentpos.latitude;
      locmap['longitude'] = currentpos.longitude;
    } else if (status.isDenied) {
      final loc = await locationFromAddress('$country,$city');
      location = "POINT(${loc.first.longitude} ${loc.first.latitude})";
      locmap['latitude'] = loc.first.latitude;
      locmap['longitude'] = loc.first.longitude;
    }
  }

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
    await permissionhandle(country, city);

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
        'location': location,
      }),
    );

    if (response.statusCode == 400) {
      print(response.body);
      print("orheear");
    }
    if (response.statusCode == 500) {
      print(response.body);
      print("and heresde");
    }
    if (response.statusCode == 200) {
      print("post succed");
    }
    notifyListeners();
  }

  Future<void> addJamMeeting(
      String title, String description, String start, String end) async {
    var uri = Uri.parse("${constants.baseurl}/user");
  }

  Future<void> signup(
      BuildContext context, String Email, String Password) async {
    final authservices = Provider.of<AuthServices>(context, listen: false);

    try {
      await authservices.signUpWithEmailAndPassword(Email, Password);
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

  Future<void> getpublicevents(String username) async {
    final url = Uri.parse('${constants.baseurl}/getonlypublicjams');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> items = json.decode(response.body);
      for (var item in items) {
        mapevents.add(MapEvent.fromJson(item));

        events.add(Event(
            location: item['locationdes'],
            from: DateTime.parse(item['jamStartTime']),
            to: DateTime.parse(item['jamEndTime']),
            title: item['jamTitle'],
            description: item['jamDescription'],
            created_at: item['created_at'] as String,
            user_created: item['user_created'] as String));
      }
    } else {
      print(response.body);
    }
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
        genres: genre,
        urls: {},
        location: locmap);

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('UserEmail', Email);
    await prefs.setString('UserPassword', password);
    await prefs.setString('UserName', userName);

    _firestore.collection('users').doc(userName).set({
      'username': userName,
      'email': Email,
    });

    await getpublicevents(userName);

    print(user.email);
    await Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => screenPage(
              email: Email,
              username: userName,
              user: user,
              mapevents: mapevents,
              eventswithImages: events,
            )));
  }
}
