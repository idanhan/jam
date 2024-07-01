import 'package:flutter/material.dart';
import './profileController.dart';

class Desform extends StatelessWidget {
  final width;
  final ProfileController controller;
  final height;
  const Desform(
      {super.key,
      required this.width,
      required this.controller,
      required this.height});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Container(
        width: width * 0.7,
        child: TextFormField(
          controller: controller.Desccontroller,
          keyboardType: TextInputType.name,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Color.fromARGB(255, 245, 244, 245),
            hintText: 'Add a description to the video',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(20), right: Radius.circular(20))),
          ),
        ),
      ),
    );
  }
}
