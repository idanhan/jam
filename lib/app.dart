import 'package:budget_app/calander/EventProvider.dart';
import 'package:budget_app/chatscreen/chatservice.dart';
import 'package:budget_app/friendPage/friendpageController.dart';
import 'package:budget_app/friends/friendController.dart';
import 'package:budget_app/landingpage/landingviewmodel.dart';
import 'package:budget_app/maps/listMapevents.dart';
import 'package:budget_app/page/pageviewcontroller.dart';
import 'package:budget_app/profilepage/profileController.dart';
import 'package:budget_app/profilepage/screenController.dart';
import 'package:budget_app/profilepage/service.dart';
import 'package:budget_app/qualificationpage/dropdownbuttons/cityChange.dart';
import 'package:budget_app/qualificationpage/dropdownbuttons/levelChange.dart';
import 'package:budget_app/qualificationpage/dropdownbuttons/musicalInstruList.dart';
import 'package:budget_app/qualificationpage/genreDrop.dart';
import 'package:budget_app/requests/requestsController.dart';
import 'package:budget_app/signin/SigninController.dart';
import 'package:budget_app/signup/signupController.dart';
import 'package:budget_app/splashscreen/splashcontroller.dart';
import 'package:budget_app/splashscreen/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './qualificationpage/qualificationController.dart';
import './calander/calanderController.dart';
import './qualificationpage/authservices.dart';
import './chatscreen/chatcontroller.dart';
import './chatscreen/chathistorycontroller.dart';

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Pageviewcontroller(),
          lazy: true,
        ),
        ChangeNotifierProvider(
          create: (context) => SignupController(),
          lazy: true,
        ),
        ChangeNotifierProvider(
          create: (context) => SignInController(),
          lazy: true,
        ),
        ChangeNotifierProvider(
          create: (context) => qualificationController(),
          lazy: true,
        ),
        ChangeNotifierProvider(
          create: (context) => CalanderController(),
          lazy: true,
        ),
        ChangeNotifierProvider(
          create: (context) => EventProvider(),
          lazy: true,
        ),
        ChangeNotifierProvider(
          create: (context) => MusicalInstrument(),
          lazy: true,
        ),
        ChangeNotifierProvider(
          create: (context) => GenresList(),
          lazy: true,
        ),
        ChangeNotifierProvider(
          create: (context) => ChangeLevel(),
          lazy: true,
        ),
        ChangeNotifierProvider(
          create: (context) => StateCityChange(),
          lazy: true,
        ),
        ChangeNotifierProvider(
          create: (context) => ProfileController(),
          lazy: true,
        ),
        ChangeNotifierProvider(
          create: (context) => screenController(),
          lazy: true,
        ),
        ChangeNotifierProvider(
          create: (context) => Services(),
          lazy: true,
        ),
        ChangeNotifierProvider(
          create: (context) => FriendController(),
          lazy: true,
        ),
        ChangeNotifierProvider(
          create: (context) => RequestsController(),
          lazy: true,
        ),
        ChangeNotifierProvider(
          create: (context) => friendPagecontroller(),
          lazy: true,
        ),
        ChangeNotifierProvider(
          create: (context) => ListMapEvents(),
          lazy: true,
        ),
        ChangeNotifierProvider(
          create: (context) => AuthServices(),
          lazy: true,
        ),
        ChangeNotifierProvider(
          create: (context) => Chatcontroller(),
          lazy: true,
        ),
        ChangeNotifierProvider(
          create: (context) => ChatHistoryController(),
          lazy: true,
        ),
        ChangeNotifierProvider(
          create: (context) => ChatService(),
          lazy: true,
        ),
        ChangeNotifierProvider(
          create: (context) => Splashcontoller(),
          lazy: true,
        ),
        ChangeNotifierProvider(
          create: (context) => LandingViewModel(),
          lazy: true,
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color.fromRGBO(244, 243, 243, 1),
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromRGBO(244, 243, 243, 1)),
          useMaterial3: true,
          cardTheme: const CardTheme(
              color: Color.fromARGB(255, 182, 218, 226),
              clipBehavior: Clip.antiAliasWithSaveLayer),
        ),
        home: SplashScreen(),
      ),
    );
  }
}
