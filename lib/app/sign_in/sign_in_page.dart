import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_serve/app/sign_in/email_sign_in_page.dart';
import 'package:just_serve/app/sign_in/sign_in_button.dart';
import 'package:just_serve/app/sign_in/social_sign_in_button.dart';
import 'package:just_serve/custom_widgets/firebase_platform_exception_alert_dialog.dart';
import 'package:just_serve/services/auth.dart';
import 'package:provider/provider.dart';

const int FACEBOOK_COLOR = 0xFF334D92;

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  var _isLoading = false;

  Future<void> _signInWithGoogle(BuildContext context) async {
    setState(() => _isLoading = true);
    final auth = Provider.of<AuthBase>(context, listen: false);
    try {
      await auth.signInWithGoogle();
    } on PlatformException catch (e) {
      FirebasePlatformExceptionAlertDialog(
        actionText: 'OK',
        title: 'Sign in failed',
        exception: e,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute<void>(
      fullscreenDialog: true, //adds an x instead of an <
      builder: (context) => EmailSignInPage(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lose Yourself"),
        centerTitle: true,
        elevation: 2.0,
      ),
      body: _buildContent(context),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 50,
            child: buildHeader(),
          ),
          SizedBox(
            height: 36.0,
          ),
          SocialSignInButton(
            color: Colors.white,
            onPressed: _isLoading ? null : () => _signInWithGoogle(context),
            text: "Sign in with Google",
            textColor: Colors.black87,
            assetName: 'images/google-logo.png',
          ),
          SizedBox(
            height: 16.0,
          ),
          SignInButton(
            color: Colors.indigo,
            textColor: Colors.white,
            onPressed: _isLoading ? null : () => _signInWithEmail(context),
            text: "Sign in with Email",
          ),
        ],
      ),
    );
  }

  Widget buildHeader() {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Text(
            "Sign in",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w500,
            ),
          );
  }
}
