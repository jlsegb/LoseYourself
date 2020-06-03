import 'package:flutter/material.dart';
import 'package:just_serve/app/sign_in/social_sign_in_button.dart';
import 'package:just_serve/services/auth.dart';

const int FACEBOOK_COLOR = 0xFF334D92;

class SignInPage extends StatelessWidget {
  SignInPage({
    @required this.auth,
  });

  final AuthBase auth;

  Future<void> _signInAnonymously() async {
    try {
      await auth.signInAnonymously();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      await auth.signInWithGoogle();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lose Yourself"),
        centerTitle: true,
        elevation: 2.0,
      ),
      body: _buildContent(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            "Sign in",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 36.0,
          ),
          SignInButton(
            color: Colors.white,
            onPressed: _signInWithGoogle,
            text: "Sign in with Google",
            textColor: Colors.black87,
            assetName: 'images/google-logo.png',
          ),
          SizedBox(
            height: 16.0,
          ),
          SignInButton(
            color: Color(FACEBOOK_COLOR),
            onPressed: _signInAnonymously,
            text: "Sign in with Facebook",
            textColor: Colors.white,
            assetName: 'images/facebook-logo.png',
          ),
        ],
      ),
    );
  }
}
