import 'dart:async';

import 'package:flutter/material.dart';
import 'package:instaAP/chatprovider/createchat.dart';

import 'package:instaAP/dataprovider/userlistprovider.dart';

import 'package:instaAP/widgets/simplewidgets.dart';

class ChatFriendsList extends StatefulWidget {
  @override
  _ChatFriendsListState createState() => _ChatFriendsListState();
}

class _ChatFriendsListState extends State<ChatFriendsList> {
  final StreamController streamController = new StreamController();
  Stream stream;
  CreateChat _createChat = new CreateChat();

  UserListProvider _userListProvider = new UserListProvider();

  String chatid;

  @override
  void initState() {
    stream = streamController.stream;
    _userListProvider.getListItem().then((value) {
      streamController.add(value);
      _createChat.list = value;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Users",
          style: simpletextStyle(),
        ),
        backgroundColor: Color.fromRGBO(41, 128, 185, 1),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: FriendSearch(_createChat.list),
                );
              }),
        ],
      ),
      body: StreamBuilder(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            return ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        ExactAssetImage("assets/images/images.png"),
                  ),
                  contentPadding: EdgeInsets.all(3),
                  onTap: () {
                    _createChat.createItem(snapshot.data[index], context);
                  },
                  title: Text(
                    snapshot.data[index],
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                );
              },
              itemCount: snapshot.data.length,
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
