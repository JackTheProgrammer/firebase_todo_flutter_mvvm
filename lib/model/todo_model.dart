import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  final String todoName;
  final bool isDone;

  Todo({
    required this.todoName,
    required this.isDone,
  });

  factory Todo.fromDocSnapshot(DocumentSnapshot documentSnapshot) {
    return Todo(
      todoName: documentSnapshot['todoName'],
      isDone: documentSnapshot['isDone'],
    );
  }
}
