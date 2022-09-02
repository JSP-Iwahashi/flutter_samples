import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyLicensePage extends StatefulWidget {
  const MyLicensePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyLicensePageState();
  }
}
class MyLicensePageState extends State<MyLicensePage> {
  List<List<String>> licenses = [];

  @override
  initState() {
    super.initState();
    var count = 0;
    LicenseRegistry.licenses.listen((license) {
      // license.packagesとlicense.paragraphsの返り値がIterableなのでtoList()してる
      final packages = license.packages.toList();
      final paragraphs = license.paragraphs.toList();
      final packageName = packages.map((e) => e).join('');
      final paragraphText = paragraphs.map((e) => e.text).join('\n');
      // この辺の状態更新とかは環境に合わせてお好みで
      licenses.add([packageName, paragraphText]);
      setState(() {
        licenses = licenses;
      });
      if (count++ == 3) {
        print(packages);
        for (var e in paragraphs) {
          var indent = '    ' * e.indent;
          print('###${indent} ${e.text.substring(0, 10)} ${e.indent}');
        }
      }
    });
    print('MyLicensePage');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MyLicensePage')),
      body: ListView.builder(
        itemCount: licenses.length,
        itemBuilder: (context, index) {
          final license = licenses[index];
          return Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  license[0],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  license[1],
                  style: const TextStyle(fontSize: 12),
                ),
                // FutureBuilder(builder: (context, snapshot) => ,)
              ],
            ),
          );
        },
      ),
    );
  }
}
