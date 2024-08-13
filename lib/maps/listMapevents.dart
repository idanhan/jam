import 'package:flutter/material.dart';
import './locationmodel.dart';

class ListMapEvents extends ChangeNotifier {
  List<MapEvent> mapeventslist = [];

  void addtolist(MapEvent mapEvent) {
    mapeventslist.add(mapEvent);
  }

  void removefromlist(int index) {
    mapeventslist.removeAt(index);
  }

  void removebyevent(MapEvent mapEvent) {
    mapeventslist.removeWhere((element) {
      return ((element.eventtitle == mapEvent.eventtitle) &&
          (element.from == mapEvent.from) &&
          (element.to == mapEvent.to));
    });
  }
}
