import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import './insDropItem.dart';
import './musicalInstruList.dart';

class musicInstrumentsDrop extends StatelessWidget {
  MusicalInstrument music;
  musicInstrumentsDrop({super.key, required this.music});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    instrumentDropItem instrument = music.list2.first;
    return Consumer<MusicalInstrument>(
      builder: (context, controller, child) => DropdownButton<String>(
          dropdownColor: Colors.black,
          items: music.list2.map((instrument) {
            return DropdownMenuItem<String>(
              value: instrument.name,
              child: instrument,
            );
          }).toList(),
          value: instrument.name,
          onChanged: (String? item) {
            controller.addItem(
                music.list2.where((element) => element.name == item).first);
            instrument = controller.pickInst(item!);
          }),
    );
  }
}
