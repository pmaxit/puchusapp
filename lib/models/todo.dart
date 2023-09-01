import 'package:cloud_firestore/cloud_firestore.dart';

class Todo{
  String? documentId;
  final String title;
  final String description;
  final bool isDone;
  final String category;
  final Timestamp createdAt;

  Todo({
    required this.title,
    required this.description,
    this.isDone = false,
    required this.category,
    this.documentId,
    required this.createdAt,
    
  });

  Todo copyWith({
    String? title,
    String? description,
    bool? isDone,
    String? category,
    Timestamp? createdAt,
    String? documentId,
  }){
    return Todo(
      category: category ?? this.category,
      title: title ?? this.title,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt ?? this.createdAt,
      documentId: documentId ?? this.documentId,
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'title': title,
      'description': description,
      'isDone': isDone,
      'category': category,
      'createdAt': createdAt,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map, String documentId){
    print("todo from map $map");
    return Todo(
      category: map['category'],
      title: map['title'],
      description: map['description'],
      isDone: map['isDone'],
      createdAt: map['createdAt'],
      documentId: documentId,

    );
  }
}