import 'package:flutter/foundation.dart';

void printDebug(String? message, {bool? isStart, bool? isEnd}) {
  if (kDebugMode) {
    if (isStart == true) {
      message = '< ${message != null ? '$message ' : ''} ---------------------------------- ';
    } else if (isEnd == true) {
      message = '> ${message != null ? '$message ' : ''} ---------------------------------- ';
    } else {
      message = '| $message';
    }
  }
}
