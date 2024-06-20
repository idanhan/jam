import 'package:flutter/material.dart';

class Event {
  String title;
  String description;
  DateTime from;
  DateTime to;
  Color? backcolor;
  bool? isallday;

  Event({
    required this.from,
    required this.to,
    required this.title,
    required this.description,
    this.backcolor = Colors.black,
    this.isallday = false,
  });
}
