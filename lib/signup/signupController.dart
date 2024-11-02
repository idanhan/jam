import 'dart:async';
import 'dart:convert';

import 'package:budget_app/signin/Signinpage.dart';
import 'package:budget_app/signup/emailverification.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../ApiConstants.dart';
import '../qualificationpage/qualificationview.dart';
import '../utils/signupmixin.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupController extends ChangeNotifier with Usersignupmixin {
  bool isverified = false;
  User? user;

  Future<void> gotoSignInScreen(BuildContext context) async {
    await Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SignInScreen()));
  }

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

  Future<void> gotoverificationpage() async {
    final userauth =
        await FirebaseAuth.instance.currentUser?.sendEmailVerification();
  }

  Future<void> gotoQualificationpage(BuildContext context) async {
    final url = Uri.parse(
        "${constants.baseurl}/user/checkifnameisindb/${usernameController.text}");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text("username already exists please choose another username")));
      return;
    }
    UserCredential userCredential = await FirebaseAuth.instance //new from here
        .createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
    user = userCredential.user;

    if (user != null && !user!.emailVerified) {
      await user!.sendEmailVerification();

      // Notify the user to check their email
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            "A verification email has been sent to ${user!.email}. Please check your inbox."),
      ));
    } //to here

    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerificationScreen(
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
              username: usernameController.text.trim()),
        ));

    emailController.clear();
    usernameController.clear();
    passwordController.clear();
  }

  Future<bool> checkEmailVerification(String email) async {
    return FirebaseAuth.instance.isSignInWithEmailLink(email);
  }

  Future<void> waitForEmailVerification(BuildContext context, String username1,
      String password1, String email1) async {
    while (!isverified) {
      print("Checking email verification status...");

      // Reload the user to get updated email verification status
      await FirebaseAuth.instance.currentUser?.reload();
      user = FirebaseAuth.instance.currentUser;

      if (user != null && user!.emailVerified) {
        isverified = true;

        // Notify the user and navigate to the next page
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Email verified! Welcome ${user!.email}")));

        await Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => qualificationView(
                username: username1, email: email1, password: password1),
            settings: const RouteSettings(name: '/CalanderPage')));
        break; // Exit the loop
      }

      print("Email not verified yet.");
      await Future.delayed(Duration(seconds: 5)); // Wait before checking again
    }
  }

  Future<void> userGet(int userId) async {
    var uri = Uri.parse("${constants.baseurl}/user/$userId");
  }
}
