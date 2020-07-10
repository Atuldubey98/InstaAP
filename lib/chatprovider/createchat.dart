import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:instaAP/utility/utils.dart';

class CreateChat {
  Future createChatID(String chatid) async {
    final response = await http.post(
      Utils.url + Utils.chatiditem,
      headers: Utils.map,
      body: json.encode(
        {"chatid": chatid},
      ),
    );
    final jsondata = json.decode(response.body);
    print(jsondata);
  }
}
