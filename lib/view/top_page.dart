import 'package:flutter/material.dart';
import 'package:flutter_samples/routes.dart';

class TopPage extends StatelessWidget {
  const TopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter samples'),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: 400,
          child: ListView(
            restorationId: 'top_page_list_view',
            padding: const EdgeInsets.all(16),
            children: [
              ListTile(
                leading: const Icon(Icons.access_time),
                title: const Text('Clock'),
                onTap: () =>
                    Navigator.of(context).pushNamed(AppRoute.clock.routeName),
              ),
              ListTile(
                leading: const Icon(Icons.timer_outlined),
                title: const Text('Stopwatch'),
                onTap: () => Navigator.of(context)
                    .pushNamed(AppRoute.stopwatch.routeName),
              ),
              ListTile(
                leading: const Icon(Icons.calculate_outlined),
                title: const Text('Calculator'),
                onTap: () => Navigator.of(context)
                    .pushNamed(AppRoute.calculator.routeName),
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Licence'),
                onTap: () => showLicensePage(context: context),
              ),
              // ListTile(
              //   leading: const Icon(Icons.info_outline),
              //   title: const Text('Licence'),
              //   onTap: () => Navigator.of(context)
              //       .pushNamed(AppRoute.license.routeName),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
