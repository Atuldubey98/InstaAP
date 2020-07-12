import 'package:flutter/material.dart';

import 'package:instaAP/dataprovider/authenticateME.dart';
import 'package:instaAP/screens/loginscreen.dart';
import 'package:instaAP/widgets/simplewidgets.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formkey = GlobalKey<FormState>();
  AuthenticateME _authenticateME = new AuthenticateME();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passController = new TextEditingController();

  registerMySelf() {
    if (formkey.currentState.validate()) {
      _authenticateME
          .registerME(usernameController.text, passController.text)
          .then((value) {
        if (value == "OK") {
          showDialog(
              context: context,
              builder: (context) =>
                  showDialogITEM("User Created Login to continue", context));
        } else {
          showDialog(
              context: context,
              builder: (context) =>
                  showDialogITEM("Something is Wrong Try Again", context));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar("Register Screen"),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Form(
          key: formkey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: simpleInputDecoration(),
                controller: usernameController,
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: simpleInputDecoration(),
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
                  registerMySelf();
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
                    'Register',
                    style: TextStyle(fontSize: 25, color: Colors.black),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AuthenticateScreen(),
                    ),
                  );
                },
                child: Container(
                  child: Text(
                    "Have An Account Register",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
