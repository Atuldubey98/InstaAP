import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:instaAP/utility/utils.dart';

class AuthenticateME {
  Future<String> checkServerConnection() async {
    final response = await http.get(Utils.url);
    if (response.statusCode > 200) {
      return "notconnected";
    } else {
      return "connected";
    }
  }

  Future<bool> loginME(String username, String password) async {
    final response = await http.post(Utils.url + Utils.login,
        body: json.encode(
          {"user": username, "password": password},
        ),
        headers: Utils.map);
    final jsonData = json.decode(response.body);

    print(jsonData['status']);
    return jsonData['status'] == "ok" ? true : false;
  }

  Future<void> registerME(String username, String password) async {
    final response = await http.post(Utils.url + Utils.register,
        body: json.encode(
          {"user": username, "password": password},
        ),
        headers: Utils.map);
    final jsonData = response.body;
    print(jsonData);
  }
}
