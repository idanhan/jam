import 'package:budget_app/qualificationpage/dropdownbuttons/cityChange.dart';
import 'package:budget_app/qualificationpage/dropdownbuttons/insDropItem.dart';
import 'package:budget_app/qualificationpage/dropdownbuttons/levelChange.dart';
import 'package:budget_app/qualificationpage/dropdownbuttons/musicalInstruList.dart';
import 'package:budget_app/qualificationpage/genreDrop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import './dropdownbuttons/instrumentdropdown.dart';
import './dropdownbuttons/musicinstrudropdown.dart';
import './dropdownbuttons/cityForm.dart';
import './qualificationController.dart';
import './dropdownbuttons/gentre.dart';

class qualificationView extends StatelessWidget {
  final String username;
  final String password;
  final String email;
  const qualificationView(
      {super.key,
      required this.username,
      required this.email,
      required this.password});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final musicIns = MusicalInstrument();
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
          child: Container(
        margin: const EdgeInsets.all(10),
        height: height * 0.95,
        width: width,
        child: Consumer<qualificationController>(
          builder: (context, controller, widget) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: height * 0.08,
                ),
                Text(
                  "Welcome, lets continue making your profile",
                  style:
                      TextStyle(color: Colors.purple, fontSize: width * 0.08),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: height * 0.08,
                ),
                Row(
                  children: [
                    Text(
                      'Choose your level of expertise: ',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.white, fontSize: width * 0.04),
                    ),
                    SizedBox(
                      width: width * 0.05,
                    ),
                    Container(
                      height: height * 0.04,
                      child: instrumentButton(),
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Consumer<MusicalInstrument>(
                  builder: (context, controller, child) => Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Choose your instrument: ',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.white, fontSize: width * 0.04),
                          ),
                          SizedBox(
                            width: width * 0.05,
                          ),
                          Container(
                            height: height * 0.04,
                            child: musicInstrumentsDrop(
                              music: musicIns,
                            ),
                          ),
                          SizedBox(
                            width: width * 0.1,
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey)),
                        width: width * 0.95,
                        height: height * 0.1,
                        child: GridView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: false,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, childAspectRatio: 4),
                          itemBuilder: (context, index) {
                            return GridTile(
                                child: Row(children: [
                              controller.getlist.elementAt(index),
                              IconButton(
                                onPressed: () {
                                  controller.deleteInst(
                                      controller.getlist.elementAt(index));
                                },
                                icon: const Icon(Icons.remove_circle),
                              )
                            ]));
                          },
                          itemCount: controller.getlist.length,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Consumer<GenresList>(
                  builder: (context, controller, child) => Column(children: [
                    Row(
                      children: [
                        Text(
                          'Choose your genre: ',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.white, fontSize: width * 0.04),
                        ),
                        SizedBox(
                          width: width * 0.05,
                        ),
                        Container(
                          height: height * 0.04,
                          child: genreDrop(
                            list: controller,
                          ),
                        ),
                        SizedBox(
                          width: width * 0.05,
                        ),
                      ],
                    ),
                    Container(
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.grey)),
                      width: width * 0.95,
                      height: height * 0.1,
                      child: GridView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, childAspectRatio: 7 / 3),
                        itemBuilder: (context, index) {
                          return GridTile(
                            child: Row(children: [
                              Container(
                                width: width * 0.2,
                                height: height * 0.04,
                                child: Text(
                                  controller.getGenreList.elementAt(index),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    controller.delteItem(controller.getGenreList
                                        .elementAt(index));
                                  },
                                  icon: const Icon(Icons.remove_circle))
                            ]),
                          );
                        },
                        itemCount: controller.getGenreList.length,
                      ),
                    )
                  ]),
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                Text(
                  "Select your country state and city: ",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: width * 0.04),
                ),
                Container(
                    height: height * 0.2,
                    width: width * 0.8,
                    child: countryCityDrop()),
                Expanded(
                    child: Container(
                  height: height * 0.01,
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(
                        Size(width * 0.8, 50),
                      ),
                      backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 99, 166, 229),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    child: const Text(
                      "Create Profile",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      final String country =
                          context.read<StateCityChange>().countryValue;
                      final String city =
                          context.read<StateCityChange>().cityValue;
                      final List<String> instrumernts =
                          context.read<MusicalInstrument>().getListAsString();
                      final String level = context.read<ChangeLevel>().current;
                      final List<String> genres =
                          context.read<GenresList>().getGenreList;
                      controller.signup(context, email, password);
                      print("here country");
                      print(country);
                      await controller.register(
                          username,
                          email,
                          password,
                          DateTime.now().toString(),
                          country,
                          city,
                          instrumernts,
                          level,
                          genres);
                      controller.gotoScreenview(
                          context,
                          username,
                          email,
                          password,
                          DateTime.now().toString(),
                          country,
                          city,
                          instrumernts,
                          level,
                          genres);
                    },
                  ),
                ))
              ],
            );
          },
        ),
      )),
    );
  }
}
