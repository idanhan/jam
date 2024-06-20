import 'package:budget_app/friends/friendModel.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:budget_app/profilepage/ProfileData.dart';
import 'package:budget_app/profilepage/service.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import '../ApiConstants.dart';

class friendPagecontroller extends ChangeNotifier {
  late ProfileData data;
  Image? image;

  Future<void> getImage(String username) async {
    try {
      final url = Uri.parse('${constants.baseurl}/user/image/$username');
      final response = await http.get(url).timeout(const Duration(seconds: 2));
      if (response.statusCode == 200) {
        if (response.bodyBytes.isNotEmpty) {
          image = Image.memory(response.bodyBytes);
        }
      } else if (response.statusCode == 404) {
        image = null;
        print("image not found");
      } else {
        image = null;
        print("server problem");
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
