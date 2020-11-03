import 'dart:convert';

import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:instaAP/models/userData.dart';

class Utils {
  static String url = "http://instant-chat-app-101.herokuapp.com";
  static String login = "/login";
  static String register = "/register";
  static String userlist = "/userlist";
  static String chatiditem = "/createchatID";
  static Map<String, String> map = {"Content-type": "application/json"};
  static String chatlistitem = "/getchatlist/";
  static String clients = "/clients";

  SocketIO socketIO;
  SocketIO getSocketIO(Function socketStatus) {
    if (socketIO == null) {
      socketIO = SocketIOManager()
          .createSocketIO(url, '/', socketStatusCallback: socketStatus);
      socketIO.init();
      socketIO.connect();
      return socketIO;
    }
    return socketIO;
  }

  sendSocketMessageforlist() {
    socketIO.sendMessage(
        "listGet", jsonEncode({"data": Useritemdata.username}));
  }
}

Utils utils = Utils();
