import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import './event.dart';
import './calanderController.dart';
import '../utils/utils.dart';

class NewEvent extends StatelessWidget {
  NewEvent({super.key});
  final date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Consumer<CalanderController>(
        builder: (context, controller, child) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 201, 114, 216),
            leading: CloseButton(
              color: Colors.white,
              onPressed: () {
                controller.fromDate = DateTime.now();
                controller.toDate = DateTime.now();
                controller.fromTime = TimeOfDay.now();
                controller.toTime = TimeOfDay.now();
                controller.dispose();
                Navigator.pop(context);
              },
            ),
            actions: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    shadowColor: Colors.transparent,
                    elevation: 0,
                    backgroundColor: const Color.fromARGB(255, 201, 114, 216)),
                onPressed: () {
                  controller.saveForm(context);
                },
                label: const Text(
                  "save",
                  style: TextStyle(color: Colors.white),
                ),
                icon: const Icon(
                  Icons.done,
                  color: Colors.white,
                ),
              )
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: controller.formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: TextFormField(
                    validator: (value) => value != null && value.isEmpty
                        ? "title cannot be empty"
                        : null,
                    controller: controller.eventname1,
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
                    textDate: Utils.toDateDay(controller.fromDate),
                    textTime: Utils.toDateTime(controller.fromDate),
                    Datefunction: () {
                      controller.pickfromdaytime(
                          initialtime: DateTime.now(),
                          fromEdit: DateTime.now(),
                          toEdit: DateTime.now(),
                          isfromEdit: false,
                          istoEdit: false,
                          fromDatePick: true,
                          fromTimePick: false,
                          toDatePick: false,
                          totimePick: false,
                          context: context);
                    },
                    Timefunction: () {
                      controller.pickfromdaytime(
                          initialtime: DateTime.now(),
                          fromEdit: DateTime.now(),
                          toEdit: DateTime.now(),
                          isfromEdit: false,
                          istoEdit: false,
                          toDatePick: false,
                          fromDatePick: false,
                          totimePick: false,
                          fromTimePick: true,
                          context: context);
                    },
                    width: width,
                    fromTo: "From"),
                SizedBox(
                  height: height * 0.01,
                ),
                controller.buildFrom(
                    textDate: Utils.toDateDay(controller.toDate),
                    textTime: Utils.toDateTime(controller.toDate),
                    Datefunction: () {
                      controller.pickfromdaytime(
                          initialtime: DateTime.now(),
                          fromEdit: DateTime.now(),
                          toEdit: DateTime.now(),
                          isfromEdit: false,
                          istoEdit: false,
                          toDatePick: true,
                          fromDatePick: false,
                          totimePick: false,
                          fromTimePick: false,
                          context: context);
                    },
                    Timefunction: () {
                      controller.pickfromdaytime(
                          initialtime: DateTime.now(),
                          fromEdit: DateTime.now(),
                          toEdit: DateTime.now(),
                          isfromEdit: false,
                          istoEdit: false,
                          toDatePick: false,
                          fromDatePick: false,
                          totimePick: true,
                          fromTimePick: false,
                          context: context);
                    },
                    width: width,
                    fromTo: "To"),
                SizedBox(
                  height: height * 0.01,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Checkbox(
                      value: controller.ischecked,
                      onChanged: (bool? val) {
                        controller.checkboxfun(val ?? false);
                      }),
                  SizedBox(
                    width: width * 0.01,
                  ),
                  const Text(
                    "is all day?",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                ]),
                SizedBox(
                  height: height * 0.05,
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
                    controller: controller.description,
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
      ),
    );

    // Widget buildDropDownField(
    //     {required String text, required VoidCallback function}) {
    //   return Expanded(
    //     child: ListTile(
    //       title: Row(children: [
    //         Text(
    //           text,
    //           style: const TextStyle(color: Colors.white),
    //         ),
    //       ]),
    //       trailing: const Icon(Icons.arrow_drop_down),
    //       onTap: function,
    //     ),
    //   );
    // }

    // Widget buildFrom(
    //         {required String textDate,
    //         required String textTime,
    //         required VoidCallback Datefunction,
    //         required VoidCallback Timefunction,
    //         required double width,
    //         required String fromTo}) =>
    //     Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    //       Text(
    //         fromTo,
    //         style: TextStyle(color: Colors.white),
    //         textAlign: TextAlign.start,
    //       ),
    //       Row(
    //         children: [
    //           buildDropDownField(text: textDate, function: Datefunction),
    //           Container(
    //               width: width * 0.3,
    //               child: Row(
    //                 children: [
    //                   buildDropDownField(text: textTime, function: Timefunction)
    //                 ],
    //               )),
    //         ],
    //       ),
    //     ]);
  }
}
