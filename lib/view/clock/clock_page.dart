import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ClockPage extends StatefulWidget {
  const ClockPage({super.key});

  @override
  State<ClockPage> createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage> {
  /// 時針の角度ラジアン
  var _hourAngle = 0.0;

  /// 分針の角度ラジアン
  var _minuteAngle = 0.0;

  /// 秒針の角度ラジアン
  var _secondAngle = 0.0;

  /// 時計を定期更新するためのタイマー
  late Timer _timer;

  /// 次に時計を更新すべき時刻
  late DateTime _next;

  @override
  void initState() {
    super.initState();

    // 0時0分0秒で初期化
    _hourAngle = 0;
    _minuteAngle = 0;
    _secondAngle = 0;

    // ミリ秒以下を0クリアした現在時刻を次回の更新時刻としてセット
    // これに1秒ずつ加算することで、PCの時計に忠実に秒針を刻む
    // 例) now() → 13:10:15.333
    //     _next → 13:10:15.000
    _next = DateTime.now();
    _next = DateTime(
      _next.year,
      _next.month,
      _next.day,
      _next.hour,
      _next.minute,
      _next.second,
    );

    // 10msおきに処理を実行
    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      // 前回の実行から1秒経っていなければ何もせず終了
      // setStateが呼ばれると画面全体を無駄に再描画してしまうため
      // setStateを呼ぶ前にreturnすること！
      final now = DateTime.now();
      if (now.isBefore(_next)) {
        return;
      }

      // setState内で状態を更新する
      // setState外で更新すると画面が再描画されず、表示に反映されない
      setState(() {
        // 次回の実行時刻をセット
        _next = _next.add(const Duration(seconds: 1));

        // 360° == 2π
        // 1秒当たりの角度 = 2π ÷ 60
        // 秒針の角度 = 1秒当たりの角度 × 秒
        _secondAngle = pi * 2 / 60 * now.second;
        // 秒針を滑らかにする場合は、↑のreturn判定をコメントアウトして下記をアンコメント
        // _secondAngle += pi * 2 / 60 * now.millisecond / 1000;
        // 1分当たりの角度 = 2π ÷ 60
        // 分針の角度 = 1分当たりの角度 × 分
        // 秒針の角度を加味するため + 秒針の角度 ÷ 60
        _minuteAngle = pi * 2 / 60 * now.minute + _secondAngle / 60;
        // 1時間当たりの角度 = 2π × 2 ÷ 12
        // 時針の角度 = 1時間当たりの角度 × 時(12時間換算)
        // 分針の角度を加味するため + 分針の角度 ÷ 12
        _hourAngle = pi * 2 / 12 * (now.hour % 12) + _minuteAngle / 12;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    // 画面を破棄する際にはタイマーを止める
    // 止めずに放置すると、画面が破棄された後に時計を更新しようとしてヌルポ的なエラーになる
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clock')),
      body: Container(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Stack(
            children: [
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
            ],
          ),
        ),
      ),
    );
  }
}
