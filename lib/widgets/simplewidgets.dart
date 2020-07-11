import 'package:flutter/material.dart';

AppBar buildAppBar(String heading) {
  return AppBar(title: Text(heading));
}

AlertDialog showDialogITEM(String item, BuildContext context) {
  return AlertDialog(
    content: Text(item),
    actions: <Widget>[
      RaisedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text("OK"),
      )
    ],
  );
}
