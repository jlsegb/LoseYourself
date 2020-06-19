import 'package:flutter/material.dart';
import 'package:just_serve/custom_widgets/platform_alert_dialog.dart';
import 'package:just_serve/services/auth.dart';

class HomePage extends StatelessWidget {
  HomePage({
    @required this.auth,
  });

  final AuthBase auth;

  Future<void> _signOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final isLogoutRequested = await PlatformAlertDialog(
      defaultActionText: 'Logout',
      dialogContent: 'Are you sure you want to logout?',
      title: 'Logout',
      cancelActionText: 'Cancel',
    ).show(context);

    if (isLogoutRequested){
      _signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HomePage"),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "Log out",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            onPressed: () => _confirmSignOut(context),
          ),
        ],
      ),
    );
  }
}
