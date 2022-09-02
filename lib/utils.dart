import 'package:rxdart/rxdart.dart';

class Utils {
  static Function throttle(Function f, int ms) {
    final throttler = PublishSubject<Function>();
    throttler.throttleTime(Duration(milliseconds: ms)).forEach((f) => f());
    return () {
      throttler.add(f);
    };
  }
}
