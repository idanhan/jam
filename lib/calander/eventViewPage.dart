import 'package:budget_app/calander/EventProvider.dart';
import 'package:budget_app/calander/calanderController.dart';
import 'package:budget_app/calander/event.dart';
import 'package:budget_app/calander/eventediting.dart';
import 'package:budget_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class EventViewPage extends StatelessWidget {
  final Event event;
  final double height;
  const EventViewPage({super.key, required this.event, required this.height});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 201, 114, 216),
        leading: const CloseButton(),
        actions: buildViewingActions(context, event),
      ),
      body: ListView(
        padding: const EdgeInsets.all(32),
        children: [
          ListTile(
            leading: const Text(
              "From:",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            trailing: Text("${Utils.toDate(event.from)}",
                style: const TextStyle(color: Colors.white, fontSize: 16)),
          ),
          SizedBox(
            height: height * 0.01,
          ),
          ListTile(
            leading: const Text(
              "To:",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            trailing: Text("${Utils.toDate(event.to)}",
                style: const TextStyle(color: Colors.white, fontSize: 16)),
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Center(
            child: ListTile(
              leading: const Text(
                "Title:",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              trailing: Text("${event.title}",
                  style: const TextStyle(color: Colors.white, fontSize: 26)),
            ),
          ),
          SizedBox(
            height: height * 0.01,
          ),
          ListTile(
            leading: const Text(
              "Description:",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            trailing: Text("${event.description}",
                style: const TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  List<Widget> buildViewActions(BuildContext context, Event event) {
    return [
      IconButton(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => EventEditingpage(
                    event: event,
                  ))),
          icon: const Icon(Icons.edit))
    ];
  }

  List<Widget> buildViewingActions(
    BuildContext context,
    Event event,
  ) {
    return [
      IconButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EventEditingpage(
                      event: event,
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
                actions: deleteActions(context),
              ),
            );
          },
          icon: const Icon(
            Icons.delete,
            color: Colors.white,
          ))
    ];
  }

  List<Widget> deleteActions(
    BuildContext context,
  ) {
    return [
      TextButton(
          onPressed: () {
            context.read<CalanderController>().delete(event, context);
          },
          child: Text("Delete Event")),
      TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Cancel"))
    ];
  }
}
