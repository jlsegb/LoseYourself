import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:just_serve/app/home/models/project.dart';
import 'package:just_serve/app/home/projects/date_formatter.dart';
import 'package:just_serve/app/home/projects/date_time_picker.dart';
import 'package:just_serve/custom_widgets/firebase_platform_exception_alert_dialog.dart';
import 'package:just_serve/custom_widgets/platform_alert_dialog.dart';
import 'package:just_serve/services/database.dart';
import 'package:provider/provider.dart';

class ProjectManagementPage extends StatefulWidget {
  const ProjectManagementPage({
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
    await Navigator.of(
      context,
      rootNavigator: true,
    ).push(
      MaterialPageRoute(
        builder: (context) => ProjectManagementPage(
          database: database,
          project: project,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _ProjectManagementPageState createState() => _ProjectManagementPageState();
}

class _ProjectManagementPageState extends State<ProjectManagementPage> {
  final _formKey = GlobalKey<FormState>();
  String _projectName;
  String _description;
  String _contactInfo;
  String _dateString;
  String _timeString;
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  bool _isSaving = false;

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _contactInfoFocusNode = FocusNode();
  final FocusNode _dateFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.project != null) {
      _projectName = widget.project.name;
      _contactInfo = widget.project.contactInfo;
      _description = widget.project.description;
      _dateString = widget.project.date;
      _timeString = widget.project.time;
      _date = _dateString != null
          ? DateFormatter.stringToDate(_dateString)
          : DateTime.now();
      _time = _timeString != null
          ? _stringToTimeOfDay(_timeString)
          : TimeOfDay.now();
    }
  }

  TimeOfDay _stringToTimeOfDay(String tod) {
    final format = DateFormat.jm(); //"6:00 AM"
    return TimeOfDay.fromDateTime(format.parse(tod));
  }

  String _timeOfDayToString(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }

  void dispose() {
    _nameFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _contactInfoFocusNode.dispose();
    _dateFocusNode.dispose();

    super.dispose();
  }

  bool _validateAndSaveForm() {
    final formState = _formKey.currentState;
    _dateString = DateFormatter.dateToString(_date);
    _timeString = _timeOfDayToString(_time);

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
        final projects = await widget.database.publicProjectsStream().first;
        final postedProjectNames =
            projects.map((project) => project.name).toList();
        if (widget.project != null) {
          postedProjectNames.remove(_projectName);
        }
        if (postedProjectNames.contains(_projectName)) {
          PlatformAlertDialog(
            title: 'Unable to add \'$_projectName\'',
            defaultActionText: 'OK',
            dialogContent:
                'This project name is in use by a different project. '
                '\n\nPlease choose a different project name',
          ).show(context);
          return;
        }
        _isSaving = true;
        final project = Project(
          name: _projectName,
          description: _description,
          contactInfo: _contactInfo,
          date: _dateString,
          time: _timeString,
          id: widget.project?.id ?? widget.database.generateProjectIdFromTime(),
        );
        await widget.database.setProject(project);
        Navigator.of(context).pop();
      } on PlatformException catch (e) {
        FirebasePlatformExceptionAlertDialog(
          title: 'Failed to add $_projectName.',
          actionText: 'OK',
          exception: e,
        ).show(context);
      } finally {
        _isSaving = false;
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
        title: Text(widget.project == null ? 'New project' : 'Edit Project'),
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
    _requestNextFocusNode(
      _projectName,
      _descriptionFocusNode,
    );
  }

  void _descriptionEditingComplete() {
    _formKey.currentState.save();
    _requestNextFocusNode(
      _description,
      _contactInfoFocusNode,
    );
  }

  void _contactInfoEditingComplete() {
    _formKey.currentState.save();
    _requestNextFocusNode(
      _contactInfo,
      _dateFocusNode,
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        initialValue: _projectName,
        enabled: !_isSaving,
        decoration: InputDecoration(labelText: 'Project name'),
        onSaved: (value) => _projectName = value,
        textInputAction: TextInputAction.next,
        focusNode: _nameFocusNode,
        onEditingComplete: _nameEditingComplete,
        validator: _nameValidator,
      ),
      TextFormField(
        initialValue: _description,
        enabled: !_isSaving,
        decoration: InputDecoration(labelText: 'Description'),
        textInputAction: TextInputAction.next,
        onSaved: (value) => _description = value,
        focusNode: _descriptionFocusNode,
        onEditingComplete: _descriptionEditingComplete,
        validator: _descriptionValidator,
        maxLines: null,
      ),
      TextFormField(
        initialValue: _contactInfo,
        enabled: !_isSaving,
        decoration: InputDecoration(labelText: 'Contact information'),
        textInputAction: TextInputAction.next,
        onSaved: (value) => _contactInfo = value,
        focusNode: _contactInfoFocusNode,
        onEditingComplete: _contactInfoEditingComplete,
        validator: _contactValidator,
      ),
      DateTimePicker(
        labelText: 'Start date and time',
        selectDate: (date) => setState(() => _date = date),
        selectTime: (time) => setState(() => _time = time),
        selectedDate: _date,
        selectedTime: _time,
      ),
    ];
  }

  String _nameValidator(String name) {
    return _isNamePresent(name)
        ? _isNameShort(name)
            ? null
            : 'The name cannot be longer than 25 characters'
        : 'The project must have a name';
  }

  bool _isNamePresent(String name) {
    return name.isNotEmpty;
  }

  bool _isNameShort(String name) {
    return name.length <= 25;
  }

  String _contactValidator(String contact) {
    return _isContactValid(contact) ? null : 'The project must have a contact';
  }

  bool _isContactValid(String contact) {
    return contact.isNotEmpty;
  }

  String _descriptionValidator(String description) {
    return _isDescriptionValid(description)
        ? null
        : 'The project must have a description';
  }

  bool _isDescriptionValid(String description) {
    return description.isNotEmpty;
  }
}
