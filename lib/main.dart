import 'package:flutter/material.dart';
import 'package:flutter_samples/common/logger.dart';
import 'package:flutter_samples/routes.dart';

void main() {
  runApp(const MyApp());

  logger.finest('This is finest log.');
  logger.finer('This is finer log.');
  logger.fine('This is fine log.');
  logger.config('This is config log.');
  logger.info('This is info log.');
  logger.warning('This is warning log.');
  logger.severe('This is severe log.');
  logger.shout('This is shout log.');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
