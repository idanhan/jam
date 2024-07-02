import 'package:flutter/material.dart';

import 'package:budget_app/profilepage/ProfileData.dart';
import 'package:http/http.dart' as http;

import '../ApiConstants.dart';
import '../youtubeplayer.dart';

class friendPagecontroller extends ChangeNotifier {
  late ProfileData data;
  Image? image;
  bool initialized = true;
  List<Widget> listwid = [];

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

  void initialvidoes(Map<String, String> map, double height, String username) {
    if (initialized) {
      listwid = map.entries
          .map((e) => Container(
                height: height * 0.3,
                child: Column(
                  children: [
                    Text(
                      e.key,
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    YoutubeP(youtubeUrl: e.value)
                  ],
                ),
              ))
          .toList();
    }
  }
}
