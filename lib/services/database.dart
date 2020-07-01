import 'package:just_serve/app/home/models/project.dart';
import 'package:just_serve/services/api_path.dart';
import 'package:just_serve/services/firestore_service.dart';
import 'package:meta/meta.dart';

abstract class Database {
  Future<void> createProject(Project projectData);

  Stream<List<Project>> personalProjectsStream();

  Stream<List<Project>> publicProjectsStream();
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;
  final FirestoreService _firestoreService = FirestoreService.instance;

  Future<void> createProject(Project project) async {
    final personalProjects = APIPath.personalProject(uid, "project_abc");
    final allProjects = APIPath.publicProject('project_abc');

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
