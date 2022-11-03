import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/model/todo_model.dart';
import '/services/db_service.dart';

class DatabaseViewModel extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();

  void addData(Todo newTodo) async {
    await _databaseService.addTodo(newTodo);
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getTodos() async {
    return await _databaseService.getToDos();
  }

  void deleteTodo(String todoID) async {
    await _databaseService.deleteTodo(todoID);
  }

  void updateTodoName(String todoID, String newTodoName) async {
    await _databaseService.updateTodoName(todoID, newTodoName);
  }

  void updateTodoIsDone(String todoID, bool newIsDone) async {
    await _databaseService.updateTodoIsDone(todoID, newIsDone);
  }
}
