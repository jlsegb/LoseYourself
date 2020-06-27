import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_serve/app/sign_in/email_sign_in_bloc.dart';
import 'package:just_serve/custom_widgets/firebase_platform_exception_alert_dialog.dart';
import 'package:just_serve/custom_widgets/form_submit_button.dart';

import 'package:just_serve/services/auth.dart';
import 'package:provider/provider.dart';
import 'email_sign_in_model.dart';

class EmailSignInFormBlocBased extends StatefulWidget {
  EmailSignInFormBlocBased({
    this.bloc,
  });

  final EmailSignInBloc bloc;

  static Widget create(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context);
    return Provider<EmailSignInBloc>(
      dispose: (context, bloc) => bloc.dispose(),
      create: (context) => EmailSignInBloc(auth: auth),
      child: Consumer<EmailSignInBloc>(
        builder: (context, bloc, _) => EmailSignInFormBlocBased(
          bloc: bloc,
        ),
      ),
    );
  }

  @override
  _EmailSignInFormBlocBasedState createState() =>
      _EmailSignInFormBlocBasedState();
}

class _EmailSignInFormBlocBasedState extends State<EmailSignInFormBlocBased> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    try {
      await widget.bloc.submit();
      Navigator.of(context).pop(); //Registration or sign in successful.
    } on PlatformException catch (e) {
      FirebasePlatformExceptionAlertDialog(
        title: 'Sign in failed.',
        actionText: 'OK',
        exception: e,
      ).show(context);
    }
  }

  void _emailEditingComplete(EmailSignInModel model) {
    FocusNode correctFocusNode =
        model.isEmailValid ? _passwordFocusNode : _emailFocusNode;
    FocusScope.of(context).requestFocus(correctFocusNode);
  }

  void _passwordEditingComplete(EmailSignInModel model) {
    model.isPasswordValid
        ? _submit()
        : FocusScope.of(context).requestFocus(_passwordFocusNode);
  }

  void _toggleFormTypeAndClearTextField() {
    widget.bloc.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren(EmailSignInModel model) {
    return [
      _buildEmailTextField(model),
      SizedBox(
        height: 8.0,
      ),
      _buildPasswordTextField(model),
      SizedBox(
        height: 8.0,
      ),
      FormSubmitButton(
        text: model.primaryButtonText,
        onPressed: model.shouldSignInButtonBeEnabled ? _submit : null,
      ),
      SizedBox(
        height: 8.0,
      ),
      FlatButton(
        child: Text(model.secondaryButtonText),
        onPressed: model.isLoading ? null : _toggleFormTypeAndClearTextField,
      ),
    ];
  }

  TextField _buildEmailTextField(EmailSignInModel model) {
    return TextField(
      onChanged: widget.bloc.updateEmail,
      focusNode: _emailFocusNode,
      controller: _emailController,
      enabled: !model.isLoading,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'userName@serverName.com',
        errorText: model.emailErrorText,
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onEditingComplete: () => _emailEditingComplete(model),
    );
  }

  TextField _buildPasswordTextField(EmailSignInModel model) {
    return TextField(
      onChanged: widget.bloc.updatePassword,
      focusNode: _passwordFocusNode,
      controller: _passwordController,
      enabled: !model.isLoading,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: model.passwordErrorText,
      ),
      obscureText: true,
      autocorrect: false,
      textInputAction: TextInputAction.done,
      onEditingComplete: () => _passwordEditingComplete(model),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EmailSignInModel>(
        stream: widget.bloc.modelStream,
        initialData: EmailSignInModel(),
        builder: (context, snapshot) {
          final EmailSignInModel model = snapshot.data;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: _buildChildren(model),
            ),
          );
        });
  }
}
