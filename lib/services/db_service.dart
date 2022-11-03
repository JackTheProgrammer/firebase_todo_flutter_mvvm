import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import '../model/todo_model.dart';

class DatabaseService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final User? firebaseUser = FirebaseAuth.instance.currentUser;

  Future<void> addTodo(Todo newTodo) async {
    var todoID = const Uuid().v4();
    await _firebaseFirestore
        .collection("user")
        .doc(firebaseUser!.uid)
        .collection("todos")
        .doc(todoID)
        .set(
      {
        "todoName": newTodo.todoName,
        "isDone": newTodo.isDone,
      },
    );
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getToDos() async {
    return await _firebaseFirestore
        .collection("users")
        .doc(firebaseUser!.uid)
        .collection("todos")
        .get();
  }

  Future<void> deleteTodo(String todoID) async {
    await _firebaseFirestore
        .collection("users")
        .doc(firebaseUser!.uid)
        .collection("todos")
        .doc(todoID)
        .delete();
  }

  Future<void> updateTodoName(String todoID, String newTodoName) async {
    await _firebaseFirestore
        .collection("users")
        .doc(firebaseUser!.uid)
        .collection("todos")
        .doc(todoID)
        .update(
      {
        "todoName": newTodoName,
      },
    );
  }

  Future<void> updateTodoIsDone(String todoID, bool newIsDone) async {
    await _firebaseFirestore
        .collection("users")
        .doc(firebaseUser!.uid)
        .collection("todos")
        .doc(todoID)
        .update({
      "isDone": newIsDone,
    });
  }
}
