import 'package:flutter_samples/view/license/my_license_page.dart';
import 'package:flutter_samples/view/stopwatch/stopwatch_page.dart';
import 'package:flutter_samples/view/top_page.dart';

enum AppRoute {
  top,
  stopwatch,
  license,
}

extension AppRouteExt on AppRoute {
  String get routeName {
    switch (this) {
      case AppRoute.top:
        return '/';
      case AppRoute.stopwatch:
        return '/stopwatch';
      case AppRoute.license:
        return '/license';
    }
  }
}

final appRoutes = {
  AppRoute.top.routeName: (context) => const TopPage(),
  AppRoute.stopwatch.routeName: (context) => const StopwatchPage(),
  AppRoute.license.routeName: (context) => const MyLicensePage(),
};
