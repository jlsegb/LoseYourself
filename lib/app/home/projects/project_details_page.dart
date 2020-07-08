import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_serve/app/home/models/project.dart';
import 'package:just_serve/services/database.dart';
import 'package:provider/provider.dart';

class ProjectDetailsPage extends StatefulWidget {
  const ProjectDetailsPage({
    Key key,
    this.project,
    @required this.database,
  }) : super(key: key);

  final Project project;
  final Database database;

  static Future<void> show(BuildContext context, {Project project}) async {
    final database = Provider.of<Database>(
      context,
      listen: false,
    );
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProjectDetailsPage(
          database: database,
          project: project,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _ProjectDetailsPageState createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  String _projectName;
  String _description;
  String _contactInfo;
  String _projectDate;

  @override
  void initState() {
    super.initState();
    if (widget.project != null) {
      _projectName = widget.project.name;
      _contactInfo = widget.project.contactInfo;
      _description = widget.project.description;
      _projectDate = widget.project.date;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project.name),
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
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        initialValue: _projectName,
        enabled: false,
        decoration: InputDecoration(labelText: 'Project name'),
        textInputAction: TextInputAction.next,
      ),
      TextFormField(
        initialValue: _description,
        enabled: false,
        decoration: InputDecoration(labelText: 'Project description'),
        textInputAction: TextInputAction.next,
      ),
      TextFormField(
        initialValue: _contactInfo,
        enabled: false,
        decoration: InputDecoration(labelText: 'Contact information'),
      ),
      TextFormField(
        initialValue: _projectDate,
        enabled: false,
        decoration: InputDecoration(
          labelText: 'Project date',
          hintText: 'MM/DD/YYYY',
        ),
      ),
    ];
  }
}
