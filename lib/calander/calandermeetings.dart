import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import './extendedappointments.dart';

_AppointmentDataSource _getCalendarDataSource(
    DateTime start,
    DateTime end,
    String subject,
    Color color,
    String startzone,
    String endzone,
    String description,
    Map<String, Image> friendsimage,
    String location) {
  List<Appointment> appointments = <CustomAppointment>[];
  appointments.add(CustomAppointment(
      startTime: start,
      endTime: end,
      subject: subject,
      color: color,
      startTimeZone: startzone,
      endTimeZone: endzone,
      friendImage: friendsimage));

  return _AppointmentDataSource(appointments);
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
