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
  bool isAuthenticated = false;
  @override
  void initState() {
    checkStatus();
    super.initState();
  }

  checkStatus() async {
    final prefs = await SharedPreferences.getInstance();
    print(prefs.getBool("auth"));

    if (prefs.getBool("auth") == null ||
        prefs.getBool("auth") == false ||
        prefs.getString("user") == null) {
      isAuthenticated = true;
    } else {
      isAuthenticated = false;
      Useritemdata.username = prefs.getString("user");
      Useritemdata.isauth = prefs.getBool("auth");
      print(Useritemdata.username);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primaryColor: Colors.white,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: isAuthenticated == false ? ChatRooms() : AuthenticateScreen(),
    );
  }
}
