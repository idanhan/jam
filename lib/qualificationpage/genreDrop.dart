import 'package:flutter/material.dart';

class GenresList extends ChangeNotifier {
  List<String> _genrelist = [];
  List<String> list = [
    'Classical',
    'Jazz',
    'Blues',
    'Reggae',
    'R&B',
    'classic rock',
    'proggresive rock',
    'techno',
    'oriental'
  ];

  List<String> get getGenreList => _genrelist;

  void addItem(String item) {
    if (!_genrelist.contains(item)) {
      _genrelist.add(item);
      notifyListeners();
    }
  }

  void delteItem(String item) {
    _genrelist.removeWhere((element) => element == item);
    notifyListeners();
  }
}
