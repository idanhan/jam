import 'package:budget_app/calander/event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import './EventProvider.dart';
import './newevent.dart';

class CalanderController extends ChangeNotifier {
  TextEditingController eventname1 = TextEditingController();
  TextEditingController eventnameEdit = TextEditingController();
  TextEditingController descriptionEdit = TextEditingController();
  TextEditingController description = TextEditingController();
  late DateTime toDate;
  late TimeOfDay toTime;
  late DateTime fromDate;
  late TimeOfDay fromTime;
  final formKey = GlobalKey<FormState>();
  final formKeyEdit = GlobalKey<FormState>();
  bool ischecked;
  CalanderController(
      {DateTime? toDate,
      DateTime? fromDate,
      TimeOfDay? toTime,
      TimeOfDay? fromTime,
      bool? ischecked,
      String? title,
      String? descriptionin})
      : toDate = toDate ?? DateTime.now(),
        fromDate = fromDate ?? DateTime.now(),
        toTime = toTime ?? TimeOfDay.now(),
        fromTime = fromTime ?? TimeOfDay.now(),
        ischecked = ischecked ?? false,
        eventname1 = TextEditingController(text: title ?? ""),
        description = TextEditingController(text: descriptionin ?? "");

  Future<void> gotoApointmetPage(BuildContext context) async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => NewEvent()));
  }

  Future<DateTime?> pickDayTime(
      DateTime initialDate, DateTime fromEdit, DateTime toEdit,
      {required bool frompickDate,
      required bool toPickDate,
      required bool fromPickTime,
      required bool toPickTime,
      required bool isfromEdit,
      required bool istoEdit,
      DateTime? firstDate,
      required BuildContext context}) async {
    DateTime? date;
    TimeOfDay? time;
    if ((frompickDate || toPickDate) && !isfromEdit && !istoEdit) {
      date = await showDatePicker(
          barrierColor: Colors.black,
          context: context,
          firstDate: initialDate,
          lastDate: DateTime(2201));
      if (frompickDate) {
        if (date == null) {
          return null;
        }
        fromDate = DateTime(
            date.year, date.month, date.day, fromDate.hour, fromDate.minute);
        print(fromDate);
        print(toDate);
        if (fromDate.isAfter(toDate)) {
          print("here please");
          toDate = fromDate;
        }
        notifyListeners();
        return fromDate;
      } else if (toPickDate) {
        if (date == null) {
          return null;
        }
        if (fromDate.isAfter(toDate)) {
          toDate = fromDate;
        }
        toDate = DateTime(
            date.year, date.month, date.day, toDate.hour, toDate.minute);
        notifyListeners();
        return toDate;
      }
    } else if ((fromPickTime || toPickTime) && !isfromEdit && !istoEdit) {
      final time =
          await showTimePicker(context: context, initialTime: TimeOfDay.now());
      if (time == null) {
        return null;
      }
      final time2 = Duration(hours: time.hour, minutes: time.minute);
      if (fromPickTime) {
        fromDate = DateTime(fromDate.year, fromDate.month, fromDate.day,
            time.hour, time.minute);

        if (fromDate.isAfter(toDate)) {
          print("here please");
          toDate = fromDate;
        }
        notifyListeners();
        return fromDate;
      } else if (toPickTime) {
        toDate = DateTime(
            toDate.year, toDate.month, toDate.day, time.hour, time.minute);
        notifyListeners();
        return toDate;
      }
    } else if ((frompickDate || toPickDate) && (isfromEdit || istoEdit)) {
      date = await showDatePicker(
          barrierColor: Colors.black,
          context: context,
          firstDate: initialDate,
          lastDate: DateTime(2201));
      if (frompickDate) {
        if (date == null) {
          return null;
        }
        fromEdit = DateTime(
            date.year, date.month, date.day, fromEdit.hour, fromEdit.minute);
        if (fromDate.isAfter(toDate)) {
          toEdit = fromEdit;
        }
        notifyListeners();
        return fromEdit;
      } else if (toPickDate) {
        if (date == null) {
          return null;
        }
        if (fromEdit.isAfter(toEdit)) {
          toEdit = fromEdit;
        }
        toEdit = DateTime(
            date.year, date.month, date.day, toEdit.hour, toEdit.minute);
        notifyListeners();
        return toEdit;
      }
    } else if ((fromPickTime || toPickTime) && (isfromEdit || istoEdit)) {
      final time =
          await showTimePicker(context: context, initialTime: TimeOfDay.now());
      if (time == null) {
        return null;
      }
      final time2 = Duration(hours: time.hour, minutes: time.minute);
      if (fromPickTime) {
        fromEdit = DateTime(fromEdit.year, fromEdit.month, fromEdit.day,
            time.hour, time.minute);

        if (fromEdit.isAfter(toEdit)) {
          print("here please");
          toEdit = fromEdit;
        }
        notifyListeners();
        return fromEdit;
      } else if (toPickTime) {
        toEdit = DateTime(
            toEdit.year, toEdit.month, toEdit.day, time.hour, time.minute);
        notifyListeners();
        return toEdit;
      }
    }
  }

  Future<void> pickfromdaytime(
      {required DateTime initialtime,
      required DateTime fromEdit,
      required DateTime toEdit,
      required bool toDatePick,
      required bool fromDatePick,
      required bool totimePick,
      required bool fromTimePick,
      required bool isfromEdit,
      required bool istoEdit,
      required context}) async {
    final date = await pickDayTime(initialtime, fromEdit, toEdit,
        isfromEdit: isfromEdit,
        istoEdit: istoEdit,
        frompickDate: fromDatePick,
        toPickDate: toDatePick,
        fromPickTime: fromTimePick,
        toPickTime: totimePick,
        context: context);
    if (istoEdit) {
      toEdit = date ?? toEdit;
    }
  }

  void delete(Event event, BuildContext context) {
    context
        .read<EventProvider>()
        .evetns
        .removeWhere((element) => element == event);
    notifyListeners();
    Navigator.popUntil(context, ModalRoute.withName('/CalanderPage'));
  }

  void saveForm(BuildContext context) {
    final event = Event(
        from: fromDate,
        to: toDate,
        title: eventname1.text,
        description: description.text);
    eventname1.clear();
    description.clear();
    fromDate = DateTime.now();
    toDate = DateTime.now();
    final provider = Provider.of<EventProvider>(context, listen: false);
    print(provider.evetns.length);
    provider.addEvent(event);
    Navigator.of(context).popUntil(ModalRoute.withName('/CalanderPage'));
  }

  void checkboxfun(bool val) {
    ischecked = val;
    notifyListeners();
  }

  Widget appointmentBuilder(
      BuildContext context, CalendarAppointmentDetails details) {
    final event1 = details.appointments.first as Event;

    return Container(
      width: details.bounds.width,
      height: details.bounds.height,
      decoration: BoxDecoration(
        color: event1.backcolor!.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          event1.title,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  Future<void> saveEditing(
      Event oldevent, Event newevent, BuildContext context) async {
    final provider = Provider.of<EventProvider>(context);
    provider.editEvent(oldevent, newevent, context);
  }

  Widget buildDropDownField(
      {required String text, required VoidCallback function}) {
    return Expanded(
      child: ListTile(
        title: Row(children: [
          Text(
            text,
            style: const TextStyle(color: Colors.white),
          ),
        ]),
        trailing: const Icon(Icons.arrow_drop_down),
        onTap: function,
      ),
    );
  }

  Widget buildFrom({
    required String textDate,
    required String textTime,
    required VoidCallback Datefunction,
    required VoidCallback Timefunction,
    required double width,
    required String fromTo,
  }) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        fromTo,
        style: TextStyle(color: Colors.white),
        textAlign: TextAlign.start,
      ),
      Row(
        children: [
          buildDropDownField(text: textDate, function: Datefunction),
          Container(
              width: width * 0.3,
              child: Row(
                children: [
                  buildDropDownField(text: textTime, function: Timefunction)
                ],
              )),
        ],
      ),
    ]);
  }
}
