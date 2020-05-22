import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  CustomRaisedButton({
    this.borderRadius: 4.0,
    this.child,
    this.color,
    this.onPressed,
    this.height: 60,
  }) : assert(borderRadius != null),
       assert(height != null);
  final Widget child;
  final Color color;
  final double borderRadius;
  final VoidCallback onPressed;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius),
          ),
        ),
        child: child,
        onPressed: onPressed,
        color: color,
      ),
    );
  }
}
