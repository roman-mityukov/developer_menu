import 'package:developer_menu/src/ui/logging/logging_bloc.dart';
import 'package:developer_menu/src/ui/logging/logging_details_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoggingWidget extends StatelessWidget {
  const LoggingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoggingBloc, LoggingState>(
      buildWhen: (previous, current) {
        return current is PendingActionState;
      },
      builder: (context, state) {
        if (state is PendingActionState) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Logging',
                  style: Theme.of(context).textTheme.titleLarge!,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<LoggingBloc>().add(ShowEvent()),
                  child: const Text('Show'),
                ),
                ElevatedButton(
                  onPressed: () => context.read<LoggingBloc>().add(ShareEvent()),
                  child: const Text('Share'),
                ),
                ElevatedButton(
                  onPressed: () =>
                      context.read<LoggingBloc>().add(ClearAllEvent()),
                  child: const Text('Clear all'),
                ),
              ],
            ),
          );
        } else {
          throw StateError('Invalid state');
        }
      },
      listenWhen: (previous, current) {
        return current is AbsentFileState || current is ShowLogsState;
      },
      listener: (context, state) {
        if (state is AbsentFileState) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Error'),
                content: const Text('There is no log file'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else if (state is ShowLogsState) {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (_) => BlocProvider<LoggingBloc>.value(
                value: context.read<LoggingBloc>(),
                child: LoggingDetailsWidget(state.data),
              ),
            ),
          );
        } else {
          throw StateError('Invalid state');
        }
      },
    );
  }
}
