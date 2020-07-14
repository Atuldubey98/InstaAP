import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:instaAP/chatprovider/createchat.dart';

import 'package:instaAP/dataprovider/authenticateME.dart';
import 'package:instaAP/models/userData.dart';

import 'package:instaAP/screens/friendsItem.dart';
import 'package:instaAP/screens/loginscreen.dart';
import 'package:instaAP/utility/utils.dart';

class ChatRooms extends StatefulWidget {
  final Function addtoList;
  ChatRooms({this.addtoList});
  @override
  _ChatRoomsState createState() => _ChatRoomsState();
}

class _ChatRoomsState extends State<ChatRooms> {
  AuthenticateME _authenticateME = new AuthenticateME();
  CreateChat _createChat = new CreateChat();
  List<String> _list = [];

  Future getChat() async {
    final response = await http.get(Utils.url + Utils.clients);
    final jsondata = json.decode(response.body);

    jsondata['data'].forEach((element) {
      if (element['chatid'].contains(Useritemdata.username + "_")) {
        final item =
            element['chatid'].replaceAll(Useritemdata.username + "_", "");
        _list.add(item);
      } else if (element['chatid'].contains("_" + Useritemdata.username)) {
        final item =
            element['chatid'].replaceAll("_" + Useritemdata.username, "");
        _list.add(item);
      }
    });
    return _list;
  }

  Stream<List<String>> get getChatlist async* {
    yield await getChat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Color.fromRGBO(41, 128, 185, 1),
        title: Text(
          'Your Friends',
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
              tooltip: "Log Out",
              icon: Icon(
                Icons.all_out,
                color: Colors.white,
              ),
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
      body: Container(
        child: StreamBuilder<List<String>>(
            stream: getChatlist,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        onTap: () {
                          _createChat.createItem(snapshot.data[index], context);
                        },
                        leading: CircleAvatar(
                          backgroundImage:
                              ExactAssetImage("assets/images/images.png"),
                        ),
                        title: Text(
                          snapshot.data[index],
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    );
                  },
                  itemCount: snapshot.data.length,
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Text(
                    "Loading....",
                    style: TextStyle(color: Colors.black),
                  ),
                );
              }
              return Center(
                child: Text("No Chat"),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(41, 128, 185, 1),
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
