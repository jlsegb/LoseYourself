import 'package:flutter/material.dart';
import 'package:just_serve/app/home/models/project.dart';
import 'package:just_serve/custom_widgets/platform_alert_dialog.dart';
import 'package:just_serve/services/auth.dart';
import 'package:just_serve/services/database.dart';
import 'package:provider/provider.dart';
import 'add_project_page.dart';

class ProjectsPage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    final auth = Provider.of<AuthBase>(context, listen: false);
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

    if (isLogoutRequested) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Projects"),
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
      body: _buildProjectsList(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () => AddProjectPage.show(context),
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }

  Widget _buildProjectsList(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Project>>(
      stream: database.publicProjectsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final jobs = snapshot.data;
          final children = jobs.map((job) => Text(job.name)).toList();
          return ListView(
            children: children,
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('There was a problem reading from the database'),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
