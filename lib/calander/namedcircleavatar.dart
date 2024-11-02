import 'package:flutter/material.dart';

class Namedavatar extends StatelessWidget {
  final String name;
  final Image image;
  const Namedavatar({super.key, required this.name, required this.image});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 5),
          child: CircleAvatar(
            radius: 40,
            backgroundImage: image.image,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 25),
          child: Text(
            name,
            style: const TextStyle(color: Colors.white),
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }
}
