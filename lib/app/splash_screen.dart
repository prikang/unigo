import 'package:flutter/material.dart';

import '../const/app_colors_const.dart';

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool lightMode =
        MediaQuery.of(context).platformBrightness == Brightness.light;
    return Scaffold(
      backgroundColor: lightMode
          ? AppColorConst.kappscafoldbgyellow
          : AppColorConst.kappscafoldbgyellow,
      body: Center(
          child: lightMode
              ? Image.asset("assets/images/logooo.png")
              : Image.asset("assets/images/logooo.png")),
    );
  }
}

class Init {
  Init._();
  static final instance = Init._();

  Future initialize() async {
    // This is where you can initialize the resources needed by your app while
    // the splash screen is displayed.  Remove the following example because
    // delaying the user experience is a bad design practice!
    await Future.delayed(const Duration(seconds: 3));
  }
}
