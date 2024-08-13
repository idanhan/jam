import 'package:budget_app/calander/event.dart';
import 'package:budget_app/calander/newevent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import './calanderController.dart';
import './EventProvider.dart';
import '../utils/utils.dart';

class EventEditingpage extends StatefulWidget {
  final Event event;

  EventEditingpage({
    super.key,
    required this.event,
  });

  @override
  State<EventEditingpage> createState() => _EventEditingpageState();
}

class _EventEditingpageState extends State<EventEditingpage> {
  String? title;
  late TextEditingController titleController;
  late TextEditingController descController;
  final _formKey = GlobalKey<FormState>();
  DateTime? from;
  DateTime? to;

  String? description;

  @override
  void initState() {
    titleController = TextEditingController(text: widget.event.title);
    descController = TextEditingController(text: widget.event.description);
    from = widget.event.from;
    to = widget.event.to;
    super.initState();
  }

  // @override
  // void dispose() {
  //   titleController.dispose();
  //   descController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 201, 114, 216),
          actions: buildViewActions(
            context,
            widget.event,
            newTitle: title,
            newDesription: description,
            newfrom: from,
            newto: to,
          )),
      body: Consumer<CalanderController>(
        builder: (context, controller, child) => SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 20,
              ),
              Form(
                child: TextFormField(
                  key: _formKey,
                  validator: (value) => value != null && value.isEmpty
                      ? "title cannot be empty"
                      : null,
                  onChanged: (text) {
                    print("editingcomplete");
                    setState(() {
                      title = text;
                    });
                  },
                  controller: titleController,
                  style: const TextStyle(fontSize: 24, color: Colors.white),
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: "Add title",
                    hintStyle:
                        TextStyle(color: Color.fromARGB(255, 168, 163, 163)),
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              controller.buildFrom(
                  textDate: Utils.toDateDay(from ?? DateTime.now()),
                  textTime: Utils.toDateTime(from ?? DateTime.now()),
                  Datefunction: () async {
                    await controller.pickfromdaytime(
                        initialtime: controller.fromDate,
                        fromEdit: from ?? DateTime.now(),
                        toEdit: to ?? DateTime.now(),
                        isfromEdit: false,
                        istoEdit: false,
                        fromDatePick: true,
                        fromTimePick: false,
                        toDatePick: false,
                        totimePick: false,
                        context: context);
                    setState(() {
                      from = controller.fromDate;
                    });
                  },
                  Timefunction: () async {
                    await controller.pickfromdaytime(
                        initialtime: controller.fromDate,
                        fromEdit: from ?? DateTime.now(),
                        toEdit: to ?? DateTime.now(),
                        isfromEdit: false,
                        istoEdit: false,
                        toDatePick: false,
                        fromDatePick: false,
                        totimePick: false,
                        fromTimePick: true,
                        context: context);
                    setState(() {
                      from = controller.fromDate;
                    });
                  },
                  width: width,
                  fromTo: "From"),
              SizedBox(
                height: height * 0.01,
              ),
              controller.buildFrom(
                  textDate: Utils.toDateDay(to ?? DateTime.now()),
                  textTime: Utils.toDateTime(to ?? DateTime.now()),
                  Datefunction: () async {
                    await controller.pickfromdaytime(
                        initialtime: controller.toDate,
                        fromEdit: DateTime.now(),
                        toEdit: to ?? DateTime.now(),
                        isfromEdit: false,
                        istoEdit: false,
                        toDatePick: true,
                        fromDatePick: false,
                        totimePick: false,
                        fromTimePick: false,
                        context: context);
                    setState(() {
                      to = controller.toDate;
                    });
                  },
                  Timefunction: () async {
                    await controller.pickfromdaytime(
                        initialtime: controller.toDate,
                        fromEdit: from ?? DateTime.now(),
                        toEdit: DateTime.now(),
                        toDatePick: false,
                        isfromEdit: false,
                        istoEdit: false,
                        fromDatePick: false,
                        totimePick: true,
                        fromTimePick: false,
                        context: context);
                    setState(() {
                      to = controller.toDate;
                    });
                  },
                  width: width,
                  fromTo: "To"),
              SizedBox(
                height: height * 0.01,
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(10)),
                height: height * 0.2,
                child: TextFormField(
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  onChanged: (value) {
                    setState(() {
                      description = value;
                    });
                  },
                  controller: descController,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "   Add a description",
                      hintStyle: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildViewActions(
    BuildContext context,
    Event oldevent, {
    String? newTitle,
    String? newDesription,
    DateTime? newfrom,
    DateTime? newto,
    bool? newisAllDay,
  }) {
    final newevent = Event(
        location: widget.event.location,
        friendimage: widget.event.friendimage,
        from: newfrom ?? oldevent.from,
        to: newto ?? oldevent.to,
        title: newTitle ?? oldevent.title,
        description: newDesription ?? oldevent.description);
    return [
      const Icon(
        Icons.save,
        color: Colors.white,
      ),
      TextButton(
          onPressed: () {
            final eventProvider =
                Provider.of<EventProvider>(context, listen: false);
            print("pre");
            print(newevent.title);
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      content: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.edit),
                          Text(
                            "Do you want to edit the event?",
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("Cancel")),
                        TextButton(
                            onPressed: () {
                              eventProvider.editEvent(
                                  oldevent, newevent, context);
                            },
                            child: Text("Edit"))
                      ],
                    ));
          },
          child: const Text(
            "Save",
            style: TextStyle(color: Colors.white),
          ))
    ];
  }
}
