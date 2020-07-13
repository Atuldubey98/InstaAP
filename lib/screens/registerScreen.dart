import 'package:flutter/material.dart';

import 'package:instaAP/dataprovider/authenticateME.dart';
import 'package:instaAP/screens/loginscreen.dart';
import 'package:instaAP/widgets/simplewidgets.dart';
import 'package:flutter/animation.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final formkey = GlobalKey<FormState>();
  AuthenticateME _authenticateME = new AuthenticateME();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passController = new TextEditingController();
  Animation animation;
  AnimationController _animationController;
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
  void initState() {
    _animationController =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    animation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn));
    _animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) => Scaffold(
        appBar: buildAppBar("Register Screen"),
        body: Transform(
          transform:
              Matrix4.translationValues(animation.value * width, 0.0, 0.0),
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Form(
                key: formkey,
                child: Column(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset("assets/images/images.png"),
                    ),
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
                    SizedBox(
                      height: 10,
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
                        padding: EdgeInsets.all(8),
                        child: Container(
                          width: 180,
                          padding: EdgeInsets.all(8),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Login Screen',
                            style: TextStyle(fontSize: 25, color: Colors.black),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
