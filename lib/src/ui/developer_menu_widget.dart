import 'package:developer_menu/developer_menu.dart';
import 'package:developer_menu/src/ui/logging/logging_bloc.dart';
import 'package:developer_menu/src/ui/logging/logging_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeveloperMenuWidget extends StatelessWidget {
  const DeveloperMenuWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DeveloperMenu'),
      ),
      body: BlocProvider<LoggingBloc>(
        create: (context) {
          return LoggingBloc(DeveloperMenu.logFilePath!);
        },
        child: const LoggingWidget(),
      ),
    );
  }
}
