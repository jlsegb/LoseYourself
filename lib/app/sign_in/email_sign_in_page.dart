import 'package:flutter/material.dart';
import 'package:just_serve/services/auth.dart';

import 'email_sign_in_form.dart';

class EmailSignInPage extends StatelessWidget {
  final AuthBase auth;

  EmailSignInPage({@required this.auth});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
        centerTitle: true,
        elevation: 2.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: EmailSignInForm(
            auth: auth,
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
