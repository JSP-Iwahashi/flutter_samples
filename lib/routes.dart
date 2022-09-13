import 'package:flutter_samples/view/calculator/calculator_page.dart';
import 'package:flutter_samples/view/clock/clock_page.dart';
import 'package:flutter_samples/view/othello/othello_page.dart';
import 'package:flutter_samples/view/stopwatch/stopwatch_page.dart';
import 'package:flutter_samples/view/top_page.dart';

enum AppRoute {
  top,
  clock,
  stopwatch,
  calculator,
  othello,
  // license,
}

extension AppRouteExt on AppRoute {
  String get name {
    switch (this) {
      case AppRoute.top:
        return '/';
      case AppRoute.clock:
        return '/clock';
      case AppRoute.stopwatch:
        return '/stopwatch';
      case AppRoute.calculator:
        return '/calculator';
      case AppRoute.othello:
        return '/othello';
      // case AppRoute.license:
      //   return '/license';
    }
  }
}

final appRoutes = {
  AppRoute.top.name: (context) => const TopPage(),
  AppRoute.clock.name: (context) => const ClockPage(),
  AppRoute.stopwatch.name: (context) => const StopwatchPage(),
  AppRoute.calculator.name: (context) => const CalculatorPage(),
  AppRoute.othello.name: (context) => const OthelloPage(),
  // AppRoute.license.routeName: (context) => const MyLicensePage(),
};
