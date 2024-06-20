import 'package:budget_app/friends/friendController.dart';
import 'package:flutter/material.dart';

class FriendsForm extends StatelessWidget {
  final FriendController controller;
  final width;
  FriendsForm({super.key, required this.controller, required this.width});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Container(
        width: width * 0.7,
        child: TextFormField(
          controller: controller.friendsSearch,
          keyboardType: TextInputType.name,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Color.fromARGB(255, 248, 216, 248),
            hintText: 'Search friends',
            border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.horizontal(left: Radius.circular(20))),
          ),
        ),
      ),
    );
  }
}
