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
  bool _isloading = false;

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
      setState(() {
        _isloading = true;
      });
      if (value == true) {
        Useritemdata.isauth = value;
        prefs.setString("user", username);
        prefs.setBool("auth", value);
        Useritemdata.username = username;
        print("User Logged in");

        await Navigator.pushReplacement(
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

        setState(() {
          _isloading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    usernameController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar("Login Screen"),
      body: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(41, 128, 185, 0.2),
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Form(
              key: formkey,
              child: Column(
                children: [
                  Column(
                    children: <Widget>[
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(60)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Image.asset("assets/images/images.png"),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 20,
                              ),
                              _UsernameEntry(
                                  usernameController: usernameController),
                              SizedBox(
                                height: 10,
                              ),
                              _PasswordEntry(passController: passController),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      _isloading
                          ? Center(child: CircularProgressIndicator())
                          : GestureDetector(
                              onTap: () async {
                                await logintoServer(usernameController.text,
                                    passController.text);
                              },
                              child: Container(
                                padding: EdgeInsets.all(8),
                                alignment: Alignment.center,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(41, 128, 185, 1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text('Login', style: simpletextStyle()),
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
                          padding: EdgeInsets.all(8),
                          alignment: Alignment.center,
                          width: 250,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(41, 128, 185, 1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child:
                              Text('Register Screen', style: simpletextStyle()),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PasswordEntry extends StatelessWidget {
  const _PasswordEntry({
    Key key,
    @required this.passController,
  }) : super(key: key);

  final TextEditingController passController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: true,
      validator: (value) {
        return value.length > 6
            ? null
            : "Please Provide passowrd greater than 6 character";
      },
      controller: passController,
      decoration: simpleInputDecoration("Enter password"),
    );
  }
}

class _UsernameEntry extends StatelessWidget {
  const _UsernameEntry({
    Key key,
    @required this.usernameController,
  }) : super(key: key);

  final TextEditingController usernameController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: usernameController,
      style: TextStyle(
        fontSize: 20,
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(8),
        hintText: "Enter username",
        hintStyle: TextStyle(fontSize: 20),
        focusedBorder: getBorder(),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
      ),
    );
  }
}
