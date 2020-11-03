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
  void dispose() {
    usernameController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) => Scaffold(
        appBar: buildAppBar("Register Screen"),
        body: Transform(
          transform:
              Matrix4.translationValues(animation.value * width, 0.0, 0.0),
          child: SingleChildScrollView(
            child: Container(
              color: Color.fromRGBO(41, 128, 185, 0.2),
              height: height,
              padding: EdgeInsets.all(20),
              child: Form(
                key: formkey,
                child: Column(
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
                      height: 10,
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              decoration: simpleInputDecoration("Username"),
                              controller: usernameController,
                              validator: (value) {
                                return RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(value)
                                    ? null
                                    : "Please Enter Correct Email";
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            _PasswordWidget(passController: passController),
                          ],
                        ),
                      ),
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
                          color: Color.fromRGBO(41, 128, 185, 1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text('Register', style: simpletextStyle()),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _LoginScreenButton()
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

class _LoginScreenButton extends StatelessWidget {
  const _LoginScreenButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
            color: Color.fromRGBO(41, 128, 185, 1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text('Login Screen', style: simpletextStyle()),
        ),
      ),
    );
  }
}

class _PasswordWidget extends StatelessWidget {
  const _PasswordWidget({
    Key key,
    @required this.passController,
  }) : super(key: key);

  final TextEditingController passController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: simpleInputDecoration("Password"),
      validator: (value) {
        return value.length > 6
            ? null
            : "Please Provide passowrd greater than 6 character";
      },
      controller: passController,
    );
  }
}
