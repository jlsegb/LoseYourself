import 'package:flutter/material.dart';
import 'package:just_serve/custom_widgets/form_submit_button.dart';

enum EmailSignInFormType { signIn, register}

class EmailSignInForm extends StatefulWidget {
  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  EmailSignInFormType _formType = EmailSignInFormType.register;

  void _submit () {
    //
  }

  void toggleFormTypeAndClearTextField(){
    setState(() {
      _formType = _formType == EmailSignInFormType.signIn?
          EmailSignInFormType.register : EmailSignInFormType.signIn;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren() {
    final primaryText = _formType == EmailSignInFormType.signIn?
        'Sign In' : 'Register';
    final secondaryText = _formType == EmailSignInFormType.signIn?
        'New to Lose Yourself? Create your account' : 'Already Have an account? Sign in here!';

    return [
      TextField(
        controller: _emailController,
        decoration: InputDecoration(
          labelText: 'Email - Cannot be the same as social account',
          hintText: 'userName@serverName.com',
        ),
      ),
      SizedBox(
        height: 8.0,
      ),
      TextField(
        controller: _passwordController,
        decoration: InputDecoration(
          labelText: 'Password',
        ),
        obscureText: true,
      ),
      SizedBox(
        height: 8.0,
      ),
      FormSubmitButton(
        text: primaryText,
        onPressed: () {},
      ),
      SizedBox(
        height: 8.0,
      ),
      FlatButton(
        child: Text(secondaryText),
        onPressed: _submit,
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
