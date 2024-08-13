import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';

class CustomAppointment extends Appointment {
  CustomAppointment({
    required DateTime startTime,
    required DateTime endTime,
    required String subject,
    required Color color,
    required String startTimeZone,
    required String endTimeZone,
    this.friendImage,
    this.location,
    this.description,
  }) : super(
            startTime: startTime,
            endTime: endTime,
            subject: subject,
            color: color,
            startTimeZone: startTimeZone,
            endTimeZone: endTimeZone);
  String? location;
  String? description;
  Map<String, Image>? friendImage;
}
