import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:just_serve/app/sign_in/email_sign_in_model.dart';
import 'package:just_serve/services/auth.dart';

class EmailSignInBloc {
  EmailSignInBloc({
    @required this.auth,
  });

  final AuthBase auth;
  final StreamController<EmailSignInModel> _modelController =
      StreamController<EmailSignInModel>();

  Stream<EmailSignInModel> get modelStream => _modelController.stream;
  EmailSignInModel _model = EmailSignInModel();

  void dispose() {
    _modelController.close();
  }

  void updateWith({
    String email,
    String password,
    bool isLoading,
    bool submitted,
    EmailSignInFormType formType,
  }) {
    _model = _model.copyWith(
      submitted: submitted,
      password: password,
      isLoading: isLoading,
      formType: formType,
      email: email,
    );
    _modelController.add(_model);
  }

  void toggleFormType() {
    updateWith(
      email: '',
      isLoading: false,
      password: '',
      submitted: false,
      formType: _model.formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn,
    );
  }

  void updateEmail(String email) {
    updateWith(email: email);
  }

  void updatePassword(String password) {
    updateWith(password: password);
  }

  Future<void> submit() async {
    updateWith(
      submitted: true,
      isLoading: true,
    );
    try {
      if (_model.formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(_model.email, _model.password);
      } else {
        await auth.createUserWithEmailAndPassword(
            _model.email, _model.password);
      }
    } catch (e) {
      updateWith(
        isLoading: false,
      );
      rethrow;
    }
  }
}
