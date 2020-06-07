import 'package:flutter/cupertino.dart';
import 'package:just_serve/custom_widgets/common_raised_button.dart';

class SignInButton extends CustomRaisedButton {
  SignInButton({
    @required String text,
    Color color,
    Color textColor,
    VoidCallback onPressed,
  }) :  assert (text != null),
        super(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 15.0,
              ),
            ),
          ],
        ),
        color: color,
        onPressed: onPressed,
      );
}
