import 'package:flutter/material.dart';

const _cellWH = 98.0;
const _lineWidth = 2.0;
const _nCells = 8;
const _nLines = _nCells + 1;
const _lineXY = _cellWH + _lineWidth;
const _boardWH = _cellWH * _nCells + _lineWidth * _nLines;
const _piecePadding = 8.0;
const _pieceRadius = _cellWH / 2 - _piecePadding;

// 駒をおいた際に裏返しチェックすべき座標
final _checkLines = [
  // 左上
  [P(-1, -1), P(-2, -2), P(-3, -3), P(-4, -4), P(-5, -5), P(-6, -6), P(-7, -7)],
  // 上
  [P(0, -1), P(0, -2), P(0, -3), P(0, -4), P(0, -5), P(0, -6), P(0, -7)],
  // 右上
  [P(1, -1), P(2, -2), P(3, -3), P(4, -4), P(5, -5), P(6, -6), P(7, -7)],
  // 左
  [P(-1, 0), P(-2, 0), P(-3, 0), P(-4, 0), P(-5, 0), P(-6, 0), P(-7, 0)],
  // 右
  [P(1, 0), P(2, 0), P(3, 0), P(4, 0), P(5, 0), P(6, 0), P(7, 0)],
  // 左下
  [P(-1, 1), P(-2, 2), P(-3, 3), P(-4, 4), P(-5, 5), P(-6, 6), P(-7, 7)],
  // 下
  [P(0, 1), P(0, 2), P(0, 3), P(0, 4), P(0, 5), P(0, 6), P(0, 7)],
  // 右下
  [P(1, 1), P(2, 2), P(3, 3), P(4, 4), P(5, 5), P(6, 6), P(7, 7)],
];

class P {
  P(this.x, this.y);

  P.fromIndex(int index)
      : x = index % _nCells,
        y = (index / _nCells).floor();

  P.fromOffset(Offset offset)
      : x = (offset.dx / _lineXY).floor(),
        y = (offset.dy / _lineXY).floor();

  final int x;
  final int y;

  int get toIndex {
    return x + y * _nCells;
  }

  P operator +(P p) => P(x + p.x, y + p.y);

  P operator -(P p) => P(x - p.x, y - p.y);

  @override
  String toString() => 'Position(${x}, ${y})';
}

enum CellStatus {
  empty,
  black,
  white,
}

class OthelloPage extends StatefulWidget {
  const OthelloPage({super.key});

  @override
  State<OthelloPage> createState() => _OthelloPageState();
}

class _OthelloPageState extends State<OthelloPage> {
  final List<CellStatus> _cells = [];
  int _whites = 0;
  int _blacks = 0;
  var _next = CellStatus.black;

  @override
  void initState() {
    super.initState();
    initCells();
  }

  void initCells() {
    _cells.clear();
    for (var i = 0; i < _nCells * _nCells; i++) {
      switch (i) {
        case 27:
          _cells.add(CellStatus.white);
          break;
        case 28:
          _cells.add(CellStatus.black);
          break;
        case 35:
          _cells.add(CellStatus.black);
          break;
        case 36:
          _cells.add(CellStatus.white);
          break;
        default:
          _cells.add(CellStatus.empty);
      }
    }
    _whites = 2;
    _blacks = 2;
  }

  List<P> _getPutablePositions(P pos, CellStatus status) {
    // 空欄化は常に許可
    if (status == CellStatus.empty) {
      return [pos];
    }

    // 以下、わかりやすいようにstatusが黒色と仮定して変数名名＆コメント
    final puttable = <P>[];
    for (final checkLine in _checkLines) {
      var findWhite = false;
      final t = <P>[];
      for (final diff in checkLine) {
        // チェック先が盤面の範囲外ならスルー
        final target = pos + diff;
        final index = target.toIndex;
        if (target.x < 0 || target.x >= _nCells) {
          continue;
        }
        if (target.y < 0 || target.y >= _nCells) {
          continue;
        }
        if (index < 0 || index >= _cells.length) {
          continue;
        }

        // チェック先が空欄の場合は置けない
        if (_cells[index] == CellStatus.empty) {
          break;
        }

        // チェック先が白色ならフラグを立てる
        if (_cells[index] != status) {
          findWhite = true;
          t.add(target);
        }
        // チェック先が黒色かつ白発見フラグが立っていれば置ける
        else if (findWhite) {
          puttable.addAll(t);
          break;
        }
        // そうでなければ置けない
        else {
          break;
        }
      }
    }

    // 置けるなら、引数の座標も追加
    if (puttable.isNotEmpty) {
      puttable.add(pos);
    }
    return puttable;
  }

