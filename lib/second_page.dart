import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'memory_monitor_manager.dart';

class SecondTestPage extends StatelessWidget {
  final value;
  static BuildContext mLeakContext;

  SecondTestPage({Key key, @required this.value}) : super(key: key) {
    MemoryMonitorManager.instance.watch(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SecondPage'),
      ),
      body: SafeArea(
          child: new Column(children: [
        RaisedButton(
            child: Text("$value"),
            onPressed: () {
              mLeakContext = context;
              Future.delayed(Duration(seconds: 5), () {
                print('delay 5s ');
              });
              Navigator.pop(context);
              MemoryMonitorManager.instance.analyze();
            }),
      ])),
    );
  }
}
