import 'package:flutter/material.dart';

AppBar buildAppBar(String heading) {
  return AppBar(title: Text(heading));
}

AlertDialog showDialogITEM(String item) {
  return AlertDialog(
    content: Text(item),
  );
}
