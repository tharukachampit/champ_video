import 'package:debug_logger/debug_logger.dart';

class Logger {
  static bool enabled = true;

  static debug(dynamic message) {
    if (enabled) {
      DebugLogger.debug(message);
    }
  }

  static info(dynamic message) {
    if (enabled) {
      DebugLogger.info(message);
    }
  }

  static warning(dynamic message) {
    if (enabled) {
      DebugLogger.warning(message);
    }
  }

  static error(dynamic message) {
    if (enabled) {
      DebugLogger.error(message);
    }
  }
}
