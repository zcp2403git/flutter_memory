import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'MemoryMonitorManager.dart';

class SecondTestPage extends StatelessWidget {
  final value;
  static BuildContext mContext;

  SecondTestPage({Key key, @required this.value}) : super(key: key) {
    MemoryMonitorManager.instance.watch(this);
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _controller = new TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('SecondPage'),
      ),
      body: SafeArea(
          child: new Column(children: [
        RaisedButton(
            child: Text("$value"),
            onPressed: () {
              mContext = context;
              Future.delayed(Duration(seconds: 3), () {
                print('delay 3s');
              });
              Navigator.pop(context);
              MemoryMonitorManager.instance.analyze();
            }),
      ])),
    );
  }
}
