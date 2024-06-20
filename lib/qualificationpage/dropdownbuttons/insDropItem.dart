import 'package:flutter/material.dart';

class instrumentDropItem extends StatelessWidget {
  String name;
  Widget widget1;
  instrumentDropItem({super.key, required this.widget1, required this.name});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          name,
          style: TextStyle(color: Colors.white),
        ),
        Text("  "),
        Container(
          margin: EdgeInsets.only(
            left: 0.05,
          ),
          height: 20,
          width: 20,
          child: widget1,
        ),
      ],
    );
  }
}
