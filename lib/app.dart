import 'package:budget_app/calander/EventProvider.dart';
import 'package:budget_app/friendPage/friendpageController.dart';
import 'package:budget_app/friendPage/friendpageScreen.dart';
import 'package:budget_app/friends/friendController.dart';
import 'package:budget_app/page/pageview.dart';
import 'package:budget_app/page/pageviewcontroller.dart';
import 'package:budget_app/profilepage/profileController.dart';
import 'package:budget_app/profilepage/screenController.dart';
import 'package:budget_app/profilepage/service.dart';
import 'package:budget_app/qualificationpage/dropdownbuttons/cityChange.dart';
import 'package:budget_app/qualificationpage/dropdownbuttons/cityForm.dart';
import 'package:budget_app/qualificationpage/dropdownbuttons/levelChange.dart';
import 'package:budget_app/qualificationpage/dropdownbuttons/musicalInstruList.dart';
import 'package:budget_app/qualificationpage/genreDrop.dart';
import 'package:budget_app/requests/requestsController.dart';
import 'package:budget_app/signin/SigninController.dart';
import 'package:budget_app/signup/signupController.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './qualificationpage/qualificationController.dart';
import './calander/calanderController.dart';
import './profilepage/profileController.dart';

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Pageviewcontroller()),
        ChangeNotifierProvider(create: (context) => SignupController()),
        ChangeNotifierProvider(create: (context) => SignInController()),
        ChangeNotifierProvider(create: (context) => qualificationController()),
        ChangeNotifierProvider(create: (context) => CalanderController()),
        ChangeNotifierProvider(create: (context) => EventProvider()),
        ChangeNotifierProvider(create: (context) => MusicalInstrument()),
        ChangeNotifierProvider(create: (context) => GenresList()),
        ChangeNotifierProvider(create: (context) => ChangeLevel()),
        ChangeNotifierProvider(create: (context) => StateCityChange()),
        ChangeNotifierProvider(create: (context) => ProfileController()),
        ChangeNotifierProvider(create: (context) => screenController()),
        ChangeNotifierProvider(create: (context) => Services()),
        ChangeNotifierProvider(create: (context) => FriendController()),
        ChangeNotifierProvider(create: (context) => RequestsController()),
        ChangeNotifierProvider(create: (context) => friendPagecontroller())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
          useMaterial3: true,
        ),
        home: Pageview(),
      ),
    );
  }
}
