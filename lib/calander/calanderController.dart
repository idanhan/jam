import 'dart:convert';

import 'package:budget_app/calander/event.dart';
import 'package:budget_app/maps/locationmodel.dart';
import 'package:budget_app/profilepage/ProfileData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import './EventProvider.dart';
import './newevent.dart';
import './friendaddsearchform.dart';
import './namedcircleavatar.dart';
import './locationform.dart';
import '../ApiConstants.dart';
import 'package:http/http.dart' as http;

class CalanderController extends ChangeNotifier {
  TextEditingController eventname1 = TextEditingController();
  TextEditingController eventnameEdit = TextEditingController();
  TextEditingController descriptionEdit = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController locationdesc = TextEditingController();
  late DateTime toDate;
  late TimeOfDay toTime;
  late DateTime fromDate;
  late TimeOfDay fromTime;
  final formKey = GlobalKey<FormState>();
  final formKeyEdit = GlobalKey<FormState>();
  final locationformkey = GlobalKey<LoactionFormState>();
  bool public = true;
  TextEditingController friendsearch = TextEditingController();
  final searchformkey = GlobalKey<FriendSearchFormState>();
  int initialindex = 0;
  Map<String, Image> addedFriends = {};
  List<Widget> widgetlistavatar = [];
  bool ischecked;
  bool added = false;
  List<Namedavatar> listnamedavatar = [];
  List<MapEvent>? eventsformap;
  List<MapEvent>? mapeventsload;
  bool first = false;

  CalanderController(
      {DateTime? toDate,
      this.eventsformap,
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

  void changepublic(int index) {
    public = !public;
    initialindex = public ? 0 : 1;
    notifyListeners();
  }

  Future<void> gotoApointmetPage(
      BuildContext context,
      List<ProfileData>? frienddata,
      Map<String, Image>? friendimage,
      String username,
      Image? userimage,
      String useremail) async {
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => NewEvent(
              useremail: useremail,
              events: eventsformap,
              location: locationdesc.text,
              frienddata: frienddata,
              friendimage: friendimage,
              username: username,
              userimage: userimage,
            )));
  }

  void maptolist(Map<String, Image>? friendsimage, String name,
      List<ProfileData>? frienddata) {
    if ((friendsimage != null) &&
        (friendsimage.containsKey(name)) &&
        (!addedFriends.containsKey(name))) {
      addedFriends.addAll(friendsimage);
      listnamedavatar.add(Namedavatar(
          name: name,
          image: friendsimage[name] ?? Image.asset("assets/person.jpg")));
      notifyListeners();
    } else if (frienddata != null &&
        frienddata.isNotEmpty &&
        !addedFriends.containsKey(name)) {
      if (frienddata.where((element) => element.name == name).isNotEmpty) {
        addedFriends.addAll({name: Image.asset("assets/person.jpg")});
        listnamedavatar.add(
            Namedavatar(name: name, image: Image.asset("assets/person.jpg")));
        notifyListeners();
      }
    }
  }

  void removeFriend(int index) {
    addedFriends
        .removeWhere((key, value) => key == listnamedavatar[index].name);
    listnamedavatar.removeAt(index);
    notifyListeners();
  }

  Future<void> addfriendtojam(
      Map<String, Image>? friendsimages, String friendname) async {
    if (friendsimages != null && friendsimages.isNotEmpty) {
      if (friendsimages.containsKey(friendname) &&
          !addedFriends.containsKey(friendname)) {
        addedFriends.addAll({friendname: friendsimages[friendname]!});
      }
    }
  }

  Future<void> getallevents(
      context, List<MapEvent> mapevents, Map<String, Image> friendsmap) async {
    List<Event> eventslist = mapevents
        .map((e) => Event(
            friendimage: friendsmap,
            location: e.location,
            from: DateTime.parse(e.from),
            to: DateTime.parse(e.to),
            title: e.eventtitle,
            description: e.description))
        .toList();
    eventslist.forEach((element) {
      Provider.of<EventProvider>(context).addEvent(element);
    });
  }

  void getallevents2(List<Event> events, List<MapEvent>? mapevents) {
    if (first && events.isNotEmpty) {
      List<MapEvent> secmapevents = events
          .map((e) => MapEvent(
              friendsimage: e.friendimage!.keys.toList(),
              from: e.from.toString(),
              location: e.location,
              to: e.to.toString(),
              description: e.description,
              eventtitle: e.title))
          .toList();

      mapevents!.addAll(secmapevents);
      first = false;
    }
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

  void saveForm(
      BuildContext context, String location, Map<String, Image> friendimage) {
    if (eventsformap != null) {
      eventsformap!.add(MapEvent(
          location: location,
          from: fromDate.toString(),
          to: toDate.toString(),
          eventtitle: eventname1.text,
          description: description.text,
          friendsimage: friendimage.entries.map((e) => e.key).toList()));
    }
    final event = Event(
        location: location,
        friendimage: friendimage,
        from: fromDate,
        to: toDate,
        title: eventname1.text,
        description: description.text);
    eventname1.clear();
    description.clear();
    fromDate = DateTime.now();
    toDate = DateTime.now();
    final provider = Provider.of<EventProvider>(context, listen: false);
    provider.addEvent(event);
    Navigator.of(context).popUntil(ModalRoute.withName('/CalanderPage'));
  }

  Future<void> loadmapeventstoscheduele(BuildContext context,
      List<Event>? eventlist, Map<String, Image>? friendsimage) async {
    final provider = Provider.of<EventProvider>(context, listen: false);
    if (eventlist != null && eventlist.isNotEmpty) {
      eventlist.forEach((element) {
        provider.addEvent(Event(
            location: element.location,
            from: element.from,
            to: element.to,
            title: element.title,
            description: element.description,
            friendimage: element.friendimage ?? {}));
      });
      eventlist.clear();
    }
  }

  void checkboxfun(bool val) {
    ischecked = val;
    notifyListeners();
  }

  Future<void> postjam(MapEvent mapEvent, String useremail) async {
    final url = Uri.parse("${constants.baseurl}/jam");
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "jamTitle": mapEvent.eventtitle,
          "jamDescription": mapEvent.description,
          "jamStartTime": mapEvent.from.toString(),
          "jamEndTime": mapEvent.to.toString(),
          "locationdes": mapEvent.location,
          "public": public,
          "friends": mapEvent.friendsimage,
          "user_created": useremail,
          "created_at": DateTime.now().toString(),
        }));
    if (response.statusCode == 400) {
      print(response.body);
    }
    if (response.statusCode == 500) {
      print(response.body);
    }
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
