import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart' as logging show Logger, Level, LogRecord;

enum LoggerLevel {
  all,
  error,
  warning,
  info,
  debug,
}

class Logger {
  final logging.Logger _delegate;

  Logger(this._delegate);

  void error(Object? message, [Object? error, StackTrace? stackTrace]) =>
      _delegate.severe(message, error, stackTrace);

  void warning(Object? message, [Object? error, StackTrace? stackTrace]) =>
      _delegate.warning(message, error, stackTrace);

  void info(Object? message, [Object? error, StackTrace? stackTrace]) =>
      _delegate.fine(message, error, stackTrace);

  void debug(Object? message, [Object? error, StackTrace? stackTrace]) =>
      _delegate.fine(message, error, stackTrace);
}

class LoggerService {
  static LoggerFactory? _loggerFactory;

  static Logger getLogger(String name) {
    if (_loggerFactory == null) {
      throw StateError('call init before createLogger');
    }
    return _loggerFactory!.create(name);
  }

  static void init(LoggerFactory loggerFactory) {
    _loggerFactory = loggerFactory;
  }
}

abstract interface class LoggerAppender {
  Future<void> append(String log);
}

class ConsoleLoggerAppender implements LoggerAppender {
  @override
  Future<void> append(String log) async {
    debugPrint(log);
  }
}

class RollingFileLoggerAppender implements LoggerAppender {
  final String dirPath;
  final int fileMaxSize;
  final int filesCount;

  RollingFileLoggerAppender(this.dirPath, this.fileMaxSize, this.filesCount);

  @override
  Future<void> append(String log) async {
    final file = File(dirPath);

    if (!file.existsSync()) {
      file.create();
    } else {
      if (file.lengthSync() > fileMaxSize) {
        file.deleteSync();
        file.createSync();
      }
    }

    file.writeAsStringSync(log, mode: FileMode.append);
  }
}

abstract class LoggerFactory {
  Logger create(String name);
}

class LoggerFactoryImpl implements LoggerFactory {
  LoggerFactoryImpl(LoggerLevel loggerLevel, List<LoggerAppender> appenders) {
    logging.Level level;

    switch (loggerLevel) {
      case LoggerLevel.all:
        level = logging.Level.ALL;
        break;
      case LoggerLevel.error:
        level = logging.Level.SEVERE;
        break;
      case LoggerLevel.warning:
        level = logging.Level.WARNING;
        break;
      case LoggerLevel.info:
        level = logging.Level.INFO;
        break;
      case LoggerLevel.debug:
        level = logging.Level.FINE;
        break;
    }

    logging.Logger.root.level = level;

    logging.Logger.root.onRecord.listen(
      (logging.LogRecord record) {
        String log;
        if (record.error != null) {
          log = '${record.level.name}: ${record.time}: ${record.loggerName}:'
              ' ${record.message}: ${record.error}\n'
              'stackTrace\n${record.stackTrace}\n';
        } else {
          log = '${record.level.name}: ${record.time}: ${record.loggerName}:'
              ' ${record.message}\n';
        }

        for(final appender in appenders) {
          appender.append(log);
        }
      },
    );
  }

  @override
  Logger create(String name) {
    return Logger(logging.Logger(name));
  }
}
