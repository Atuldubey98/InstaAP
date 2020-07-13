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

    if (prefs.getBool("auth") == null || prefs.getBool("auth") == false || prefs.getString("user") == null) {
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
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(elevation: 10),
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
