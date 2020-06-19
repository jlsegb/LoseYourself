import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_serve/custom_widgets/platform_widget.dart';
import 'dart:io';

class PlatformAlertDialog extends PlatformWidget {
  PlatformAlertDialog({
    @required this.defaultActionText,
    @required this.dialogContent,
    @required this.title,
    this.cancelActionText,
  })  : assert(defaultActionText != null),
        assert(dialogContent != null),
        assert(title != null);

  final String title;
  final String defaultActionText;
  final String dialogContent;
  final String cancelActionText;

  Future<bool> show(BuildContext context) async {
    return Platform.isAndroid
        ? await showDialog<bool>(
            context: context,
            builder: (context) => this,
          )
        : await showCupertinoDialog<bool>(
            context: context,
            builder: (context) => this,
          );
  }

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(dialogContent),
      actions: _buildActions(context),
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(dialogContent),
      actions: _buildActions(context),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    final actionsList = <Widget>[];
    if (cancelActionText != null) {
      actionsList.add(
        PlatformAlertDialogAction(
          child: Text(cancelActionText),
          onPressed: () => Navigator.of(context).pop(false),
        ),
      );
    }
    actionsList.add(
      PlatformAlertDialogAction(
        child: Text(defaultActionText),
        onPressed: () => Navigator.of(context).pop(true),
      ),
    );
    return actionsList;
  }
}

class PlatformAlertDialogAction extends PlatformWidget {
  PlatformAlertDialogAction({
    this.onPressed,
    this.child,
  });

  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoDialogAction(
      onPressed: onPressed,
      child: child,
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return FlatButton(
      onPressed: onPressed,
      child: child,
    );
  }
}
