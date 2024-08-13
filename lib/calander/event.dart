import 'package:flutter/material.dart';

class Event {
  String title;
  String description;
  DateTime from;
  DateTime to;
  Color? backcolor;
  bool? isallday;
  String location;
  Map<String, Image>? friendimage;

  Event({
    this.friendimage,
    required this.location,
    required this.from,
    required this.to,
    required this.title,
    required this.description,
    this.backcolor = const Color.fromARGB(255, 98, 149, 197),
    this.isallday = false,
  });
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
        location: json['locationdes'],
        from: json['jamStartTime'],
        to: json['jamEndTime'],
        title: json['jamTitle'],
        description: json['jamDescription']);
  }
}
