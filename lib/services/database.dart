import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

abstract class Database {
  Future<void> createProject(Map<String, dynamic> projectData);
  String get uidGet;
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  String get uidGet {
    return this.uid;
  }

  Future<void> createProject(Map<String, dynamic> projectData) async {
    final path = '/users/$uid/projects/service_projects';
    final documentReference = Firestore.instance.document(path);
    await documentReference.setData(projectData);
  }
}