import 'package:flutter/material.dart';

AppBar buildAppBar(String heading) {
  return AppBar(
    title: Text(
      heading,
      style: simpletextStyle(),
    ),
    backgroundColor: Color.fromRGBO(41, 128, 185, 1),
  );
}

AlertDialog showDialogITEM(String item, BuildContext context) {
  return AlertDialog(
    contentPadding: EdgeInsets.all(8),
    title: Text("Alert !"),
    content: Text(item),
    elevation: 10,
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

TextStyle simpletextStyle() {
  return TextStyle(color: Colors.white, fontSize: 25);
}

InputDecoration simpleInputDecoration() {
  return InputDecoration(
    contentPadding: EdgeInsets.all(8),
    hintText: "Enter username",
    hintStyle: TextStyle(fontSize: 20),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(20),
      ),
    ),
  );
}
