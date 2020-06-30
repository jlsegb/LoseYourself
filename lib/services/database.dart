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
  final FirestoreService firestoreService = FirestoreService.instance;

  Future<void> createProject(Project project) async {
    final personalProjects = APIPath.personalProject(uid, "project_abc");
    final allProjects = APIPath.publicProject('project_abc');

    await firestoreService.setData(personalProjects, project.toMap());
    await firestoreService.setData(allProjects, project.toMap());
  }

  Stream<List<Project>> personalProjectsStream() {
    return firestoreService.collectionStream(APIPath.personalProjectsList(uid));
  }

  Stream<List<Project>> publicProjectsStream() {
    return firestoreService.collectionStream(APIPath.publicProjectsList());
  }
}
