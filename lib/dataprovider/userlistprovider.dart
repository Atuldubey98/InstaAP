import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:instaAP/utility/utils.dart';

class UserListProvider {
  List<String> _users = [];
  Future getListItem() async {
    final response = await http.get(Utils.url + Utils.userlist);
    final jsonData = json.decode(response.body);
    print(jsonData);
    jsonData["data"].forEach((element) {
      _users.add(element['user']);
    });
    print(_users);
    return _users;
  }
}
