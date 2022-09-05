import 'dart:async';

import 'package:expressions/expressions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({Key? key}) : super(key: key);

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  static const _error = 'error';
  var _expression = '0';
  var _focusNode = FocusNode();
  var _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  void _addExpression(String c) {
    setState(() {
      switch (c) {
        case 'C':
          _expression = '0';
          break;

        case '=':
          // 全角 ×, ÷ を半角 *, / に変換
          var e = _expression.replaceAll('×', '*');
          e = e.replaceAll('÷', '/');
          print('_expression: $_expression, e: $e');

          try {
            // 数式実行ライブラリで式を実行
            final exp = Expression.parse(e);
            const eval = ExpressionEvaluator();
            final result = eval.eval(exp, {}).toString();

            // 式でない文字列を渡すと null という文字列が返る？ようなので
            // error で置き換える
            if (result == 'null') {
              _expression = _error;
            } else {
              _expression = result;
            }
          } catch (e) {
            // 式がおかしい場合は error で置き換える
            _expression = _error;
          }
          break;

        case '0':
        case '1':
        case '2':
        case '3':
        case '4':
        case '5':
        case '6':
        case '7':
        case '8':
        case '9':
        case '.':
        case '+':
        case '-':
        case '*':
        case '/':
          // 式が error または 0 なら空にしておく
          switch (_expression) {
            case _error:
            case '0':
              _expression = '';
          }
          _expression += c;
          break;

        default:
          // 上記以外のキーは無視
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // GridViewのアイテムはデフォルトで正方形になる。
    // 画面ピッタリになるよう、GridViewのアイテムの縦横比を算出する。
    final size = MediaQuery.of(context).size;
    final gridWidth = size.width - 16;
    final gridHeight = (size.height - 56 - 16) * 4 / 5;
    final aspectRatio = gridWidth / gridHeight;
    print({size, "${gridWidth}x$gridHeight", aspectRatio});

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
      ),
      body: KeyboardListener(
        focusNode: _focusNode,
        onKeyEvent: (e) {
          print(e);
          if (e is KeyDownEvent) {
            if (e.logicalKey == LogicalKeyboardKey.enter) {
              _addExpression('=');
            }
            else if (e.logicalKey == LogicalKeyboardKey.keyC) {
              _addExpression('C');
            }
            else {
              _addExpression(e.character ?? '');
            }
          }
        },
        child: Container(
          color: Colors.grey.shade200,
          constraints: const BoxConstraints(maxHeight: double.infinity),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        _expression,
                        style: const TextStyle(fontSize: 64.0),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: GridView.count(
                    crossAxisCount: 4,
                    childAspectRatio: aspectRatio,
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
                    children: [
                      '7', '8', '9', '÷', //
                      '4', '5', '6', '×', //
                      '1', '2', '3', '-', //
                      'C', '0', '=', '+', //
                    ]
                        .map(
                          (label) => GridTile(
                            child: MaterialButton(
                              color: Colors.white,
                              onPressed: () {
                                _addExpression(label);
                              },
                              child: Text(
                                label,
                                style: TextStyle(
                                  fontSize: 48,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  final String label;
  final void Function() onPressed;

  const Button({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(fontSize: 36.0),
      ),
    );
  }
}

// 676x796