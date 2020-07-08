import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_serve/app/home/models/project.dart';
import 'package:just_serve/app/home/projects/list_items_builder.dart';
import 'package:just_serve/app/home/projects/project_list_tile.dart';
import 'package:just_serve/custom_widgets/firebase_platform_exception_alert_dialog.dart';
import 'package:just_serve/services/database.dart';
import 'package:provider/provider.dart';
import 'project_management_page.dart';

class PersonalProjectsPage extends StatelessWidget {

  Future<void> _delete(BuildContext context, Project project) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteProject(project);
    } on PlatformException catch (e) {
      FirebasePlatformExceptionAlertDialog(
        title: 'Failed to delete ${project.name}.',
        actionText: 'OK',
        exception: e,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Personal Projects"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            color: Colors.white,
            onPressed: () => ProjectManagementPage.show(context),
          ),
        ],
      ),
      body: _buildProjectsList(context),
    );
  }

  Widget _buildProjectsList(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Project>>(
      stream: database.personalProjectsStream(),
      builder: (context, snapshot) {
        return ListItemsBuilder(
          snapshot: snapshot,
          itemBuilder: (context, project) => Dismissible(
            key: Key('project-${project.id}'),
            background: Container(
              color: Colors.red,
            ),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _delete(context, project),
            child: ProjectListTile(
              project: project,
              onTap: () =>
                  ProjectManagementPage.show(context, project: project),
            ),
          ),
        );
      },
    );
  }
}
