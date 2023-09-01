import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../models/post_model.dart';

class FirestoreService {
  FirestoreService._();

  static final instance = FirestoreService._();

  Future<String> get uid => Future.value(const Uuid().v4());

  Future<void> set({
    required String path,
    required Map<String, dynamic> data,
    bool merge = false,
  }) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('$path: $data');
    await reference.set(data, SetOptions(merge: merge));
  }

  Future<void> bulkSet({
    required String path,
    required List<Map<String, dynamic>> datas,
    bool merge = false,
  }) async {
    for (final data in datas) {
      final reference = FirebaseFirestore.instance.collection(path).doc();
      print('reference: $reference');
      await reference.set(data);
    }
  }

  Future<void> deleteData({required String path}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('delete: $path');
    await reference.delete();
  }

  Stream<List<Future<T>>> collectionStream<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String documentID) builder,
    Query Function(Query query)? queryBuilder,
    int Function(T lhs, T rhs)? sort,
  }) {
    Query query = FirebaseFirestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final Stream<QuerySnapshot> snapshots = query.snapshots();

    return snapshots.map((snapshot) {
      final result = snapshot.docs.map((snapshot) async {
        final data = snapshot.data() as Map<String, dynamic>;

        // check if user in data keys
        if (data.containsKey('user')) {
          // get user data from firebase
          final userId = data['user'];
          return FirebaseFirestore.instance
              .doc('users/$userId')
              .get()
              .then((value) {
            final userData = value.data() as Map<String, dynamic>;
            // merge user data with post data
            data['user'] = userData;
            return builder(data, snapshot.id);
          });
        }
        return builder(data, snapshot.id);
      }).toList();

      return result;
    });
  }

  Stream<T> documentStream<T>({
    required String path,
    required T builder(Map<String, dynamic> data, String documentID),
  }) {
    final DocumentReference reference = FirebaseFirestore.instance.doc(path);
    final Stream<DocumentSnapshot> snapshots = reference.snapshots();
    return snapshots.map((snapshot) =>
        builder(snapshot.data() as Map<String, dynamic>, snapshot.id));
  }
}
