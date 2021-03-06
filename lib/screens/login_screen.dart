import 'package:call_me/resources/firebase_repository.dart';
import 'package:call_me/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:call_me/resources/firebase_repository.dart';
import 'package:shimmer/shimmer.dart';
import 'package:call_me/utils/universal_variables.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseRepository _repository = FirebaseRepository();
  bool isLoginPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      body: Stack(
        children: [
          Center(
            child: loginButton(),
          ),
          isLoginPressed
              ? Center(child: CircularProgressIndicator())
              : Container()
        ],
      ),
    );
  }

  Widget loginButton() {
    return Shimmer.fromColors(
      baseColor: Colors.white,
      highlightColor: UniversalVariables.senderColor,
      child: FlatButton(
        padding: EdgeInsets.all(35),
        child: Text(
          "LOGIN",
          style: TextStyle(
            fontSize: 35.0,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
        onPressed: () => performLogin(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void performLogin() {
    setState(() {
      isLoginPressed = true;
    });

    _repository.signIn().then((User user) {
      if (user != null) {
        authenticateUser(user);
      } else {
        print('An error has occured');
      }
    });
  }

  void authenticateUser(User user) {
    _repository.authenticateUser(user).then((isNewUser) {
      setState(() {
        isLoginPressed = false;
      });

      if (isNewUser) {
        _repository.addDataToDB(user).then((value) {
          print("job done");
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return HomeScreen();
          }));
        });
      } else {
        print("job Done");
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return HomeScreen();
        }));
      }
    });
  }
}
