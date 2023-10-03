import 'package:boilerplate/presentation/camera/camera.dart';
import 'package:boilerplate/presentation/home_new/home.dart';
import 'package:boilerplate/presentation/ishihara/ishihara.dart';
import 'package:boilerplate/presentation/login/login.dart';
import 'package:boilerplate/presentation/onboarding/onboarding.dart';
import 'package:boilerplate/presentation/results/results.dart';
import 'package:flutter/material.dart';

class Routes {
  Routes._();

  //static variables
  static const String splash = '/splash';
  static const String login = '/login';
  static const String home = '/post';
  static const String onboarding = '/onboarding';
  static const String ishihara = '/ishihara';
  static const String results = '/results';
  static const String camera = '/camera';

  static final routes = <String, WidgetBuilder>{
    login: (BuildContext context) => LoginScreen(),
    home: (BuildContext context) => HomeScreen(),
    onboarding: (BuildContext context) => OnboardingScreen(),
    ishihara: (BuildContext context) => IshiharaScreen(),
    results: (BuildContext context) => ResultsScreen(),
    camera: (BuildContext context) => CameraScreen(),
  };
}