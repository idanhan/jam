import 'package:budget_app/page/pageviewcontroller.dart';
import 'package:budget_app/page/widget/pageview1.dart';
import 'package:budget_app/page/widget/pageview2.dart';
import 'package:budget_app/page/widget/pageview3.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Pageview extends StatelessWidget {
  const Pageview({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final controller = PageController();
    return Scaffold(
      backgroundColor: Colors.black,
      body: Consumer<Pageviewcontroller>(
        builder: (context, pagecontroller, widget) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: height * 0.2,
              ),
              Center(
                child: Container(
                  height: height * 0.5,
                  width: width * 0.5,
                  child: Column(children: [
                    Expanded(
                      child: PageView.builder(
                        controller: controller,
                        onPageChanged: (int index) {
                          pagecontroller.setpage(index);
                        },
                        itemBuilder: (context, index) {
                          switch (index) {
                            case 0:
                              return const Page1();
                            case 1:
                              return const Page2();
                            case 2:
                              return const Page3();
                          }
                        },
                        itemCount: 3,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    DotsIndicator(
                      dotsCount: 3,
                      position: pagecontroller.currentPage,
                    ),
                  ]),
                ),
              ),
              SizedBox(
                height: height * 0.1,
              ),
              ElevatedButton(
                onPressed: () {
                  pagecontroller.goToSignup(context);
                },
                style: ButtonStyle(
                    backgroundColor:
                        const MaterialStatePropertyAll<Color>(Colors.blue),
                    minimumSize: MaterialStateProperty.all(
                        Size(width * 0.8, height * 0.05))),
                child: const Text(
                  'SignUp',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
