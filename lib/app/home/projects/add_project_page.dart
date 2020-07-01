import 'package:flutter/material.dart';

class AddProjectPage extends StatefulWidget {
  static Future<void> show(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddProjectPage(),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _AddProjectPageState createState() => _AddProjectPageState();
}

class _AddProjectPageState extends State<AddProjectPage> {
  final _formKey = GlobalKey<FormState>();
  String _projectName;
  String _description;
  String _contactInfo;
  String _projectDate;

  bool _validateAndSaveForm() {
    final formState = _formKey.currentState;

    if (formState.validate() == true) {
      formState.save();
      return true;
    } else {
      return false;
    }
  }

  void _submit() {
    if (_validateAndSaveForm() == true) {
      print('form saved and validated');
      print(
          'name: $_projectName, '
          'description: $_description, '
          'contact: $_contactInfo, '
          'date: $_projectDate');

      //TODO: Send data to public and personal projects
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          FlatButton(
            onPressed: _submit,
            child: Text(
              'Save',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
        title: Text('New project'),
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
        decoration: InputDecoration(labelText: 'Project name'),
        onSaved: (value) => _projectName = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Project description'),
        onSaved: (value) => _description = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Contact information'),
        onSaved: (value) => _contactInfo = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Project date'),
        keyboardType: TextInputType.datetime,
        onSaved: (value) => _projectDate = value,
      ),
    ];
  }
}
