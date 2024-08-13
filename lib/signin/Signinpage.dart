import 'package:budget_app/signin/SigninController.dart';
import 'package:budget_app/signin/SigninForm.dart';
import 'package:budget_app/signup/signupController.dart';
import 'package:budget_app/signup/signupForm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Color.fromARGB(255, 0, 0, 0), Colors.grey],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: Consumer<SignInController>(
          builder: (context, controller, widget) {
            return GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: width * 0.1),
                  child: Column(
                    children: [
                      SizedBox(
                        height: height * 0.1,
                      ),
                      const Text(
                        'Welcome Back',
                        style: TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'Enter username email and password to enter',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: height * 0.1,
                      ),
                      SignInForm(
                        controller: controller,
                        width: width,
                      ),
                      SizedBox(
                        height: height * 0.07,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await controller.signin(
                              context,
                              controller.emailnameController.text,
                              controller.passwordController.text,
                              controller.UsernameController.text);
                          // await controller.getImage();
                          // await controller.getListFriends(
                          //     controller.UsernameController.text); //added this
                          // await controller.getcomingevents(
                          //     controller.UsernameController.text);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 84, 120, 187),
                            minimumSize: Size(width * 0.8, height * 0.08),
                            shape: const StadiumBorder()),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.08,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Dont have an account?',
                            style: TextStyle(color: Colors.white),
                          ),
                          TextButton(
                              style: TextButton.styleFrom(
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap),
                              onPressed: () async {
                                controller.gotoSignUpScreen(context);
                              },
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(color: Colors.purple),
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
