import 'package:flutter/material.dart';
import 'package:just_serve/app/home_page.dart';
import 'package:just_serve/app/sign_in/sign_in_page.dart';
import 'package:just_serve/services/auth.dart';
import 'package:just_serve/services/auth_provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = AuthProvider.of(context);
    return StreamBuilder<User>(
      stream: auth.onAuthStateChange,
      builder: (
        context,
        snapshot,
      ) {
        if (snapshot.connectionState == ConnectionState.active) {
          User user = snapshot.data;
          if (user == null) {
            return SignInPage();
          }
          return HomePage();
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
