import 'package:budget_app/calander/EventProvider.dart';
import 'package:budget_app/calander/calanderController.dart';
import 'package:budget_app/calander/event_data_source.dart';
import 'package:budget_app/calander/taskWidget.dart';
import 'package:budget_app/profilepage/ProfileData.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import './drawer/drawer.dart';
import './calandermeetings.dart';
import '../profilepage/profileScreen.dart';

class CalanderPage extends StatelessWidget {
  int? current;
  String? username;
  String? email;
  ProfileData? userdata;
  CalanderPage(
      {super.key, this.current, this.email, this.username, this.userdata});

  CalendarView viewCalendar = CalendarView.month;

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    current = current ?? 0;
    print("here is reubuilt");
    final events = Provider.of<EventProvider>(context).evetns;
    final width = MediaQuery.of(context).size.width;
    return ColorfulSafeArea(
      color: Colors.white.withOpacity(0.7),
      child: Consumer<CalanderController>(
        builder: (context, calanderController, child) =>
            // Scaffold(
            //   bottomNavigationBar: NavigationBar(
            //     selectedIndex: current!,
            //     onDestinationSelected: (value) {
            //       switch (value) {
            //         case 1:
            //           Navigator.of(context).push(MaterialPageRoute(
            //             builder: (context) => ProfileScreen(
            //               username: username ?? '',
            //               email: email ?? '',
            //               current: value,
            //             ),
            //           ));
            //       }
            //     },
            //     destinations: const [
            //       NavigationDestination(
            //         icon: Icon(Icons.schedule),
            //         label: "schedule",
            //       ),
            //       NavigationDestination(
            //           icon: Icon(Icons.person), label: "MyProfile"),
            //       NavigationDestination(icon: Icon(Icons.people), label: "friends"),
            //       NavigationDestination(
            //           icon: Icon(Icons.settings), label: "settings")
            //     ],
            //   ),
            //   // drawer: GestureDetector(
            //   //   onTap: () {
            //   //     FocusScope.of(context).unfocus();
            //   //   },
            //   //   child: calDrawer(
            //   //     width: width,
            //   //   ),
            //   // ),
            //   appBar: AppBar(
            //     key: _key,
            //     actions: [],
            //     centerTitle: true,
            //     title: const Text(
            //       "scheduele",
            //       textAlign: TextAlign.right,
            //     ),
            //     backgroundColor: Colors.white,
            //   ),
            //   body:
            Stack(children: [
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
                appointmentDisplayMode: MonthAppointmentDisplayMode.indicator),
          ),
          Positioned(
            right: 20,
            bottom: 50,
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.lightBlueAccent)),
                onPressed: () {
                  calanderController.gotoApointmetPage(context);
                },
                child: const Icon(
                  Icons.add,
                )),
          )
        ]),
      ),
    );
    // );
  }
}
