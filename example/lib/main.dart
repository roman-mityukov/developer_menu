import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:developer_menu/developer_menu.dart';
import 'package:developer_menu_example/logger/logger_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final Directory directory = await getApplicationDocumentsDirectory();
  final logsDirectoryPath = '${directory.path}/logs';
  LoggerService.init(
    LoggerFactoryImpl(
      LoggerLevel.all,
      [
        ConsoleLoggerAppender(),
        RollingFileLoggerAppender(logsDirectoryPath, 1024*1024, 3),
      ],
    ),
  );

  DeveloperMenu.init(logsDirectoryPath);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _logger = LoggerService.getLogger('MyApp');

  @override
  void initState() {
    super.initState();
    Timer.periodic(
      const Duration(seconds: 2),
      (timer) {
        _logger.debug('message id ${Random().nextDouble()}');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _logger.info('log1');
    _logger.info('log2');

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _incrementCounter() {
    Navigator.of(context).push(
      CupertinoPageRoute(builder: (context) => const DeveloperMenuWidget()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: const Placeholder(),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
