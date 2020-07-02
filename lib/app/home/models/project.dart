import 'package:flutter/foundation.dart';

class Project {
  Project({
    @required this.description,
    @required this.name,
    @required this.contactInfo,
    @required this.date,
  });

  final String contactInfo;
  final String name;
  final String description;
  final String date;

  factory Project.fromMap(Map<String, dynamic> data) {
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
