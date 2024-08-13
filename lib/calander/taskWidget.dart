import 'package:budget_app/calander/EventProvider.dart';
import 'package:budget_app/calander/calanderController.dart';
import 'package:budget_app/calander/event.dart';
import 'package:budget_app/calander/eventViewPage.dart';
import 'package:budget_app/calander/event_data_source.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import '../maps/locationmodel.dart';

class TaskWidget extends StatelessWidget {
  List<MapEvent>? mapEvents;
  TaskWidget({super.key, this.mapEvents});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventProvider>(context);
    final selectedEvents = provider.eventsOfSelectedDate;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    if (selectedEvents.isEmpty) {
      return const Center(
        child: Text(
          "No events were found",
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
      );
    }
    return SfCalendarTheme(
      data: const SfCalendarThemeData(
          timeTextStyle: TextStyle(color: Colors.black, fontSize: 16)),
      child: Consumer<CalanderController>(
        builder: (context, controller, child) => SfCalendar(
          view: CalendarView.timelineDay,
          dataSource: EventDataSource(provider.evetns),
          initialDisplayDate: provider.selectedDate,
          appointmentBuilder: controller.appointmentBuilder,
          headerHeight: 0,
          todayHighlightColor: Colors.black,
          selectionDecoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          onTap: (details) {
            if (details.appointments == null) return;
            final event = details.appointments!.first as Event;
            print("task widget");
            print(event.friendimage);
            Navigator.of(context).push(MaterialPageRoute(
              builder: ((context) => EventViewPage(
                    width: width,
                    height: height,
                    event: event,
                  )),
            ));
          },
        ),
      ),
    );
  }
}
