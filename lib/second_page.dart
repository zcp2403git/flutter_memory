import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'memory_monitor_manager.dart';

class SecondTestPage extends StatelessWidget {
  final value;
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
              MemoryMonitorManager.mLeakContext = this;
              Future.delayed(Duration(seconds: 5), () {
                print('delay 5s ');
                MemoryMonitorManager.instance.analyze();
              });
              Navigator.pop(context);
            }),
      ])),
    );
  }
}
