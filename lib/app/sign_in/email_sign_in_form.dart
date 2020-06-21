import 'package:flutter/material.dart';
import 'package:just_serve/app/sign_in/validators.dart';
import 'package:just_serve/custom_widgets/form_submit_button.dart';
import 'package:just_serve/custom_widgets/platform_alert_dialog.dart';
import 'dart:io';

import 'package:just_serve/services/auth_provider.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInForm extends StatefulWidget with EmailAndPasswordValidators {
  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  EmailSignInFormType _formType = EmailSignInFormType.signIn;
  bool _hasBeenSubmitted = false;
  bool _isFormWaitingForFirebaseResponse = false;

  String get _password => _passwordController.text;

  String get _email => _emailController.text;

  void _submit() async {
    setState(() {
      _hasBeenSubmitted = true;
      _isFormWaitingForFirebaseResponse = true;
    });
    try {
      final auth = AuthProvider.of(context);
      if (_formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(_email, _password);
      } else {
        await auth.createUserWithEmailAndPassword(_email, _password);
      }
      Navigator.of(context).pop(); //Registration or sign in successful.
    } catch (e) {
      if (Platform.isIOS) {
        //show cupertino widget
      } else {
        PlatformAlertDialog(
          title: 'Sign in failed.',
          defaultActionText: 'Ok',
          dialogContent: e.toString(),
        ).show(context);
      }
    } finally {
      setState(() {
        _isFormWaitingForFirebaseResponse = false;
      });
    }
  }

  void _emailEditingComplete() {
    FocusNode correctFocusNode =
        widget.emailValidator.isValid(_email) ? _passwordFocusNode : _emailFocusNode;
    FocusScope.of(context).requestFocus(correctFocusNode);
  }

  void _passwordEditingComplete() {
    widget.emailValidator.isValid(_password)
        ? _submit()
        : FocusScope.of(context).requestFocus(_passwordFocusNode);
  }

  void _toggleFormTypeAndClearTextField() {
    setState(() {
      _hasBeenSubmitted = false;
      _formType = _formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren() {
    final primaryText =
        _formType == EmailSignInFormType.signIn ? 'Sign In' : 'Create Account';
    final secondaryText = _formType == EmailSignInFormType.signIn
        ? 'New to Lose Yourself? Create your account!'
        : 'Already Have an account? Sign in here!';

    bool enableLogInButton = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password) &&
        !_isFormWaitingForFirebaseResponse;
    return [
      _buildEmailTextField(),
      SizedBox(
        height: 8.0,
      ),
      _buildPasswordTextField(),
      SizedBox(
        height: 8.0,
      ),
      FormSubmitButton(
        text: primaryText,
        onPressed: enableLogInButton ? _submit : null,
      ),
      SizedBox(
        height: 8.0,
      ),
      FlatButton(
        child: Text(secondaryText),
        onPressed: _isFormWaitingForFirebaseResponse
            ? null
            : _toggleFormTypeAndClearTextField,
      ),
    ];
  }

  TextField _buildEmailTextField() {
    bool isEmailInvalid = _hasBeenSubmitted && !widget.emailValidator.isValid(_email);
    return TextField(
      onChanged: (email) => updateForm(),
      focusNode: _emailFocusNode,
      controller: _emailController,
      enabled: !_isFormWaitingForFirebaseResponse,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'userName@serverName.com',
        errorText: isEmailInvalid ? widget.invalidEmailMessage : null,
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onEditingComplete: _emailEditingComplete,
    );
  }

  TextField _buildPasswordTextField() {
    bool isPasswordInvalid =
        _hasBeenSubmitted && !widget.passwordValidator.isValid(_password);
    return TextField(
      onChanged: (password) => updateForm(),
      focusNode: _passwordFocusNode,
      controller: _passwordController,
      enabled: !_isFormWaitingForFirebaseResponse,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: isPasswordInvalid ? widget.invalidPasswordMessage : null,
      ),
      obscureText: true,
      autocorrect: false,
      textInputAction: TextInputAction.done,
      onEditingComplete: _passwordEditingComplete,
    );
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

  updateForm() {
    setState(() {});
  }
}
