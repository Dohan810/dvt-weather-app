// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';

class KPrint {
  static bool _debugMode = kDebugMode;
  static const String _reset = '\x1B[0m';
  static const String _red = '\x1B[31m';
  static const String _green = '\x1B[32m';
  static const String _yellow = '\x1B[33m';
  static const String _blue = '\x1B[34m';

  static void setDebugMode(bool enabled) {
    _debugMode = enabled;
  }

  static void debug(dynamic message, [String? tag]) {
    if (!_debugMode) return;
    final timestamp = DateTime.now().toString().split('.').first;
    final tagStr = tag != null ? '[$tag] ' : '';
    print('$_blue📘 DEBUG $tagStr($timestamp): $message$_reset');
  }

  static void info(dynamic message, [String? tag]) {
    if (!_debugMode) return;
    final timestamp = DateTime.now().toString().split('.').first;
    final tagStr = tag != null ? '[$tag] ' : '';
    print('$_green📗 INFO $tagStr($timestamp): $message$_reset');
  }

  static void warning(dynamic message, [String? tag]) {
    if (!_debugMode) return;
    final timestamp = DateTime.now().toString().split('.').first;
    final tagStr = tag != null ? '[$tag] ' : '';
    print('$_yellow📙 WARNING $tagStr($timestamp): $message$_reset');
  }

  static void error(dynamic message, [String? tag, StackTrace? stackTrace]) {
    if (!_debugMode) return;
    final timestamp = DateTime.now().toString().split('.').first;
    final tagStr = tag != null ? '[$tag] ' : '';
    print('$_red📕 ERROR $tagStr($timestamp): $message');
    if (stackTrace != null) {
      print('StackTrace: \n$stackTrace$_reset');
    }
  }
}
