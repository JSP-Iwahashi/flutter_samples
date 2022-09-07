import 'package:flutter/foundation.dart';
import 'package:simple_logger/simple_logger.dart';

// ロガー初期化
// デバッグ起動の場合のみ全ログ出力
// なお、ログレベルは下記通り
// ALL     (0)    : 全てのログを出力
// FINEST  (300)  : 最も詳細なログ
// FINER   (400)  : より詳細なログ
// FINE    (500)  : 詳細なログ
// CONFIG  (700)  : 静的構成ログ
// INFO    (800)  : 情報ログ
// WARNING (900)  : 潜在的な警告ログ
// SEVERE  (1000) : 深刻な警告ログ
// SHOUT   (1200) : より深刻な警告ログ
// OFF     (2000) : ログ無効
final logger = SimpleLogger()
  ..setLevel(
    kDebugMode ? Level.ALL : Level.OFF,
    includeCallerInfo: kDebugMode,
  );
