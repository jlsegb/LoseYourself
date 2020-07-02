import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_serve/app/home/models/project.dart';
import 'package:just_serve/custom_widgets/firebase_platform_exception_alert_dialog.dart';
import 'package:just_serve/services/database.dart';
import 'package:provider/provider.dart';

class AddProjectPage extends StatefulWidget {
  const AddProjectPage({Key key, @required this.database}) : super(key: key);

  final Database database;

  static Future<void> show(BuildContext context) async {
    final database = Provider.of<Database>(
      context,
      listen: false,
    );
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddProjectPage(
          database: database,
        ),
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
  bool isSaving = false;

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _contactInfoFocusNode = FocusNode();
  final FocusNode _dateFocusNode = FocusNode();

  void dispose() {
    _nameFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _contactInfoFocusNode.dispose();
    _dateFocusNode.dispose();

    super.dispose();
  }

  bool _validateAndSaveForm() {
    final formState = _formKey.currentState;

    if (formState.validate() == true) {
      formState.save();
      return true;
    } else {
      return false;
    }
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm() == true) {
      try {
        isSaving = true;
        final project = Project(
          name: _projectName,
          description: _description,
          contactInfo: _contactInfo,
          date: _projectDate,
        );
        await widget.database.createProject(project);
        Navigator.of(context).pop();
      } on PlatformException catch (e) {
        FirebasePlatformExceptionAlertDialog(
          title: 'Failed to add $_projectName.',
          actionText: 'OK',
          exception: e,
        ).show(context);
      } finally {
        isSaving = false;
      }
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

  void _requestNextFocusNode(String value, FocusNode destinationNode) {
    if (value.length > 0) {
      FocusScope.of(context).requestFocus(destinationNode);
    }
  }

  void _nameEditingComplete() {
    _formKey.currentState.save();
    _requestNextFocusNode(_projectName, _descriptionFocusNode,);
  }

  void _descriptionEditingComplete() {
    _formKey.currentState.save();
    _requestNextFocusNode(_description, _contactInfoFocusNode,);
  }

  void _contactInfoEditingComplete() {
    _formKey.currentState.save();
    _requestNextFocusNode(_contactInfo, _dateFocusNode,);
  }

  void _dateEditingComplete() {
    _formKey.currentState.save();
    _lastTextFieldEditingComplete(_projectDate);
  }

  void _lastTextFieldEditingComplete(String value) {
    if (value != null) {
      _submit();
    }
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        enabled: !isSaving,
        decoration: InputDecoration(labelText: 'Project name'),
        onSaved: (value) => _projectName = value,
        textInputAction: TextInputAction.next,
        focusNode: _nameFocusNode,
        onEditingComplete: _nameEditingComplete,
      ),
      TextFormField(
        enabled: !isSaving,
        decoration: InputDecoration(labelText: 'Project description'),
        textInputAction: TextInputAction.next,
        onSaved: (value) => _description = value,
        focusNode: _descriptionFocusNode,
        onEditingComplete: _descriptionEditingComplete,
      ),
      TextFormField(
        enabled: !isSaving,
        decoration: InputDecoration(labelText: 'Contact information'),
        textInputAction: TextInputAction.next,
        onSaved: (value) => _contactInfo = value,
        focusNode: _contactInfoFocusNode,
        onEditingComplete: _contactInfoEditingComplete,
      ),
      TextFormField(
        enabled: !isSaving,
        decoration: InputDecoration(
          labelText: 'Project date',
          hintText: 'MM/DD/YYYY',
        ),
        keyboardType: TextInputType.datetime,
        textInputAction: TextInputAction.done,
        onSaved: (value) => _projectDate = value,
        focusNode: _dateFocusNode,
        onEditingComplete: _dateEditingComplete,
      ),
    ];
  }
}
