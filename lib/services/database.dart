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

  Future<void> deleteProject(Project project);

  String get userId;
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);

  final String uid;
  final FirestoreService _firestoreService = FirestoreService.instance;

  String get userId {
    return uid;
  }

  String generateProjectIdFromTime() {
    return DateTime.now().toIso8601String() +
        '*' +
        new Random().nextInt(DateTime.now().millisecond).toString();
  }

  Future<void> setProject(Project project) async {
    final personalProjects = APIPath.personalProject(uid: uid, projectId: project.id);
    final allProjects = APIPath.publicProject(projectId: project.id);

    await _firestoreService.setData(path: personalProjects, data: project.toMap());
    await _firestoreService.setData(path: allProjects, data: project.toMap());
  }

  Future<void> deleteProject(Project project) async {
    final personalProjects = APIPath.personalProject(uid: uid, projectId: project.id);
    final allProjects = APIPath.publicProject(projectId: project.id);

    await _firestoreService.deleteData(path: personalProjects);
    await _firestoreService.deleteData(path: allProjects);
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
