import 'package:flutter/material.dart';
import 'package:instaAP/models/userData.dart';
import 'package:instaAP/screens/chatrooms.dart';
import 'package:instaAP/screens/loginscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future checkStatus() async {
    final prefs = await SharedPreferences.getInstance();
    print(prefs.getBool("auth"));

    if (prefs.getBool("auth") == null ||
        prefs.getBool("auth") == false ||
        prefs.getString("user") == null) {
      return false;
    } else {
      Useritemdata.username = prefs.getString("user");
      Useritemdata.isauth = prefs.getBool("auth");
      print(Useritemdata.username);
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatAPP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(elevation: 0),
        primaryColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder(
        builder: (context, datasnap) {
          if (datasnap.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Container(
                child: Column(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset("assets/images/images.png"),
                    ),
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                ),
              ),
            );
          } else if (datasnap.data == true) {
            return ChatRooms();
          }
          return AuthenticateScreen();
        },
        future: checkStatus(),
      ),
    );
  }
}
