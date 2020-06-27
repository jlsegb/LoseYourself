import 'package:just_serve/app/sign_in/validators.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInModel with EmailAndPasswordValidators {
  EmailSignInModel({
    this.formType = EmailSignInFormType.signIn,
    this.isLoading = false,
    this.email = '',
    this.password = '',
    this.submitted = false,
  });

  final String email;
  final String password;
  final EmailSignInFormType formType;
  final bool submitted;
  final bool isLoading;

  EmailSignInModel copyWith({
    String email,
    String password,
    bool isLoading,
    bool submitted,
    EmailSignInFormType formType,
  }) {
    return EmailSignInModel(
      email: email ?? this.email,
      formType: formType ?? this.formType,
      isLoading: isLoading ?? this.isLoading,
      password: password ?? this.password,
      submitted: submitted ?? this.submitted,
    );
  }

  String get primaryButtonText {
    return formType == EmailSignInFormType.signIn
        ? 'Sign In'
        : 'Create Account';
  }

  String get secondaryButtonText {
    return formType == EmailSignInFormType.signIn
        ? 'New to Lose Yourself? Create your account!'
        : 'Already Have an account? Sign in here!';
  }

  bool get shouldSignInButtonBeEnabled {
    return emailValidator.isValid(email) &&
        passwordValidator.isValid(password) &&
        !isLoading;
  }

  bool get _shouldShowEmailTextFieldErrorText {
    return submitted && !emailValidator.isValid(email);
  }

  bool get _shouldShowPasswordTextFieldErrorText {
    return submitted && !passwordValidator.isValid(password);
  }

  String get passwordErrorText {
    return _shouldShowPasswordTextFieldErrorText
        ? invalidPasswordMessage
        : null;
  }

  String get emailErrorText {
    return _shouldShowEmailTextFieldErrorText ? invalidEmailMessage : null;
  }

  bool get isEmailValid {
    return emailValidator.isValid(email);
  }

  bool get isPasswordValid {
    return passwordValidator.isValid(password);
  }
}
