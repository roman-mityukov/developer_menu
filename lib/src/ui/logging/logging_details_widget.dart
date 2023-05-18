import 'package:developer_menu/src/ui/logging/logging_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoggingDetailsWidget extends StatelessWidget {
  final String _string;

  const LoggingDetailsWidget(this._string, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              context.read<LoggingBloc>().add(ShareEvent());
            },
          ),
        ],
      ),
      body: Scrollbar(child: SingleChildScrollView(child: Text(_string))),
    );
  }
}
