import 'package:flutter/material.dart';

import 'package:instaAP/screens/friendsItem.dart';
import 'package:instaAP/widgets/simplewidgets.dart';

class ChatRooms extends StatefulWidget {
  @override
  _ChatRoomsState createState() => _ChatRoomsState();
}

class _ChatRoomsState extends State<ChatRooms> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar("Your Chat Rooms"),
      body: Container(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatFriendsList(),
            ),
          );
        },
        child: Icon(Icons.message),
      ),
    );
  }
}
