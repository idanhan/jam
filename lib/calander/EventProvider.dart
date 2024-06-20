import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import './event.dart';

class EventProvider extends ChangeNotifier {
  final List<Event> _events = [];

  List<Event> get evetns => _events;

  void setEvent(Event event) {}

  DateTime _selectedTime = DateTime.now();

  DateTime get selectedDate => _selectedTime;
  void setDate(DateTime date) => _selectedTime = date;
  List<Event> get eventsOfSelectedDate => _events
      .where((element) =>
          element.from.day == _selectedTime.day &&
          element.from.month == _selectedTime.month &&
          element.from.year == _selectedTime.year)
      .toList();
  void addEvent(Event event) {
    _events.add(event);
    print(_events.first);
    notifyListeners();
  }

  void editEvent(Event oldEvent, Event newEvent, BuildContext context) {
    final index = _events.indexOf(oldEvent);
    _events[index] = newEvent;
    print("lets");
    print(newEvent.title);
    notifyListeners();
    Navigator.of(context).popUntil(ModalRoute.withName('/CalanderPage'));
  }
}
