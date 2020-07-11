import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:instaAP/utility/utils.dart';
import 'dart:convert';

class SocketItem {
  SocketIO _socketioChat;
  SocketIO connectSocketIO() {
    SocketIO _socketIO;
    _socketIO = SocketIOManager().createSocketIO(Utils.url, "/connect");
    _socketIO.init();
    _socketIO.connect();
    _socketioChat = _socketIO;
    return _socketIO;
  }

  Future subscribetomessge() async {
    connectSocketIO().subscribe("message", _socketChatcall);
  }

  sendmessageItem(String message) async {
    this._socketioChat.sendMessage(
        "message",
        json.encode(
          {'message': message},
        ),
        _socketChatcall);
  }

  _socketChatcall(data) {
    print(json.decode(data));
  }
}
