import 'package:budget_app/signin/SigninController.dart';
import 'package:budget_app/signup/signupController.dart';
import 'package:flutter/material.dart';

class SignInForm extends StatelessWidget {
  final SignInController controller;
  final width;
  SignInForm({required this.controller, required this.width});

  @override
  Widget build(BuildContext context) {
    return Form(
        key: controller.formkey,
        child: Column(
          children: [
            Container(
              width: width * 0.9,
              child: TextFormField(
                textAlign: TextAlign.center,
                controller: controller.UsernameController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(255, 248, 216, 248),
                  hintText: 'UserName',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: width * 0.9,
              child: TextFormField(
                textAlign: TextAlign.center,
                controller: controller.emailnameController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(255, 248, 216, 248),
                  hintText: 'email',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                ),
              ),
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
                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
