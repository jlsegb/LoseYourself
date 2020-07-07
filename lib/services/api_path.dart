import 'package:flutter/material.dart';

class APIPath {
  static String publicProject({
    @required String projectId,
  }) =>
      'public_projects/$projectId';

  static String personalProject({
    @required String uid,
    @required String projectId,
  }) =>
      'users/$uid/projects/$projectId';

  static String publicProjectsList() => 'public_projects';

  static String personalProjectsList(
    String uid,
  ) =>
      'users/$uid/projects';
}
