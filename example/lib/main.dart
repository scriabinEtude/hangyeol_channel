import 'package:example/test_channel.dart';
import 'package:flutter/material.dart';

void main() {
  final channel = TestChannel(
      url: 'your host', payload: {'required': 'values', 'on every': 'send'});

  channel.connect();
  channel.exit();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(),
    );
  }
}
