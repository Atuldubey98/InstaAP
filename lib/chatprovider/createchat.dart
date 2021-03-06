import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:instaAP/models/userData.dart';
import 'package:instaAP/screens/chatScreen.dart';
import 'package:instaAP/utility/utils.dart';

class CreateChat {
  String chatid;
  List<String> list = List<String>();
  Future createChatID(String chatid) async {
    final response = await http.post(
      Utils.url + Utils.chatiditem,
      headers: Utils.map,
      body: json.encode(
        {"chatid": chatid},
      ),
    );
    final jsondata = json.decode(response.body);

    return jsondata['mess'];
  }

  Future createItem(String friend, BuildContext context) async {
    chatid = getChatRooms(Useritemdata.username, friend);

    createChatID(chatid).then((value) async {
      print(value);
      if (value != "old") {
        utils.sendSocketMessageforlist();
      }
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (conetext) => ChatScreen(friend, chatid),
        ),
      );
    });
  }

  getChatRooms(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }
}
