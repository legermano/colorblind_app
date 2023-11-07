import 'package:boilerplate/presentation/about/AboutDeutan.dart';
import 'package:boilerplate/presentation/about/AboutProtan.dart';
import 'package:boilerplate/presentation/about/AboutTritan.dart';
import 'package:boilerplate/presentation/camera/camera.dart';
import 'package:boilerplate/presentation/home_new/home.dart';
import 'package:boilerplate/presentation/ishihara/ishihara.dart';
import 'package:boilerplate/presentation/login/create_account.dart';
import 'package:boilerplate/presentation/login/login.dart';
import 'package:boilerplate/presentation/onboarding/onboarding.dart';
import 'package:boilerplate/presentation/results/detailed_result.dart';
import 'package:boilerplate/presentation/results/result.dart';
import 'package:flutter/material.dart';

class Routes {
  Routes._();

  //static variables
  static const String splash = '/splash';
  static const String login = '/login';
  static const String createAccout = '/create-account';
  static const String home = '/post';
  static const String onboarding = '/onboarding';
  static const String ishihara = '/ishihara';
  static const String results = '/results';
  static const String detailedResults = '/detailed-results';
  static const String camera = '/camera';
  static const String aboutProtan = '/about-protan';
  static const String aboutDeutan = '/about-deutan';
  static const String aboutTritan = '/about-tritan';

  static final routes = <String, WidgetBuilder>{
    login: (BuildContext context) => LoginScreen(),
    createAccout: (BuildContext context) => CreateAccountScreen(),
    home: (BuildContext context) => HomeScreen(),
    onboarding: (BuildContext context) => OnboardingScreen(),
    ishihara: (BuildContext context) => IshiharaScreen(),
    results: (BuildContext context) => ResultsScreen(),
    detailedResults: (BuildContext context) => DetailedResultsScreen(),
    camera: (BuildContext context) => CameraScreen(),
    aboutProtan: (BuildContext context) => AboutProtanScreen(),
    aboutDeutan: (BuildContext context) => AboutDeutanScreen(),
    aboutTritan: (BuildContext context) => AboutTritanScreen(),
  };
}
