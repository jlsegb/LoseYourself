import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_serve/app/home/models/project.dart';

class ProjectListTile extends StatelessWidget {
  const ProjectListTile({Key key, @required this.project, this.onTap})
      : super(key: key);

  final Project project;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(project.name),
      onTap: onTap,
      trailing: Icon(Icons.chevron_right),
    );
  }
}
