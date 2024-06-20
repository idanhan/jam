import 'package:budget_app/page/pageviewcontroller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Consumer<Pageviewcontroller>(builder: (context, controller, widget) {
      return Center(
        child: Container(
          height: height * 0.5,
          width: width * 0.5,
          color: Colors.black,
          child: Column(children: [
            FutureBuilder(
                future: controller.composition1,
                builder: (context, snapshot) {
                  var composition = snapshot.data;
                  if (composition != null) {
                    return Expanded(child: Lottie(composition: composition));
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
            const Text(
              'Welcome! contact your friends and invite them to a jam',
              style: TextStyle(color: Colors.white),
            ),
          ]),
        ),
      );
    });
  }
}
