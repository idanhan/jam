import 'package:flutter/material.dart';
import '../dropdownbuttons/insDropItem.dart';

class MusicalInstrument extends ChangeNotifier {
  List<instrumentDropItem> list2 = [
    instrumentDropItem(
        widget1: Image.asset('assets/icons/grand-piano.png'), name: "piano"),
    instrumentDropItem(
        widget1: Image.asset('assets/icons/drum-set.png'), name: "drum-set"),
    instrumentDropItem(
        widget1: Image.asset('assets/icons/electric-guitar.png'),
        name: "guitar"),
    instrumentDropItem(
        widget1: Image.asset('assets/icons/keyboard.png'), name: "keyboard"),
    instrumentDropItem(
        widget1: Image.asset('assets/icons/microphone.png'), name: "singer"),
    instrumentDropItem(
        widget1: Image.asset('assets/icons/saxophone.png'), name: "saxophone"),
    instrumentDropItem(
        widget1: Image.asset('assets/icons/trumpet.png'), name: "trumpet"),
  ];
  List<instrumentDropItem> _listinst = [];
  List<instrumentDropItem> get getlist => _listinst;
  List<String> getListAsString() => _listinst.map((e) => e.name).toList();

  void addItem(instrumentDropItem item) {
    if (_listinst.where((element) => element.name == item.name).isEmpty) {
      _listinst.add(item);
      notifyListeners();
    }
  }

  instrumentDropItem pickInst(String name) {
    return list2.where((element) => element.name == name).first;
  }

  void deleteInst(instrumentDropItem instrument) {
    _listinst.removeWhere((element) => (instrument.name == element.name));
    notifyListeners();
  }
}
