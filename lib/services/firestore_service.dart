import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:just_serve/app/home/models/project.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

   Future<void> setData(String path, Map<String, dynamic> data) async {
    final reference = Firestore.instance.document(path);
    await reference.setData(data);
  }

   Stream<List<Project>> collectionStream(String path) {
    final reference = Firestore.instance.collection(path);
    final snapshots = reference.snapshots();

    return snapshots.map(
          (snapshot) => snapshot.documents
          .map(
            (snapshot) => Project.fromMap(snapshot.data),
      )
          .toList(),
    );
  }
}