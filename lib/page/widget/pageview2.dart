import 'package:budget_app/page/pageviewcontroller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

class Page2 extends StatelessWidget {
  const Page2({super.key});

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
                future: controller.composition2,
                builder: (context, snapshot) {
                  var composition = snapshot.data;
                  if (composition != null) {
                    return Expanded(child: Lottie(composition: composition));
                  } else {
                    return const CircularProgressIndicator();
                  }
                }),
            const Text(
              'Scheduele a jam session and attach pdf tabs or sheet music',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              height: height * 0.01,
            )
          ]),
        ),
      );
    });
  }
}
