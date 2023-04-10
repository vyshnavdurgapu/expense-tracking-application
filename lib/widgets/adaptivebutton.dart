import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

class adaptiveflatbutton extends StatelessWidget {
  @override
  final String text;
  final Function handler;

  adaptiveflatbutton(this.text, this.handler);

  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            child: Text(
              text,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: handler,
          )
        : FlatButton(
            onPressed: handler,
            child: Text(
              text,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            textColor: Theme.of(context).primaryColor,
          );
  }
}
