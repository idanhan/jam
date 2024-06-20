import 'package:budget_app/mainscreen/pages/taskrequests.dart';
import 'package:budget_app/mainscreen/pages/todaystasks.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';
import './mainscreencontroller.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final pageconroller = PageController(viewportFraction: 0.8);
    return Scaffold(
      body: Container(
          child: PageView.builder(
        itemBuilder: (context, index) {
          switch (index) {
            case 0:
              return todaysPage();
            case 1:
              return tasks();
          }
        },
        itemCount: 2,
        controller: pageconroller,
      )),
    );
  }
}
