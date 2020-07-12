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
  bool _isLoading = false;
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
      setState(() {
        _isLoading = true;
      });
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
        ).then((_) => {_isLoading = false});
      } else {
        showDialog(
          context: context,
          builder: (context) => showDialogITEM("Wrong Credentials", context),
        );
        print("Wrong Credentials");
      }
    }).then((_) {
      setState(() {
        _isLoading = false;
      });
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
                style: TextStyle(
                  fontSize: 20,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(8),
                  hintText: "Enter username",
                  hintStyle: TextStyle(fontSize: 20),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                ),
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
                decoration: simpleInputDecoration(),
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
                  child: _isLoading
                      ? CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        )
                      : Text(
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
                    child: RichText(
                        text: TextSpan(
                            text: "Dont have an Account ",
                            style: TextStyle(fontSize: 15, color: Colors.black),
                            children: [
                      TextSpan(
                          text: "Register Now!",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontStyle: FontStyle.italic)),
                    ]))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
