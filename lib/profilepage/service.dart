import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './ProfileData.dart';
import '../ApiConstants.dart';

class Services with ChangeNotifier {
  Future<ProfileData> getData(
      BuildContext context, String username, String email) async {
    late ProfileData user;
    try {
      var uri = Uri.parse("${constants.baseurl}/user/$username");
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final item = json.decode(response.body);
        user = ProfileData.fromJson(item);
      }
    } catch (e) {
      print('error occured22 $e');
    }
    return user;
  }
}
