import 'package:flutter/material.dart';
import 'package:whatmedi3/pages/mainpage.dart';
import 'package:whatmedi3/backdata/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splash_view/splash_view.dart';
import 'package:whatmedi3/pages/intropage.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstRun = prefs.getBool('isFirstRun') ?? true;
  await prefs.setBool('isFirstRun', false);
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: createMaterialColor(whatmedicol.kPrimaryColor),
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: Colors.white),
        ),
        useMaterial3: false
      ),
      home: SplashView(
        showStatusBar: true,
        loadingIndicator: LinearProgressIndicator(),
            logo: FlutterLogo(),
            bottomLoading: true,
            done: Done( isFirstRun
                ? IntroScreen()
                :HomePage(), curve: Curves.ease
              //MainPage(requiredCamera: firstCamera),
            ),
          ),),
  );
}
