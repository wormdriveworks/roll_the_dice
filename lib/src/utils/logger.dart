import 'package:logger/logger.dart';

class Log {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
    ),
  );

  static void d(String message) => _logger.d(message); // 디버그 로그
  static void i(String message) => _logger.i(message); // 정보 로그
  static void w(String message) => _logger.w(message); // 경고 로그
  static void e(String message, [dynamic error]) =>
      _logger.e(message, error: error); // 에러 로그
}