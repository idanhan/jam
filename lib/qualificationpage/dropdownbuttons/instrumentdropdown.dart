import 'package:budget_app/qualificationpage/dropdownbuttons/levelChange.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

List<String> list = ['Beginner', 'Intermediate', 'Professional'];

class instrumentButton extends StatelessWidget {
  String dropdownVal = list.first;
  instrumentButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChangeLevel>(
      builder: (context, controller, child) => DropdownButton<String>(
          dropdownColor: Colors.black,
          style: TextStyle(color: Colors.white),
          items: controller.list.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
          value: controller.current,
          onChanged: (String? value) {
            if (value != null) {
              controller.changeLevel(value);
            }
          }),
    );
  }
}
