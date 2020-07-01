import 'package:flutter/material.dart';
import 'package:just_serve/app/sign_in/sign_in_page.dart';
import 'package:just_serve/services/auth.dart';
import 'package:just_serve/services/database.dart';
import 'package:provider/provider.dart';
import 'home/projects/projects_page.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return StreamBuilder<User>(
      stream: auth.onAuthStateChange,
      builder: (
        context,
        snapshot,
      ) {
        if (snapshot.connectionState == ConnectionState.active) {
          User user = snapshot.data;
          if (user == null) {
            return SignInPage.create(context);
          }
          return Provider<Database>(
            create: (_) => FirestoreDatabase(
              uid: user.uid,
            ),
            child: ProjectsPage(),
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
