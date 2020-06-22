import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_serve/custom_widgets/platform_alert_dialog.dart';

class FirebasePlatformExceptionAlertDialog extends PlatformAlertDialog {
  FirebasePlatformExceptionAlertDialog({
    @required PlatformException exception,
    @required String title,
    @required String actionText,
  }) : super(
            title: title,
            defaultActionText: actionText,
            dialogContent: _message(exception));

  static String _message (PlatformException exception) {
    return _firebaseErrors[exception.code] ?? exception.message;
  }

  //TODO: customize sign in errors if they are not very good.
  static Map<String, String> _firebaseErrors = {
    ///  * `ERROR_INVALID_EMAIL` - If the [email] address is malformed.
    ///  * `ERROR_WRONG_PASSWORD` - If the [password] is wrong.
    ///  * `ERROR_USER_NOT_FOUND` - If there is no user corresponding to the given [email] address, or if the user has been deleted.
    ///  * `ERROR_USER_DISABLED` - If the user has been disabled (for example, in the Firebase console)
    ///  * `ERROR_TOO_MANY_REQUESTS` - If there was too many attempts to sign in as this user.
    ///  * `ERROR_OPERATION_NOT_ALLOWED` - Indicates that Email & Password accounts are not enabled.
    ///  * `ERROR_WEAK_PASSWORD` - If the password is not strong enough.
    ///  * `ERROR_INVALID_EMAIL` - If the email address is malformed.
    ///  * `ERROR_EMAIL_ALREADY_IN_USE` - If the email is already in use by a different account.
  };
}
