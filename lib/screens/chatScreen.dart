import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:instaAP/dataprovider/socketcodepro.dart';

import 'package:instaAP/widgets/simplewidgets.dart';

import '../utility/utils.dart';

class ChatScreen extends StatefulWidget {
  final String friend;
  ChatScreen(this.friend);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _messageController = new TextEditingController();
  SocketItem _socketItem = new SocketItem();
  SocketIO socketIO;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    this.socketIO = Utils.getSocketIO((data) {
      debugPrint(data.toString());
    });
    socketIO.subscribe("receiveMessage", (data) {
        print(data);
    });

    return Scaffold(
      appBar: buildAppBar(widget.friend),
      body: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(42, 122, 247, 1),
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(30))),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                          hintText: "Message....",
                          hintStyle: TextStyle(
                            color: Colors.white54,
                            fontSize: 20,
                          ),
                          border: InputBorder.none),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      this.socketIO.sendMessage("getMessage", jsonEncode({
                        'message':_messageController.text
                      }));
                      _messageController.clear();
                    },
                    child: Container(
                        height: 40,
                        alignment: Alignment.center,
                        width: 40,
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(5, 28, 64, 1),
                            borderRadius: BorderRadius.circular(40)),
                        padding: EdgeInsets.all(12),
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                        )),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
