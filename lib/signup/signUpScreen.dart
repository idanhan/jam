import 'package:budget_app/signup/signupController.dart';
import 'package:budget_app/signup/signupForm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Consumer<SignupController>(
          builder: (context, controller, widget) {
            return SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: width * 0.1),
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.1,
                    ),
                    const Text(
                      'Sign Up',
                      style: TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'Create your account',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.1,
                    ),
                    SignupForm(
                      controller: controller,
                      width: width,
                    ),
                    SizedBox(
                      height: height * 0.07,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        controller.gotoQualificationpage(context);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          minimumSize: Size(width * 0.8, height * 0.08),
                          shape: const StadiumBorder()),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.08,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? click',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextButton(
                            style: TextButton.styleFrom(
                                tapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap),
                            onPressed: () {
                              controller.gotoSignInScreen(context);
                            },
                            child: Text(
                              'here',
                              style: TextStyle(color: Colors.purple),
                            ))
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
