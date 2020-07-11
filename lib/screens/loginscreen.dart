import 'package:flutter/material.dart';
import 'package:instaAP/dataprovider/authenticateME.dart';
import 'package:instaAP/models/userData.dart';
import 'package:instaAP/screens/chatrooms.dart';
import 'package:instaAP/screens/registerScreen.dart';
import 'package:instaAP/widgets/simplewidgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticateScreen extends StatefulWidget {
  @override
  _AuthenticateScreenState createState() => _AuthenticateScreenState();
}

class _AuthenticateScreenState extends State<AuthenticateScreen> {
  final formkey = GlobalKey<FormState>();
  AuthenticateME _authenticateME = new AuthenticateME();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passController = new TextEditingController();

  @override
  void initState() {
    _authenticateME.checkServerConnection().then((value) {
      if (value == "connected") {
        print(value);
        return "";
      }
      if (value == "notconnected") {
        print(value);
        return showDialog(
            context: context,
            builder: (context) => showDialogITEM(value, context));
      }

      return value;
    });

    super.initState();
  }

  logintoServer(String username, String password) {
    _authenticateME.loginME(username, password).then((value) async {
      final prefs = await SharedPreferences.getInstance();
      if (value == true) {
        Useritemdata.isauth = value;
        prefs.setString("user", username);
        prefs.setBool("auth", value);
        Useritemdata.username = username;
        print("User Logged in");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChatRooms(),
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => showDialogITEM("Wrong Credentials", context),
        );
        print("Wrong Credentials");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar("Login Screen"),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Form(
          key: formkey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: usernameController,
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                validator: (value) {
                  return value.length > 6
                      ? null
                      : "Please Provide passowrd greater than 6 character";
                },
                controller: passController,
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  logintoServer(usernameController.text, passController.text);
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  alignment: Alignment.center,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RegisterScreen(),
                    ),
                  );
                },
                child: Container(
                  child: Text("Register Now"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
