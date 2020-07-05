import 'dart:math';

import 'package:just_serve/app/home/models/project.dart';
import 'package:just_serve/services/api_path.dart';
import 'package:just_serve/services/firestore_service.dart';
import 'package:meta/meta.dart';

abstract class Database {
  Future<void> setProject(Project project);

  Stream<List<Project>> personalProjectsStream();

  Stream<List<Project>> publicProjectsStream();

  String generateProjectIdFromTime();
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);

  final String uid;
  final FirestoreService _firestoreService = FirestoreService.instance;

  String generateProjectIdFromTime() {
    return DateTime.now().toIso8601String() +
        new Random(DateTime.now().millisecond).toString();
  }

  Future<void> setProject(Project project) async {
    final personalProjects = APIPath.personalProject(uid, project.id);
    final allProjects = APIPath.publicProject(project.id);

    await _firestoreService.setData(personalProjects, project.toMap());
    await _firestoreService.setData(allProjects, project.toMap());
  }

  Stream<List<Project>> personalProjectsStream() {
    return _firestoreService.collectionStream(
      path: APIPath.personalProjectsList(uid),
      builder: (data, projectId) => Project.fromMap(data, projectId),
    );
  }

  Stream<List<Project>> publicProjectsStream() {
    return _firestoreService.collectionStream(
      path: APIPath.publicProjectsList(),
      builder: (data, projectId) => Project.fromMap(data, projectId),
    );
  }
}
