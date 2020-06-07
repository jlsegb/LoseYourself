import 'package:flutter/material.dart';
import 'package:just_serve/custom_widgets/form_submit_button.dart';

class EmailSignInForm extends StatelessWidget {
  List<Widget> _buildChildren() {
    return [
      TextField(
        decoration: InputDecoration(
          labelText: 'Email - Cannot be the same as social account',
          hintText: 'userName@serverName.com',
        ),
      ),
      SizedBox(
        height: 8.0,
      ),
      TextField(
        decoration: InputDecoration(
          labelText: 'Password',
        ),
        obscureText: true,
      ),
      SizedBox(
        height: 8.0,
      ),
      FormSubmitButton(
        text: 'Sign in',
        onPressed: () {},
      ),
      SizedBox(
        height: 8.0,
      ),
      FlatButton(
        child: Text('New to Lose Yourself? Create your account'),
        onPressed: () {},
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(),
      ),
    );
  }
}
