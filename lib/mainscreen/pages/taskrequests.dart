import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class tasks extends StatelessWidget {
  const tasks({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
        itemBuilder: (context, index) {});
  }
}
