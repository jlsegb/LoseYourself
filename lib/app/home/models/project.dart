import 'package:flutter/foundation.dart';

class Project {
  Project({
    @required this.description,
    @required this.name,
    @required this.ownerContactInformation,
  });

  final String ownerContactInformation;
  final String name;
  final String description;

  factory Project.fromMap(Map<String, dynamic> data) {
    if (data != null) {
      final String ownerContactInformation = data['ownerContactInformation'];
      final String name = data['name'];
      final String description = data['description'];

      return Project(
        name: name,
        ownerContactInformation: ownerContactInformation,
        description: description,
      );
    }

    return null;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ownerContactInformation': ownerContactInformation,
      'description': description,
    };
  }
}
