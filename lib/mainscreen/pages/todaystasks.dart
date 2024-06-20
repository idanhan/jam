import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class todaysPage extends StatelessWidget {
  todaysPage({super.key});

  List<Map<String, String>> tasklist = [];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
        itemBuilder: (context, index) {});
  }
}
