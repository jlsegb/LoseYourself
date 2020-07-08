import 'package:flutter/material.dart';
import 'package:just_serve/app/home/models/project.dart';
import 'package:just_serve/app/home/projects/list_items_builder.dart';
import 'package:just_serve/app/home/projects/project_details_page.dart';
import 'package:just_serve/app/home/projects/project_list_tile.dart';
import 'package:just_serve/services/database.dart';
import 'package:provider/provider.dart';

class PublicBoardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Public Board"),
      ),
      body: _buildProjectsList(context),
    );
  }

  Widget _buildProjectsList(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Project>>(
      stream: database.publicProjectsStream(),
      builder: (context, snapshot) {
        return ListItemsBuilder(
          snapshot: snapshot,
          itemBuilder: (context, project) => ProjectListTile(
            project: project,
            onTap: () => ProjectDetailsPage.show(context, project: project),
          ),
        );
      },
    );
  }
}
