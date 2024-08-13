import 'package:flutter/material.dart';

class Namedavatar extends StatelessWidget {
  String name;
  Image image;
  Namedavatar({super.key, required this.name, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 5),
      child: CircleAvatar(
        radius: 40,
        backgroundImage: image.image,
        child: Text(name),
      ),
    );
  }
}
