import 'package:budget_app/signup/signupController.dart';
import 'package:flutter/material.dart';
import '../utils/signupmixin.dart';

class SignupForm extends StatelessWidget with Usersignupmixin {
  final SignupController controller;
  final width;
  SignupForm({super.key, required this.controller, required this.width});

  @override
  Widget build(BuildContext context) {
    return Form(
        key: controller.formkey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            Container(
              width: width * 0.9,
              child: TextFormField(
                  textAlign: TextAlign.center,
                  controller: controller.usernameController,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(255, 248, 216, 248),
                    hintText: 'UserName',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      print("here it is");
                      return 'Please enter a valid username.';
                    }
                    return null; // means input is correct
                  }),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: width * 0.9,
              child: TextFormField(
                  textAlign: TextAlign.center,
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(255, 248, 216, 248),
                    hintText: 'Email',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid email.';
                    }
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Please enter a valid email address.';
                    }
                    return null; // means input is correct
                  }),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: width * 0.9,
              child: TextFormField(
                  textAlign: TextAlign.center,
                  controller: controller.passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(255, 248, 216, 248),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    hintText: 'password',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      print("here it is");
                      return 'Please enter a valid password.';
                    }
                    if (value.length < 5) {
                      return 'Please enter a paswordlonger than 5 notes.';
                    }
                    return null; // means input is correct
                  }),
            ),
          ],
        ));
  }
}
