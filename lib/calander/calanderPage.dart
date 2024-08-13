import 'package:budget_app/calander/EventProvider.dart';
import 'package:budget_app/calander/calanderController.dart';
import 'package:budget_app/calander/event.dart';
import 'package:budget_app/calander/event_data_source.dart';
import 'package:budget_app/calander/taskWidget.dart';
import 'package:budget_app/profilepage/ProfileData.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import './drawer/drawer.dart';
import './calandermeetings.dart';
import '../profilepage/profileScreen.dart';
import '../maps/locationmodel.dart';

class CalanderPage extends StatelessWidget {
  int? current;
  String username;
  Image? userimage;
  String email;
  List<ProfileData>? friendsdata;
  Map<String, Image>? friendsimage;
  List<MapEvent>? mapEvents;
  List<Event>? eventslist;
  CalanderPage(
      {super.key,
      this.current,
      required this.email,
      required this.username,
      this.friendsdata,
      this.friendsimage,
      this.mapEvents,
      this.eventslist,
      this.userimage});

  CalendarView viewCalendar = CalendarView.week;

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    current = current ?? 0;
    final events = Provider.of<EventProvider>(context).evetns;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final controller = Provider.of<CalanderController>(context, listen: false);

    return FutureBuilder(
      future: controller.loadmapeventstoscheduele(
          context, eventslist, friendsimage),
      builder: (context, snapshot) => ColorfulSafeArea(
        color: Colors.white.withOpacity(0.7),
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          body: Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            height: height,
            width: width,
            child: Consumer<CalanderController>(
              builder: (context, calanderController, child) {
                return Stack(children: [
                  SfCalendar(
                    onLongPress: (calendarLongPressDetails) {
                      final provider =
                          Provider.of<EventProvider>(context, listen: false);
                      provider.setDate(calendarLongPressDetails.date!);
                      showModalBottomSheet(
                          context: context, builder: (context) => TaskWidget());
                    },
                    view: viewCalendar,
                    dataSource: EventDataSource(events),
                    cellBorderColor: const Color.fromARGB(221, 82, 81, 81),
                    monthViewSettings: const MonthViewSettings(
                        appointmentDisplayMode:
                            MonthAppointmentDisplayMode.indicator),
                  ),
                  Positioned(
                    right: 20,
                    bottom: 50,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Colors.lightBlueAccent)),
                        onPressed: () {
                          calanderController.gotoApointmetPage(
                              context,
                              friendsdata,
                              friendsimage,
                              username,
                              userimage,
                              email);
                        },
                        child: const Icon(
                          Icons.add,
                        )),
                  )
                ]);
              },
            ),
          ),
        ),
      ),
    );
  }
}
