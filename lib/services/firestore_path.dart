/*
This class defines all the possible read/write locations from the FirebaseFirestore database.
In future, any new path can be added here.
This class work together with FirestoreService and FirestoreDatabase.
 */

class FirestorePath {

  static String todo(String todoId) => 'todos/$todoId';
  static String todos() => 'todos';
  
  static String song(String songId) => 'songs/$songId';
  static String songs() => 'songs';

  static String note(String noteId) => 'notes/$noteId';
  static String notes() => 'notes';

  static String user(String uid) => 'users/$uid';
  static String users() => 'users';

  static String post(String postId) => 'posts/$postId';
  static String posts() => 'posts';

  static String story(String storyId) => 'stories/$storyId';
  static String stories() => 'stories';
}