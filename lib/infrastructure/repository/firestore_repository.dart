// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuple/tuple.dart';

class FirestoreRepository {
  Future<DocumentReference> setData({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.set(data);
    return reference;
  }

  Future<void> updateData({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.update(data);
  }

  Future<void> deleteData({required String path}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.delete();
  }

  Future<T> documentFuture<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String documentID, {DocumentReference? ref}) builder,
    required Function(dynamic error) onError,
  }) async {
    final reference = await FirebaseFirestore.instance.doc(path).get().onError((error, stackTrace) => onError(error));
    return builder(reference.data() ?? {}, reference.id, ref: reference.reference);
  }

  Stream<Tuple4> collectionGroupStreamWithOptions<T>({
    required String path,
    required Function(Map<String, dynamic>? data, DocumentReference ref) builder,
    required Function(Map<String, dynamic>? data, DocumentReference ref) changedBuilder,
    required Function(Map<String, dynamic>? data, DocumentReference ref) removedBuilder,
    Query Function(Query query)? queryBuilder,
    int Function(T lhs, T rhs)? sort,
  }) {
    Query query = FirebaseFirestore.instance.collectionGroup(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final snapshots = query.snapshots();
    snapshots.handleError((onError) {
      //print(onError);
    });

    return snapshots.map((snapshot) {
      List<DocumentSnapshot> newList = [];
      List<DocumentSnapshot> modifiedList = [];
      List<DocumentSnapshot> removedList = [];
      for (var doc in snapshot.docChanges) {
        final docSnapshot = doc.doc;
        switch (doc.type) {
          case DocumentChangeType.added:
            newList.add(docSnapshot);
            break;
          case DocumentChangeType.modified:
            modifiedList.add(docSnapshot);
            break;
          case DocumentChangeType.removed:
            removedList.add(docSnapshot);
            break;
        }
      }
      var m = modifiedList.map((e) => changedBuilder((e.data() ?? {}) as Map<String, dynamic>, e.reference)).where((value) => value != null).toList();
      var r = removedList.map((e) => removedBuilder((e.data() ?? {}) as Map<String, dynamic>, e.reference)).where((value) => value != null).toList();
      var n = newList.map((e) => builder((e.data() ?? {}) as Map<String, dynamic>, e.reference)).where((value) => value != null).toList();
      return Tuple4(n, m, r, snapshot.docs.isNotEmpty ? snapshot.docs.last : null);
    });
  }

  Stream<T> documentStream<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String documentID, {DocumentReference? ref}) builder,
    required Function(dynamic error) onError,
  }) {
    final reference = FirebaseFirestore.instance.doc(path);
    final snapshots = reference.snapshots().handleError(onError);
    return snapshots.map((snapshot) {
      return builder(snapshot.data() ?? {}, snapshot.id, ref: snapshot.reference);
    });
  }

}
