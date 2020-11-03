import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:instaAP/models/messageitem.dart';
import 'package:instaAP/models/userData.dart';

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
  final StreamController _streamController = new StreamController.broadcast();

  List<Message> _list = List<Message>();

  subscribetochatId() async {
    utils.socketIO.subscribe("${widget.chatid}", (data) {
      final Message _message = Message(
          message: json.decode(data)['message'],
          sentBy: json.decode(data)['sentby']);
      _list.add(_message);

      Future.delayed(Duration(
        milliseconds: 500,
      )).then((value) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            curve: Curves.easeIn, duration: Duration(milliseconds: 100));
      });
      _streamController.add(_list);
    });
  }

  @override
  void initState() {
    subscribetochatId();
    _scrollController = ScrollController();
    getChatbychatid();
    _stream = _streamController.stream;

    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    utils.socketIO.unSubscribe("${widget.chatid}");
    _streamController.close();
    super.dispose();
  }

  Future getChatbychatid() async {
    final response =
        await http.get(Utils.url + Utils.chatlistitem + widget.chatid);
    final jsonData = json.decode(response.body);

    jsonData['data']['message'].forEach((element) {
      final _message =
          Message(message: element['mess'], sentBy: element['sentby']);
      _list.add(_message);
    });
    Future.delayed(Duration(
      milliseconds: 500,
    )).then((value) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          curve: Curves.easeIn, duration: Duration(milliseconds: 100));
    });
    _streamController.add(_list);
  }

  @override
  Widget build(BuildContext context) {
    Widget chatMessageList() {
      return Flexible(
        child: Container(
          padding: EdgeInsets.only(left: 8, right: 8),
          child: StreamBuilder(
              builder: (context, dataSnap) {
                if (dataSnap.hasError) {
                  return Center(
                    child: Text("Server Down"),
                  );
                }
                if (dataSnap.data == null) {
                  return Center(
                    child: Text(
                      "This message is end to end encrypted",
                    ),
                  );
                }
                if (dataSnap.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    controller: _scrollController,
                    itemBuilder: (context, index) {
                      return MessageList(
                        message: dataSnap.data[index].message,
                        isSentByMe: dataSnap.data[index].sentBy ==
                            Useritemdata.username,
                      );
                    },
                    itemCount: _list.length,
                  );
                }
                return Center(
                  child: Text(
                    "This message is end to end encrypted",
                  ),
                );
              },
              stream: _stream),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          widget.friend,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          chatMessageList(),
          Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 3),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(41, 128, 185, 1),
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20))),
              child: _MessageWidget(
                  messageController: _messageController,
                  socketIO: utils.socketIO,
                  widget: widget,
                  scrollController: _scrollController),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageWidget extends StatelessWidget {
  const _MessageWidget({
    Key key,
    @required TextEditingController messageController,
    @required this.socketIO,
    @required this.widget,
    @required ScrollController scrollController,
  })  : _messageController = messageController,
        _scrollController = scrollController,
        super(key: key);

  final TextEditingController _messageController;
  final SocketIO socketIO;
  final ChatScreen widget;
  final ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            style: TextStyle(color: Colors.white, fontSize: 20),
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
            if (utils.socketIO != null) {
              utils.socketIO.sendMessage(
                  "getMessage",
                  jsonEncode({
                    'message': _messageController.text,
                    "sentbyme": true,
                    "chatid": widget.chatid,
                    "sentby": Useritemdata.username
                  }));
              Future.delayed(Duration(
                milliseconds: 500,
              )).then((value) {
                _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    curve: Curves.bounceIn,
                    duration: Duration(milliseconds: 100));
              });
              _messageController.clear();
            }
          },
          child: Icon(
            Icons.send,
            size: 30,
            color: Colors.white,
          ),
        )
      ],
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
            style: TextStyle(fontSize: 18, color: Colors.white),
          )),
    );
  }
}
