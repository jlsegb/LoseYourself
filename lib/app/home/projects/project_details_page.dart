import 'package:flutter/material.dart';
import 'package:just_serve/app/home/models/project.dart';
import 'package:just_serve/services/database.dart';
import 'package:provider/provider.dart';

class ProjectDetailsPage extends StatelessWidget {
  const ProjectDetailsPage({
    Key key,
    @required this.project,
    @required this.database,
  }) : super(key: key);

  final Project project;
  final Database database;

  static Future<void> show(BuildContext context, {Project project}) async {
    final database = Provider.of<Database>(
      context,
      listen: false,
    );
    await Navigator.of(
      context,
      rootNavigator: true,
    ).push(
      MaterialPageRoute(
        builder: (context) => ProjectDetailsPage(
          database: database,
          project: project,
        ),
        fullscreenDialog: true,
      ),
    );
  }

/*  String _buildStringDate() {
    return DateFormatter.dateToString(DateTime.parse(project.date));
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(project.name),
        elevation: 5.0,
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey[100],
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildColumn(),
          ),
        ),
      ),
    );
  }

  Widget _buildColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _buildFormChildren(),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      Text(
        'Description:',
        style: TextStyle(
          fontSize: 12.0,
          color: Colors.black,
          decoration: TextDecoration.underline,
          fontStyle: FontStyle.italic,
        ),
      ),
      SizedBox(
        height: 4.0,
      ),
      Text(
        project.description,
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.black87,
          fontStyle: FontStyle.normal,
        ),
      ),
      SizedBox(
        height: 16.0,
      ),
      Text(
        'Contact Information:',
        style: TextStyle(
          fontSize: 12.0,
          color: Colors.black,
          decoration: TextDecoration.underline,
          fontStyle: FontStyle.italic,
        ),
      ),
      SizedBox(
        height: 4.0,
      ),
      Text(
        project.contactInfo,
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.black87,
          fontStyle: FontStyle.normal,
        ),
      ),
      SizedBox(
        height: 16.0,
      ),
      Text(
        'Date:',
        style: TextStyle(
          fontSize: 12.0,
          color: Colors.black,
          decoration: TextDecoration.underline,
          fontStyle: FontStyle.italic,
        ),
      ),
      SizedBox(
        height: 4.0,
      ),
      Text(
        '${project.date} at ${project.time}',
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.black87,
          fontStyle: FontStyle.normal,
        ),
      ),
    ];
  }
}