  void _putCell(P pos, CellStatus status) {
    setState(() {
      final puttable = _getPutablePositions(pos, status);
      if (puttable.isNotEmpty) {
        for (final p in puttable) {
          _cells[p.x + p.y * _nCells] = status;
        }
        _countCells();
        if (_next == CellStatus.black) {
          _next = CellStatus.white;
        } else {
          _next = CellStatus.black;
        }
      }
    });
  }

  void _countCells() {
    _whites = 0;
    _blacks = 0;
    for (final p in _cells) {
      switch (p) {
        case CellStatus.white:
          _whites++;
          break;
        case CellStatus.black:
          _blacks++;
          break;
        case CellStatus.empty:
          // do nothing.
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Othello')),
      body: Container(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: SizedBox.expand(
            child: FittedBox(
              child: Row(
                children: [
                  SizedBox(
                    width: 802,
                    height: 802,
                    child: Stack(
                      children: [
                        const CustomPaint(painter: _OthelloBoardPainter()),
                        GestureDetector(
                          onTapDown: (details) => _putCell(
                            P.fromOffset(details.localPosition),
                            CellStatus.black,
                          ),
                          onSecondaryTapDown: (details) => _putCell(
                            P.fromOffset(details.localPosition),
                            CellStatus.white,
                          ),
                          onTertiaryTapDown: (details) => _putCell(
                            P.fromOffset(details.localPosition),
                            CellStatus.empty,
                          ),
                          child: CustomPaint(
                            painter: _OthelloPiecePainter(_cells),
                            child: Container(), // GestureDetector検知用ダミーコンテナ
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  DefaultTextStyle.merge(
                    style: const TextStyle(fontSize: 24),
                    child: DecoratedBox(
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 4,
                          )
                        ],
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Score'),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const SizedBox(width: 16),
                                Container(
                                  alignment: Alignment.center,
                                  width: _pieceRadius,
                                  height: _pieceRadius,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(width: 2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text('${_whites}'),
                                ),
                                const SizedBox(width: 16, height: 16),
                                Container(
                                  alignment: Alignment.center,
                                  width: _pieceRadius,
                                  height: _pieceRadius,
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '${_blacks}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Text('Next'),
                            Row(
                              children: [
                                const SizedBox(width: 16),
                                _next == CellStatus.black
                                    ? Container(
                                        alignment: Alignment.center,
                                        width: _pieceRadius,
                                        height: _pieceRadius,
                                        decoration: const BoxDecoration(
                                          color: Colors.black,
                                          shape: BoxShape.circle,
                                        ),
                                      )
                                    : Container(
                                        alignment: Alignment.center,
                                        width: _pieceRadius,
                                        height: _pieceRadius,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(width: 2),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OthelloBoardPainter extends CustomPainter {
  const _OthelloBoardPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // 背景色を描画
    final green = Paint()..color = Colors.green;
    canvas.drawRect(const Rect.fromLTWH(0, 0, _boardWH, _boardWH), green);

    // マス目を描画
    final black = Paint()
      ..color = Colors.grey.shade800
      ..strokeWidth = _lineWidth;
    for (var i = 0; i < _nLines; i++) {
      final xy = i * _lineXY + 1;
      canvas
        ..drawLine(Offset(xy, 0), Offset(xy, _boardWH), black)
        ..drawLine(Offset(0, xy), Offset(_boardWH, xy), black);
    }

    // 中点を描画
    canvas
      ..drawCircle(const Offset(_lineXY * 2 + 1, _lineXY * 2 + 1), 5, black)
      ..drawCircle(const Offset(_lineXY * 2 + 1, _lineXY * 6 + 1), 5, black)
      ..drawCircle(const Offset(_lineXY * 6 + 1, _lineXY * 2 + 1), 5, black)
      ..drawCircle(const Offset(_lineXY * 6 + 1, _lineXY * 6 + 1), 5, black);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class _OthelloPiecePainter extends CustomPainter {
  const _OthelloPiecePainter(this._pieces);

  final List<CellStatus> _pieces;

  @override
  void paint(Canvas canvas, Size size) {
    final black = Paint()..color = Colors.black;
    final white = Paint()..color = Colors.white;
    for (var i = 0; i < _pieces.length; i++) {
      final x = i % _nCells;
      final y = (i / _nCells).floor();
      final offset = Offset(
        (x + 0.5) * _lineXY + 1,
        (y + 0.5) * _lineXY + 1,
      );
      switch (_pieces[i]) {
        case CellStatus.empty:
          break;
        case CellStatus.black:
          canvas.drawCircle(offset, _pieceRadius, black);
          break;
        case CellStatus.white:
          canvas.drawCircle(offset, _pieceRadius, white);
          break;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
