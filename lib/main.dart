import 'package:flutter/material.dart';
import 'package:flutter_samples/view/license/my_license_page.dart';
import 'package:flutter_samples/routes.dart';
import 'package:flutter_samples/view/top_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Samples',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: appRoutes,
    );
  }
}
