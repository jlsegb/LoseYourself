import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:just_serve/app/sign_in/sign_in_page.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  void _updateUser(FirebaseUser user){
    setState(() {
      _user = user;
    });
  }
  FirebaseUser _user;
  @override
  Widget build(BuildContext context) {
    if(_user == null) {
      return SignInPage(onSignIn: _updateUser,);
    }
    return Container();//this should be the homepage
  }
}