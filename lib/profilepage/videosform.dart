import 'package:flutter/material.dart';
import './profileController.dart';

class VideoForm extends StatelessWidget {
  final width;
  final ProfileController controller;
  const VideoForm({super.key, required this.width, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Container(
        width: width * 0.7,
        child: TextFormField(
          controller: controller.youtubeurlController,
          keyboardType: TextInputType.name,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Color.fromARGB(255, 245, 244, 245),
            hintText: 'Add a youtube url',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(20), right: Radius.circular(20))),
          ),
        ),
      ),
    );
  }
}
