import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:just_serve/services/auth.dart';

class SignInBloc {
  SignInBloc({@required this.auth});

  final StreamController<bool> _isLoadingController = StreamController<bool>();
  final AuthBase auth;

  Stream<bool> get isLoadingStream => _isLoadingController.stream;

  void _setIsLoading(bool isLoading) => _isLoadingController.add(isLoading);

  void dispose() {
    _isLoadingController.close();
  }

  Future<User> _signIn(Future<User> Function() signInMethod) async {
    try{
      _setIsLoading(true);
      return await signInMethod();
    } catch (e) {
      rethrow;
    } finally {
      _setIsLoading(false);
    }
  }

  Future<User> signInWithGoogle() async => _signIn(auth.signInWithGoogle);
}
