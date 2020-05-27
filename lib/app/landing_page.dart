import 'package:flutter/material.dart';
import 'package:just_serve/app/home_page.dart';
import 'package:just_serve/app/sign_in/sign_in_page.dart';
import 'package:just_serve/services/auth.dart';

class LandingPage extends StatefulWidget {
  LandingPage({@required this.auth});

  final AuthBase auth;

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  User _user;

  @override
  void initState() {
    super.initState();
    _verifyFirebaseUser();
    widget.auth.onAuthStateChange.listen((user) {
      print("user: ${user?.uid}");
    });
  }

  Future _verifyFirebaseUser() async {
    User user = await widget.auth.currentUser();

    _updateUser(user);
  }

  void _updateUser(User user) {
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: widget.auth.onAuthStateChange,
      builder: (
        context,
        snapshot,
      ) {
        if (snapshot.hasData) {
          User user = snapshot.data;
          if (user == null) {
            return SignInPage(
              onSignIn: _updateUser,
              auth: widget.auth,
            );
          }
          return HomePage(
            onSignOut: () => _updateUser(null),
            auth: widget.auth,
          );
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
