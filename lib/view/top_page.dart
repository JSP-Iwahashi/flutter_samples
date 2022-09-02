import 'package:flutter/material.dart';
import 'package:flutter_samples/routes.dart';

class TopPage extends StatelessWidget {
  const TopPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter samples'),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoute.stopwatch.routeName),
              child: const Text('Stopwatch'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoute.license.routeName),
              child: const Text('MyLicencePage'),
            ),
            TextButton(
              onPressed: () => showLicensePage(context: context),
              child: const Text('showLicencePage'),
            ),
          ],
        ),
      ),
    );
  }
}
