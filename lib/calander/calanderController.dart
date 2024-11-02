import 'dart:convert';
import 'dart:ui';

import 'package:budget_app/calander/event.dart';
import 'package:budget_app/calander/eventediting.dart';
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
import 'package:flutter/services.dart';

class CalanderController extends ChangeNotifier {
  TextEditingController eventname1 = TextEditingController();
  TextEditingController eventnameEdit = TextEditingController();
  TextEditingController descriptionEdit = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController locationdesc = TextEditingController();
  TextAlign align = TextAlign.left;
  TextDirection direction = TextDirection.ltr;
  late DateTime toDate;
  late TimeOfDay toTime;
  late DateTime fromDate;
  late TimeOfDay fromTime;
  final calanderformKey = GlobalKey<FormState>();
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
      String useremail,
      List<MapEvent>? mapevents) async {
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => NewEvent(
              useremail: useremail,
              events: mapevents,
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
      addedFriends.addAll(
          {name: friendsimage[name] ?? Image.asset("assets/person.jpg")});
      listnamedavatar.add(Namedavatar(
          name: name,
          image: friendsimage[name] ?? Image.asset("assets/person.jpg")));
      notifyListeners();
    }
    // } else if (frienddata != null &&
    //     frienddata.isNotEmpty &&
    //     !addedFriends.containsKey(name)) {
    //   if (frienddata.where((element) => element.name == name).isNotEmpty) {
    //     addedFriends.addAll({name: Image.asset("assets/person.jpg")});
    //     listnamedavatar.add(
    //         Namedavatar(name: name, image: Image.asset("assets/person.jpg")));
    //     notifyListeners();
    //   }
    // }
  }

  void removeFriend(int index) {
    addedFriends
        .removeWhere((key, value) => key == listnamedavatar[index].name);
    listnamedavatar.removeAt(index);
    notifyListeners();
  }

  void tortl(String text) {
    if (_isrtl(text)) {
      direction = TextDirection.rtl;
      notifyListeners();
    } else {
      direction = TextDirection.ltr;
      notifyListeners();
    }
  }

  bool _isrtl(String text) {
    if (text.isEmpty) return false;

    final rtlChars = RegExp(r'[\u0600-\u06FF\u0750-\u077F\u0590-\u05FF]');
    return rtlChars.hasMatch(text.characters.first);
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

  Future<void> getallevents(context, List<MapEvent> mapevents,
      Map<String, Image> friendsmap, String usercreated) async {
    List<Event> eventslist = mapevents
        .map((e) => Event(
            user_created: usercreated,
            created_at: e.created_at,
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

  void aligntext() {
    if (direction == TextDirection.rtl) {
      align = TextAlign.right;
      notifyListeners();
    } else {
      align = TextAlign.left;
      notifyListeners();
    }
  }

  void getallevents2(List<Event> events, List<MapEvent>? mapevents) {
    if (first && events.isNotEmpty) {
      List<MapEvent> secmapevents = events
          .map((e) => MapEvent(
              created_at: e.created_at.toString(),
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
        if (fromDate.isAfter(toDate)) {
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

  void saveForm(BuildContext context, String location,
      Map<String, Image> friendimage, String created_at, String usercreated) {
    if (eventsformap != null) {
      eventsformap!.add(MapEvent(
          created_at: created_at,
          location: location,
          from: fromDate.toString(),
          to: toDate.toString(),
          eventtitle: eventname1.text,
          description: description.text,
          friendsimage: friendimage.entries.map((e) => e.key).toList()));
    }
    final event = Event(
        user_created: usercreated,
        location: location,
        friendimage: friendimage,
        from: fromDate,
        to: toDate,
        title: eventname1.text,
        description: description.text,
        created_at: DateTime.now().toIso8601String());
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
            user_created: element.user_created,
            created_at: element.created_at,
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

  // Future<void> putjam(
  //     MapEvent mapEvent, String useremail, String created_at) async {
  //   final url = Uri.parse("${constants.baseurl}/changejams");
  //   final response = http.put(url,
  //       headers: {'Content-Type': 'application/json'},
  //       body: json.encode({
  //         "jamTitle": mapEvent.eventtitle,
  //         "jamDescription": mapEvent.description,
  //         "jamStartTime": mapEvent.from.toString(),
  //         "jamEndTime": mapEvent.to.toString(),
  //         "locationdes": mapEvent.location,
  //         "public": public,
  //         "friends": mapEvent.friendsimage,
  //         "user_created": useremail,
  //         "created_at": created_at,
  //       }));
  //   notifyListeners();
  // }

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

  //added from here
  List<Widget> deleteActions(
      BuildContext context, String useremail, Event event) {
    return [
      TextButton(
          onPressed: () {
            context.read<CalanderController>().delete(event, context);
            deletejam(useremail, event.created_at);
          },
          child: Text("Delete Event")),
      TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Cancel"))
    ];
  }

  Future<void> deletejam(String useremail, String created_at) async {
    final url = Uri.parse("${constants.baseurl}/deletejam");
    final response = await http.delete(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "user_created": useremail,
          "created_at": created_at,
        }));
  }

  List<Widget> buildViewingActions(
      BuildContext context, Event event, String username, String useremail) {
    return [
      IconButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EventEditingpage(
                      username: username,
                      event: event,
                      emailname: useremail,
                    )));
          },
          icon: const Icon(
            Icons.edit,
            color: Colors.white,
          )),
      IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Row(children: [
                  Icon(Icons.delete),
                  SizedBox(
                    width: 0.05,
                  ),
                  Text("Delete Event?")
                ]),
                actions: deleteActions(context, useremail, event),
              ),
            );
          },
          icon: const Icon(
            Icons.delete,
            color: Colors.white,
          ))
    ];
  }

  Future<void> removefriendfromjam(String username, String usercreated,
      String createdat, Event event) async {
    final url = Uri.parse(
        "${constants.baseurl}/deleteuserfromjam/$username,$usercreated,$createdat");
    final response = await http.delete(
      url,
    );
    if (response.statusCode == 200) {
      if (event.friendimage != null) {
        event.friendimage!.removeWhere((key, value) => key == username);
        print("user removed");
        notifyListeners();
      } else {
        print(response.body);
      }
    }
  }

  void maptolistwidget(
      double height,
      BuildContext context,
      bool happend,
      Event event,
      String username,
      List<Widget> listnamedavatar2,
      String useremail) {
    if (!happend) {
      print("im in");
      happend = !happend;
      listnamedavatar2.addAll(event.friendimage!.entries
          .map((e) => (username != e.key || event.user_created == useremail)
              ? Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 4),
                      child: CircleAvatar(
                        radius: height * 0.05,
                        backgroundImage: e.value.image,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: Text(
                        e.key,
                        style: const TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                )
              : Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 4),
                      child: Stack(children: [
                        CircleAvatar(
                          radius: height * 0.05,
                          backgroundImage: e.value.image,
                        ),
                        Positioned(
                            left: 2,
                            child: IconButton(
                              icon: const Icon(
                                Icons.remove_circle,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: const Text(
                                              "remove yourself from this jam?"),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  removefriendfromjam(
                                                      username,
                                                      event.user_created,
                                                      event.created_at,
                                                      event);
                                                  notifyListeners();
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text("Yes")),
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text("No"))
                                          ],
                                        ));
                              },
                            ))
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: Text(
                        e.key,
                        style: const TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ))
          .toList());

      if (listnamedavatar2.isNotEmpty) {
        print(listnamedavatar2.length);
        notifyListeners();
      }
    }
  }
}
