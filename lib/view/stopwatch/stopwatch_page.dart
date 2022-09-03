import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StopwatchPage extends StatefulWidget {
  const StopwatchPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return StopwatchPageState();
  }
}

class StopwatchPageState extends State<StopwatchPage> {
  static const _initialTime = '00:00:00.000';
  bool _running = false;
  var _duration = const Duration();
  var _start;
  var _time;
  var _laps;
  var _timer;

  @override
  initState() {
    super.initState();
    _refresh();
    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (_running) {
        setState(() {
          // 経過時間を算出
          var now = DateTime.now();
          var diff = now.difference(_start);
          _start = now;
          _duration += diff;
          // Durationをそのまま文字列化するのは面倒なので、
          // 2000年1月1日 00:00:00 に加算して文字列化する
          var date = DateTime(2000).add(_duration);
          var formatter = DateFormat('HH:mm:ss.SSS');
          _time = formatter.format(date);
        });
      }
    });
  }

  @override
  dispose() {
    super.dispose();
    // 画面を閉じた後にタイマーが動作しているとエラーが発生してしまうため、
    // 画面を閉じる前にタイマーを破棄しておく
    _timer.cancel();
  }

  ///
  _toggleRun() {
    setState(() {
      _start = DateTime.now();
      _running = !_running;
    });
  }

  _refresh() {
    setState(() {
      if (_running) {
        _toggleRun();
      }
      _running = false;
      _time = _initialTime;
      _duration = const Duration();
      _laps = [
        _initialTime,
        _initialTime,
        _initialTime,
      ];
    });
  }

  _recordLap() {
    setState(() {
      _laps = [
        _time,
        _laps[0],
        _laps[1],
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stopwatch')),
      body: SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.contain,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text(
                  _time,
                  style: const TextStyle(fontSize: 40, color: Colors.black54),
                ),
                const SizedBox(height: 10),
                DefaultTextStyle.merge(
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.grey,
                  ),
                  child: Column(children: [
                    Text(_laps[0]),
                    Text(_laps[1]),
                    Text(_laps[2]),
                  ]),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 200,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      iconButton(_refresh, Icons.refresh),
                      iconButton(
                        _toggleRun,
                        _running ? Icons.stop : Icons.play_arrow,
                      ),
                      iconButton(_recordLap, Icons.timer),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconButton iconButton(void Function()? onPressed, IconData icon) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: Colors.black54,
      ),
      splashRadius: 24,
    );
  }
}
