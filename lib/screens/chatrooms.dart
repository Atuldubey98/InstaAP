import 'package:flutter/material.dart';
import 'package:instaAP/dataprovider/authenticateME.dart';

import 'package:instaAP/screens/friendsItem.dart';
import 'package:instaAP/screens/loginscreen.dart';

class ChatRooms extends StatefulWidget {
  @override
  _ChatRoomsState createState() => _ChatRoomsState();
}

class _ChatRoomsState extends State<ChatRooms> {
  AuthenticateME _authenticateME = new AuthenticateME();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Chat Rooms'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.all_out),
              onPressed: () {
                _authenticateME.logout().then((_) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AuthenticateScreen(),
                      ),
                      (route) => false);
                });
              })
        ],
      ),
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
