import 'package:flutter/material.dart';

class LoactionForm extends StatefulWidget {
  TextEditingController slocation;
  final height;
  final width;
  GlobalKey locationkey;
  LoactionForm(
      {super.key,
      required this.slocation,
      required this.height,
      required this.width,
      required this.locationkey});

  @override
  State<LoactionForm> createState() => LoactionFormState();
}

class LoactionFormState extends State<LoactionForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      key: widget.locationkey,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(10)),
      height: widget.height * 0.07,
      child: TextFormField(
        style: const TextStyle(
          color: Colors.white,
        ),
        controller: widget.slocation,
        decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: "Adress in format: Street, City, State, Country",
            hintStyle: TextStyle(color: Colors.white)),
      ),
    );
  }
}
