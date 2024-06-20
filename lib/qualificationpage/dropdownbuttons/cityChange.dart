import 'package:flutter/material.dart';

class StateCityChange extends ChangeNotifier {
  String countryValue = 'Country';
  String cityValue = 'City';
  String stateValue = 'State';

  void changeCity(String city) {
    cityValue = city;
    notifyListeners();
  }

  void changeCountry(String country) {
    countryValue = country;
    notifyListeners();
  }

  void changeState(String State) {
    stateValue = State;
    notifyListeners();
  }
}
