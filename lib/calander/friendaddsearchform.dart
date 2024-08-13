import 'package:flutter/material.dart';

class FriendSearchForm extends StatefulWidget {
  TextEditingController friendcontroller;
  double width;
  FriendSearchForm(
      {super.key, required this.friendcontroller, required this.width});

  @override
  State<FriendSearchForm> createState() => FriendSearchFormState();
}

class FriendSearchFormState extends State<FriendSearchForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
        child: Container(
      width: widget.width * 0.6,
      child: TextFormField(
        controller: widget.friendcontroller,
        keyboardType: TextInputType.name,
        decoration: const InputDecoration(
          filled: true,
          fillColor: Color.fromARGB(255, 245, 244, 245),
          hintText: 'Search friends',
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
        ),
        onChanged: (friend) {},
      ),
    ));
  }
}
