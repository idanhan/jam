import 'package:budget_app/calander/event.dart';
import 'package:budget_app/maps/locationmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Markerdate {
  DateTime from;
  DateTime to;
  Marker marker;
  MapEvent event;
  Markerdate(
      {required this.from,
      required this.marker,
      required this.to,
      required this.event});
}
