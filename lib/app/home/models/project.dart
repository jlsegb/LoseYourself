import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Project {
  Project({
    @required this.name,
    @required this.description,
    @required this.contactInfo,
    @required this.date,
    @required this.time,
    @required this.id,
  });

  final String name;
  final String description;
  final String contactInfo;
  final String date;
  final String time;
  final String id;

  factory Project.fromMap(Map<String, dynamic> data, String projectId) {
    if (data != null) {
      final String name = data['name'];
      final String description = data['description'];
      final String contactInfo = data['contactInfo'];
      final String date = data['date'];
      final String time = data['time'];

      return Project(
        name: name,
        description: description,
        contactInfo: contactInfo,
        date: date,
        time: time,
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
      'time': time,
      'id': id,
    };
  }
}
