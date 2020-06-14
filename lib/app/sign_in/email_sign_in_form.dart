import 'package:flutter/material.dart';
import 'package:just_serve/app/sign_in/validators.dart';
import 'package:just_serve/custom_widgets/form_submit_button.dart';
import 'package:just_serve/services/auth.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInForm extends StatefulWidget {
  final AuthBase auth;

  EmailSignInForm({@required this.auth});

  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> with EmailAndPasswordValidators{
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  EmailSignInFormType _formType = EmailSignInFormType.signIn;
  bool _hasBeenSubmitted = false;

  String get _password => _passwordController.text;

  String get _email => _emailController.text;


  void _submit() async {
    _hasBeenSubmitted = true;
    try {
      if (_formType == EmailSignInFormType.signIn) {
        await widget.auth.signInWithEmailAndPassword(_email, _password);
      } else {
        await widget.auth.createUserWithEmailAndPassword(_email, _password);
      }
      Navigator.of(context).pop();//Registration or sign in successful.
    } catch (e) {
      print(e.toString());
    }
  }

  void _emailEditingComplete() {
    FocusScope.of(context).requestFocus(_passwordFocusNode);
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

    bool isLogInValid = emailValidator.isValid(_email) && passwordValidator.isValid(_password);
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
        onPressed: isLogInValid? _submit : null,
      ),
      SizedBox(
        height: 8.0,
      ),
      FlatButton(
        child: Text(secondaryText),
        onPressed: _toggleFormTypeAndClearTextField,
      ),
    ];
  }

  TextField _buildEmailTextField() {
    bool isEmailInvalid = _hasBeenSubmitted && !emailValidator.isValid(_email);
    return TextField(
      onChanged: (email) => updateForm(),
      focusNode: _emailFocusNode,
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'userName@serverName.com',
        errorText: isEmailInvalid ? invalidEmailMessage : null,
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onEditingComplete: _emailEditingComplete,
    );
  }

  TextField _buildPasswordTextField() {
    bool isPasswordInvalid = _hasBeenSubmitted && !passwordValidator.isValid(_password);
    return TextField(
      onChanged: (password) => updateForm(),
      focusNode: _passwordFocusNode,
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: isPasswordInvalid ? invalidPasswordMessage : null,
      ),
      obscureText: true,
      autocorrect: false,
      textInputAction: TextInputAction.done,
      onEditingComplete: _submit,
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
    setState(() {
    });
  }
}