import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:instaAP/models/messageitem.dart';
import 'package:instaAP/models/userData.dart';

import 'package:instaAP/widgets/simplewidgets.dart';

import '../utility/utils.dart';

class ChatScreen extends StatefulWidget {
  final String friend;
  final String chatid;
  ChatScreen(this.friend, this.chatid);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ScrollController _scrollController;
  TextEditingController _messageController = new TextEditingController();
  Stream _stream;
  final StreamController _streamController = new StreamController();
  SocketIO socketIO;
  List<Message> _list = List<Message>();
  Future getChatlist(String chatidentity) async {
    final response =
        await http.get(Utils.url + Utils.chatlistitem + chatidentity);
    final jsonData = json.decode(response.body);
    print(jsonData);
    jsonData['data']['message'].forEach((element) {
      final Message _message = new Message(
          message: element['mess'],
          sentBy: element['sentby'] == Useritemdata.username);
      _list.add(_message);
      _streamController.add(_list);
    });
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _stream = _streamController.stream;
    getChatlist(widget.chatid);

    super.initState();
  }

  @override
  void dispose() {
    socketIO.unSubscribesAll();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    this.socketIO = Utils.getSocketIO((data) {
      debugPrint(data.toString());
    });
    socketIO.subscribe("${widget.chatid}", (data) {
      final Message _message = Message(
          message: json.decode(data)['message'],
          sentBy: json.decode(data)['sentbyme']);
      _list.add(_message);
      _streamController.add(_list);
    });
    Widget chatMessageList() {
      return Container(
        padding: EdgeInsets.only(left: 8, right: 8),
        child: StreamBuilder(
            builder: (context, dataSnap) {
              if (dataSnap.hasData) {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    print(dataSnap.data[index].sentBy);
                    return MessageList(
                      message: dataSnap.data[index].message,
                      isSentByMe: dataSnap.data[index].sentBy,
                    );
                  },
                  itemCount: _list.length,
                );
              }
              return Center(
                child: Text("This message is end to end encrypted"),
              );
            },
            stream: _stream),
      );
    }

    return Scaffold(
      appBar: buildAppBar(widget.friend),
      body: Stack(
        children: <Widget>[
          chatMessageList(),
          Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(41, 128, 185, 1),
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(30))),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: TextStyle(color: Colors.white),
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
                      this.socketIO.sendMessage(
                          "getMessage",
                          jsonEncode({
                            'message': _messageController.text,
                            "sentbyme": true,
                            "chatid": widget.chatid,
                            "sentby": Useritemdata.username
                          }));
                      _messageController.clear();
                      _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: Duration(milliseconds: 600),
                          curve: Curves.ease);
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

class MessageList extends StatelessWidget {
  final String message;
  final bool isSentByMe;
  MessageList({this.message, this.isSentByMe});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width,
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: isSentByMe
                  ? BorderRadius.only(
                      topLeft: Radius.circular(23),
                      topRight: Radius.circular(23),
                      bottomLeft: Radius.circular(23))
                  : BorderRadius.only(
                      topLeft: Radius.circular(23),
                      topRight: Radius.circular(23),
                      bottomRight: Radius.circular(23)),
              color: isSentByMe
                  ? Color.fromRGBO(41, 128, 185, 1)
                  : Color.fromRGBO(84, 196, 227, 1)),
          child: Text(
            message,
            style: TextStyle(fontSize: 18),
          )),
    );
  }
}
