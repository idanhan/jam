import 'package:budget_app/calander/calanderPage.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';
import './event.dart';

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Event> app) {
    this.appointments = app;
  }

  Event getEvent(int index) => appointments![index] as Event;

  @override
  DateTime getStartTime(int index) => getEvent(index).from;

  @override
  DateTime getEndTime(int index) => getEvent(index).to;

  @override
  String getSubject(int index) => getEvent(index).description;

  String getTitle(int index) => getEvent(index).title;

  @override
  bool isAllDay(int index) => getEvent(index).isallday ?? false;

  @override
  Color getColor(int index) => getEvent(index).backcolor ?? Colors.orange;

  String getlocation(int index) => getEvent(index).location;

  Map<String, Image> getfriendsImage(int index) =>
      getEvent(index).friendimage ?? {};
}
