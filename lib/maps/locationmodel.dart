import 'package:flutter/material.dart';

class MapEvent {
  String eventtitle;
  String location;
  List<String>? friendsimage;
  String to;
  String from;
  String description;
  Map<String, Image>? friendsImages;
  String created_at;
  MapEvent(
      {this.friendsimage,
      required this.from,
      required this.location,
      required this.to,
      required this.description,
      required this.eventtitle,
      required this.created_at,
      this.friendsImages});
  factory MapEvent.fromJson(Map<String, dynamic> json) {
    return MapEvent(
        friendsimage: (json['friends'] as List).cast<String>(),
        from: json['jamStartTime'] as String,
        location: json['locationdes'],
        to: json['jamEndTime'],
        description: json['jamDescription'],
        eventtitle: json['jamTitle'],
        created_at: json['created_at'] as String);
  }
}
