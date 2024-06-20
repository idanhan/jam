import 'package:budget_app/profilepage/ProfileData.dart';
import 'package:flutter/material.dart';
import './service.dart';

class screenController with ChangeNotifier {
  int current = 0;
  void setIndex(int val) {
    current = val;
    notifyListeners();
  }

  Future<ProfileData> getdata(
      BuildContext context, String username, String email) {
    return Services().getData(context, username, email);
  }
}
