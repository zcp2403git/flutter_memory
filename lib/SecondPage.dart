import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  static BuildContext mContext;
  String value;
  GlobalKey _formKey = new GlobalKey<FormState>();

  SecondPage({Key key, @required this.value}) : super(key: key) {}

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
            }),
        new Form(
          key: _formKey,
          child: new TextFormField(
            controller: _controller,
            decoration: new InputDecoration(labelText: 'Send a message'),
          ),
        ),
      ])),
    );
  }
}
