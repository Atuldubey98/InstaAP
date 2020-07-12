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
    _userListProvider
        .getListItem()
        .then((value) => streamController.add(value));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar("Friend List"),
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
                  onTap: () {
                    _createChat.createItem(snapshot.data[index], context);
                  },
                  title: Text(snapshot.data[index]),
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
