import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

sealed class LoggingEvent {}

class ClearAllEvent implements LoggingEvent {}

class ShareEvent implements LoggingEvent {}

class ShowEvent implements LoggingEvent {}

sealed class LoggingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PendingActionState extends LoggingState {}

class AbsentFileState extends LoggingState {}

class ShowLogsState extends LoggingState {
  final String data;

  ShowLogsState(this.data);
}

class LoggingBloc extends Bloc<LoggingEvent, LoggingState> {
  final String _filePath;

  LoggingBloc(this._filePath) : super(PendingActionState()) {
    on<ClearAllEvent>(_onClearAllEvent);
    on<ShareEvent>(_onShareEvent);
    on<ShowEvent>(_onShowEvent);
  }

  Future<void> _onClearAllEvent(
    ClearAllEvent event,
    Emitter<LoggingState> emitter,
  ) async {
    await _guard(
      action: (file) async => file.deleteSync(),
      onAbsent: () => emitter(AbsentFileState()),
    );
  }

  Future<void> _onShareEvent(
    ShareEvent event,
    Emitter<LoggingState> emitter,
  ) async {
    await _guard(
      action: (_) async => Share.shareXFiles(
        [XFile(_filePath)],
        subject: 'Share',
        text: 'Share logs',
      ),
      onAbsent: () => emitter(AbsentFileState()),
    );
  }

  Future<void> _onShowEvent(
    ShowEvent event,
    Emitter<LoggingState> emitter,
  ) async {
    _guard(
      action: (file) async {
        emitter(ShowLogsState(file.readAsStringSync()));
        emitter(PendingActionState());
      },
      onAbsent: () => emitter(AbsentFileState()),
    );
  }

  Future<void> _guard({
    required Future<void> Function(File file) action,
    Function? onAbsent,
  }) async {
    final file = File(_filePath);
    if (file.existsSync()) {
      await action.call(file);
    } else {
      onAbsent?.call();
    }
  }
}
