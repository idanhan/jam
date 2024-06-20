import 'package:flutter/material.dart';

class ChangeLevel extends ChangeNotifier {
  List<String> list = ['Beginner', 'Intermediate', 'Professional'];
  String current = 'Beginner';

  void changeLevel(String level) {
    current = level;
    notifyListeners();
  }
}
