import 'package:flutter/material.dart';
import 'package:instaAP/chatprovider/createchat.dart';

AppBar buildAppBar(String heading) {
  return AppBar(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
    ),
    elevation: 0,
    centerTitle: true,
    title: Text(
      heading,
      style: simpletextStyle(),
    ),
    backgroundColor: Color.fromRGBO(41, 128, 185, 1),
  );
}

AlertDialog showDialogITEM(String item, BuildContext context) {
  return AlertDialog(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    titlePadding: EdgeInsets.all(20),
    contentPadding: EdgeInsets.all(20),
    title: Text("Alert !"),
    content: Text(item),
    elevation: 10,
    actions: <Widget>[
      RaisedButton(
        elevation: 0,
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text("OK"),
      )
    ],
  );
}

TextStyle simpletextStyle() {
  return TextStyle(color: Colors.white, fontSize: 25);
}

TextStyle notSosimpletextStyle() {
  return TextStyle(
    color: Colors.black,
    fontSize: 25,
    fontWeight: FontWeight.bold,
  );
}

InputDecoration simpleInputDecoration(String item) {
  return InputDecoration(
    contentPadding: EdgeInsets.all(8),
    hintText: item,
    hintStyle: TextStyle(fontSize: 20),
    focusedBorder: getBorder(),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(20),
      ),
    ),
  );
}

OutlineInputBorder getBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(20),
    ),
  );
}

class FriendSearch extends SearchDelegate {
  final List<String> friends;
  FriendSearch(this.friends);
  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed: () {})];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListTile();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    CreateChat _createChat = new CreateChat();
    final myList = query.isEmpty
        ? friends
        : friends.where((element) => element.contains(query)).toList();
    return ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              _createChat.createItem(myList[index], context);
            },
            title: Text(
              myList[index],
            ),
          );
        },
        itemCount: myList.length);
  }
}
