import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:instaAP/models/userData.dart';
import 'package:instaAP/utility/utils.dart';

class UserListProvider {
  List<String> _users = [];
  // ignore: close_sinks
  final StreamController streamController = new StreamController.broadcast();
  Stream stream;
  Future getListItem() async {
    final response = await http.get(Utils.url + Utils.userlist);
    final jsonData = json.decode(response.body);
    print(jsonData);
    jsonData["data"].forEach((element) {
      if (element['user'] != Useritemdata.username) {
        _users.add(element['user']);
      }
    });

    return _users;
  }

  List<String> list = [];

  Future getChat() async {
    final response = await http.get(Utils.url + Utils.clients);
    final jsondata = json.decode(response.body);

    jsondata['data'].forEach((element) {
      if (element['chatid'].contains(Useritemdata.username + "_")) {
        final item =
            element['chatid'].replaceAll(Useritemdata.username + "_", "");
        list.add(item);
      } else if (element['chatid'].contains("_" + Useritemdata.username)) {
        final item =
            element['chatid'].replaceAll("_" + Useritemdata.username, "");
        list.add(item);
      }
    });
    return list;
  }
}
