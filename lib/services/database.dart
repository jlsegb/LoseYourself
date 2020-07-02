import 'dart:math';

import 'package:just_serve/app/home/models/project.dart';
import 'package:just_serve/services/api_path.dart';
import 'package:just_serve/services/firestore_service.dart';
import 'package:meta/meta.dart';

abstract class Database {
  Future<void> createProject(Project project);

  Stream<List<Project>> personalProjectsStream();

  Stream<List<Project>> publicProjectsStream();
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);

  final String uid;
  final FirestoreService _firestoreService = FirestoreService.instance;

  String _generateProjectIdFromTime() {
    return DateTime.now().toIso8601String() +
        new Random(DateTime.now().millisecond).toString();
  }

  Future<void> createProject(Project project) async {
    final String projectId = _generateProjectIdFromTime();

    final personalProjects = APIPath.personalProject(uid, projectId);
    final allProjects = APIPath.publicProject(projectId);

    await _firestoreService.setData(personalProjects, project.toMap());
    await _firestoreService.setData(allProjects, project.toMap());
  }

  Stream<List<Project>> personalProjectsStream() {
    return _firestoreService.collectionStream(
      path: APIPath.personalProjectsList(uid),
      builder: (data) => Project.fromMap(data),
    );
  }

  Stream<List<Project>> publicProjectsStream() {
    return _firestoreService.collectionStream(
      path: APIPath.publicProjectsList(),
      builder: (data) => Project.fromMap(data),
    );
  }
}
