import 'package:budget_app/qualificationpage/genreDrop.dart';
import 'package:flutter/material.dart';

class genreDrop extends StatelessWidget {
  GenresList list;
  genreDrop({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    final genre = list.list;
    String name = genre.first;
    return DropdownButton<String>(
        dropdownColor: Colors.black,
        items: genre
            .map((value) => DropdownMenuItem(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(color: Colors.white),
                  ),
                ))
            .toList(),
        value: name,
        onChanged: (String? val) {
          print("fdsfds");
          print(val);
          if (val != null) {
            list.addItem(val);
          }
        });
  }
}
