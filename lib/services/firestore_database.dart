import 'package:oneui/models/models.dart';
import 'package:uuid/uuid.dart';

import '../models/todo.dart';
import 'firestore_path.dart';
import 'firestore_service.dart';

class FirestoreDatabase{
  FirestoreDatabase({required this.uid});

  final String uid;

  final _firestoreService = FirestoreService.instance;

  // Method to create / update notes

  Future<void> addJournal(Journal journal) async => await _firestoreService.set(
    path: FirestorePath.note(journal.documentId ?? const Uuid().v4()),
    data: journal.toMap(),
  );

  Future<void> addPost(Post post) async => await _firestoreService.set(
    path: FirestorePath.post(post.documentId?? const Uuid().v4()),
    data: post.toMap(),
  );

    Future<void> addUser(UserModel user) async => await _firestoreService.set(
    path: FirestorePath.user(user.uid),
    data: user.toMap(),
  );


  Future<void> addSong(Song song) async => await _firestoreService.set(
    path: FirestorePath.song(song.documentId?? const Uuid().v4()),
    data: song.toMap(),
  );

  Future<void> addTodo(Todo task)async => await _firestoreService.set(
    path: FirestorePath.todo(task.documentId?? const Uuid().v4()),
    data: task.toMap(),
  );

  Future<void> deleteTodo (String documentId) async => await _firestoreService.deleteData(
    path: FirestorePath.todo(documentId),
  );

  Future<void> deletePost(String documentId) async => await _firestoreService.deleteData(
    path: FirestorePath.post(documentId),
  );

  Future<void> addStory(Story story) async => await _firestoreService.set(
    path: FirestorePath.story(story.documentId?? const Uuid().v4()),
    data: story.toMap(),
  );


   Stream<List<Future<Song>>> songsStream() => _firestoreService.collectionStream(
    path: FirestorePath.songs(),
    builder: (data, documentId) => Song.fromMap(data, documentId),
  );

  Stream<List<Future<Story>>> storiesStream() => _firestoreService.collectionStream(
    path: FirestorePath.stories(),
    builder: (data, documentId) => Story.fromMap(data, documentId),
  );

  // postsStream
  Stream<List<Future<Post>>> postsStream() => _firestoreService.collectionStream(
    path: FirestorePath.posts(),
    queryBuilder: (query) => query.orderBy("createdAt", descending: true),
    builder: (data, documentId) => Post.fromMap(data, documentId),
  );

  // documentStream
  Stream<Map<String, dynamic>> getCurrentState() => _firestoreService.documentStream(
    path: FirestorePath.user(uid),
    builder: (data, documentId){
      return {
        "currentGoal": data['state']['currentGoal'],
        "finalGoal": data['state']['finalGoal'],
        "startDate": data['state']['startDate'],
        "victoryDays": data['state']['victoryDays'],
        "rewiredPercentage": data['state']['rewiredPercentage'],
      };
    }
  );


  // Stream to get note given the id

  Stream<List<Future<Journal>>> noteStream() => _firestoreService.collectionStream(
    path: FirestorePath.notes(),
    queryBuilder: (query) => query.where("space", isEqualTo:"private").orderBy("pinned", descending:true).orderBy('position', descending:false).orderBy("createdAt", descending: true),
    builder: (data, documentId) => Journal.fromMap(data, documentId),
  );

    Stream<List<Future<Journal>>> notePublicStream() => _firestoreService.collectionStream(
    path: FirestorePath.notes(),
    queryBuilder: (query) => query.where("space", isEqualTo: "public"),
    builder: (data, documentId) => Journal.fromMap(data, documentId),
  );


  // Stream to get todos
    Stream<List<Future<Todo>>> todoStreamIncomplete() => _firestoreService.collectionStream(
    path: FirestorePath.todos(),
    queryBuilder: (query) => query.where("isDone", isEqualTo: false),
    builder: (data, documentId) => Todo.fromMap(data, documentId),
  );

    // Stream to get todos
    Stream<List<Future<Todo>>> todoStreamComplete() => _firestoreService.collectionStream(
    path: FirestorePath.todos(),
    queryBuilder: (query) => query.where("isDone", isEqualTo: true),
    builder: (data, documentId) => Todo.fromMap(data, documentId),
  );


  // bulk update
  Future<void> bulkSetNotes(List<Journal> journals){
    List<Future<void>> futures = [];
    for(var journal in journals){
      futures.add(addJournal(journal));
    }
    return Future.wait(futures);
  }

  Future<void> updateUser(Map<String, dynamic> content){
    return _firestoreService.set(
      path: FirestorePath.user(uid),
      data: content,
      merge: true);
  }

  Future<void> bulkSetPosts(List<Post> posts){
    List<Future<void>> futures = [];
    for(var post in posts){
      futures.add(addPost(post));
    }
    return Future.wait(futures);
  }


  Future<void> bulkSetStories(List<Story> stories){
    List<Future<void>> futures = [];
    for(var story in stories){

      
      futures.add(addStory(story));
    }
    return Future.wait(futures);
  }
}