import 'package:budget_app/signup/signUpScreen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Pageviewcontroller extends ChangeNotifier {
  late final Future<LottieComposition> composition1;
  late final Future<LottieComposition> composition2;
  late final Future<LottieComposition> composition3;
  int currentpage = 0;

  Pageviewcontroller() {
    _init();
  }
  void _init() {
    composition1 = AssetLottie('assets/lottie5.json').load();
    composition2 = AssetLottie('assets/lottie4.json').load();
    composition3 = AssetLottie('assets/lottie3.json').load();
  }

  int get currentPage => currentpage;

  void setpage(int index) {
    currentpage = index;
    notifyListeners();
  }

  Future<void> goToSignup(BuildContext context) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SignUpScreen()));
  }
}
