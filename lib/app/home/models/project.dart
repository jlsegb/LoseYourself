import 'package:flutter/foundation.dart';

class Project {
  Project({
    @required this.description,
    @required this.name,
    @required this.contactInfo,
    @required this.date,
    @required this.id,
  });

  final String contactInfo;
  final String name;
  final String description;
  final String date;
  final String id;

  factory Project.fromMap(Map<String, dynamic> data, String projectId) {
    if (data != null) {
      final String contactInfo = data['contactInfo'];
      final String name = data['name'];
      final String description = data['description'];
      final String date = data['date'];

      return Project(
        name: name,
        contactInfo: contactInfo,
        description: description,
        date: date,
        id: projectId,
      );
    }

    return null;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'contactInfo': contactInfo,
      'description': description,
      'date': date,
    };
  }
}
