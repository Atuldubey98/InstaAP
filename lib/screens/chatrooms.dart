import 'package:flutter/material.dart';
import 'package:instaAP/chatprovider/createchat.dart';

import 'package:instaAP/dataprovider/authenticateME.dart';
import 'package:instaAP/dataprovider/userlistprovider.dart';
import 'package:instaAP/models/userData.dart';

import 'package:instaAP/screens/friendsItem.dart';
import 'package:instaAP/screens/loginscreen.dart';
import 'package:instaAP/utility/utils.dart';
import 'package:instaAP/widgets/simplewidgets.dart';

class ChatRooms extends StatefulWidget {
  final Function addtoList;
  ChatRooms({this.addtoList});
  @override
  _ChatRoomsState createState() => _ChatRoomsState();
}

class _ChatRoomsState extends State<ChatRooms> {
  AuthenticateME _authenticateME = new AuthenticateME();
  CreateChat _createChat = new CreateChat();
  int count = 0;
  UserListProvider _userListProvider = new UserListProvider();
  @override
  void initState() {
    _userListProvider.stream = _userListProvider.streamController.stream;
    getChatList();
    socketListStatus();

    super.initState();
  }

  socketListStatus() {
    utils.getSocketIO((data) {
      print(data);
    });
    if (utils.socketIO != null) {
      utils.socketIO.subscribe(Useritemdata.username, (data) {
        getChatList();
      });
    }
  }

  getChatList() async {
    await _userListProvider.getChat().then((value) {
      _createChat.list = value;
      print(_createChat.list);
      _userListProvider.streamController.add(value);
    });

    _userListProvider.list = [];
  }

  @override
  void dispose() {
    _userListProvider.streamController.close();
    utils.socketIO.unSubscribe(Useritemdata.username);
    super.dispose();
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
        backgroundColor: Color.fromRGBO(41, 128, 185, 1),
        title: Text(
          'Your Friends',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
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
          _LogoutButton(authenticateME: _authenticateME),
        ],
      ),
      body: Container(
        child: RefreshIndicator(
          color: Color.fromRGBO(41, 128, 185, 1),
          onRefresh: () async {
            await getChatList();
          },
          child: StreamBuilder(
              stream: _userListProvider.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  count = snapshot.data.length;
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          onTap: () {
                            _createChat.createItem(
                                snapshot.data[index], context);
                          },
                          trailing: Text(
                            snapshot.data[index][0],
                            style: notSosimpletextStyle(),
                          ),
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
                  return LoadingScreen();
                }
                return _NoChat();
              }),
        ),
      ),
      floatingActionButton: _FloatingActionsWidgets(),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({
    Key key,
    @required AuthenticateME authenticateME,
  })  : _authenticateME = authenticateME,
        super(key: key);

  final AuthenticateME _authenticateME;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        tooltip: "Log Out",
        icon: Icon(
          Icons.exit_to_app,
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
        });
  }
}

class _NoChat extends StatelessWidget {
  const _NoChat({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("No Chat"),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: LinearProgressIndicator(
      backgroundColor: Color.fromRGBO(41, 128, 185, 1),
    ));
  }
}

class _FloatingActionsWidgets extends StatelessWidget {
  const _FloatingActionsWidgets({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Color.fromRGBO(41, 128, 185, 1),
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatFriendsList(),
          ),
        );
      },
      child: Icon(Icons.message),
    );
  }
}
