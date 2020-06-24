import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:just_serve/services/auth.dart';

class SignInBloc {
  SignInBloc({@required this.auth});

  final StreamController<bool> _isLoadingController = StreamController<bool>();
  final AuthBase auth;

  Stream<bool> get isLoadingStream => _isLoadingController.stream;

  void setIsLoading(bool isLoading) => _isLoadingController.add(isLoading);

  void dispose() {
    _isLoadingController.close();
  }

  Future<User> _signIn(Future<User> Function() signInMethod) {
    try{
      setIsLoading(true);
    } catch (e) {
      rethrow;
    } finally {
      setIsLoading(false);
    }
  }

  Future<User> signInWithGoogle() => _signIn(auth.signInWithGoogle);
}
