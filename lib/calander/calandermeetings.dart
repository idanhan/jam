import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

_AppointmentDataSource _getCalendarDataSource(DateTime start, DateTime end,
    String subject, Color color, String startzone, String endzone) {
  List<Appointment> appointments = <Appointment>[];
  appointments.add(Appointment(
    startTime: start,
    endTime: end,
    subject: subject,
    color: color,
    startTimeZone: startzone,
    endTimeZone: endzone,
  ));

  return _AppointmentDataSource(appointments);
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
