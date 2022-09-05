import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ClockPage extends StatefulWidget {
  const ClockPage({Key? key}) : super(key: key);

  @override
  State<ClockPage> createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage> {
  var _hourAngle = 0.0;
  var _minuteAngle = 0.0;
  var _secondAngle = 0.0;
  var _timer;

  @override
  void initState() {
    super.initState();
    _hourAngle = 0;
    _minuteAngle = 0;
    _secondAngle = 0;
    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        var now = DateTime.now();
        // 360° == 2π
        // 秒針の角度 = 2π × 秒 ÷ 60
        _secondAngle = pi * 2 * now.second / 60;
        // 分針の角度 = 2π × 分 ÷ 60
        // 秒針の角度を加味するため + 秒針の角度 ÷ 60
        _minuteAngle = pi * 2 * now.minute / 60 + _secondAngle / 60;
        // 時針の角度 = 2π × 時(12時間換算) ÷ 12
        // 分針の角度を加味するため + 分針の角度 ÷ 12
        _hourAngle = pi * 2 * (now.hour % 12) / 12 + _minuteAngle / 12;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Clock")),
      body: Container(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(children: [
            SvgPicture.asset('assets/clock.svg'),
            Transform.rotate(
              angle: _secondAngle,
              child: SvgPicture.asset('assets/second_hand.svg'),
            ),
            Transform.rotate(
              angle: _minuteAngle,
              child: SvgPicture.asset('assets/minute_hand.svg'),
            ),
            Transform.rotate(
              angle: _hourAngle,
              child: SvgPicture.asset('assets/hour_hand.svg'),
            ),
          ]),
        ),
      ),
    );
  }
}
