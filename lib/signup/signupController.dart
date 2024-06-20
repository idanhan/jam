import 'dart:convert';

import 'package:budget_app/signin/Signinpage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../ApiConstants.dart';
import '../qualificationpage/qualificationview.dart';
import '../utils/signupmixin.dart';

class SignupController extends ChangeNotifier with Usersignupmixin {
  Future<void> gotoSignInScreen(BuildContext context) async {
    await Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SignInScreen()));
  }

  // Future<void> fetchData() async {
  //   var httpuri = Uri.parse('http://127.0.0.1:5000/api/data');
  //   final response = await http.get(httpuri);
  //   if (response.statusCode == 200) {
  //     // Parse the response data
  //     print(response.body);
  //   } else {
  //     // Handle errors
  //     print('Error: ${response.statusCode}');
  //   }
  // }

  // Future<void> createTable() async {
  //   var uri = Uri.parse('http://127.0.0.1:5000/api/create_table');
  //   final response = await http.get(uri);
  //   if (response.statusCode == 200) {
  //     // Parse the response data
  //     print(response.body);
  //   } else {
  //     // Handle errors
  //     print('Error: ${response.statusCode}');
  //   }
  // }

  Future<void> userPost() async {
    var uri = Uri.parse("${constants.baseurl}/user");

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': usernameController.text,
        'email': emailController.text,
        'password': passwordController.text,
        'created_at': DateTime.now().toIso8601String(),
      }),
    );
  }

  Future<void> gotoQualificationpage(BuildContext context) async {
    await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => qualificationView(
                  email: emailController.text,
                  username: usernameController.text,
                  password: passwordController.text,
                ),
            settings: const RouteSettings(name: '/CalanderPage')));
  }

  Future<void> userGet(int userId) async {
    var uri = Uri.parse("${constants.baseurl}/user/$userId");
  }
}
