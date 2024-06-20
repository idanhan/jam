import 'dart:convert';
import 'package:budget_app/utils/signupmixin.dart';
import 'package:flutter/material.dart';
import '../ApiConstants.dart';
import 'package:http/http.dart' as http;

class QualificationController with Usersignupmixin {
  Future<void> userPost(
    String username,
    String email,
    String password,
    String created_at,
  ) async {
    var uri = Uri.parse("${constants.baseurl}/user");

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'email': email,
        'password': password,
        'created_at': created_at,
      }),
    );
  }
}
