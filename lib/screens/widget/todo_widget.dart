// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../edit_todo_screen.dart';
import '/viewmodel/db_viewmodel.dart';

class TodoWidget extends StatefulWidget {
  final String todoID;
  final String todoName;
  bool isDone = false;

  TodoWidget({
    Key? key,
    required this.todoID,
    required this.todoName,
    required this.isDone,
  }) : super(key: key);

  @override
  State<TodoWidget> createState() => _TodoWidgetState();
}

class _TodoWidgetState extends State<TodoWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 95,
      padding: const EdgeInsets.symmetric(
        horizontal: 6.0,
      ),
      child: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                widget.todoName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditTodoScreen(
                        todoID: widget.todoID,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.edit),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                widget.isDone.toString(),
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              Consumer<DatabaseViewModel>(
                builder: (context, database, _) => Checkbox(
                  value: widget.isDone,
                  onChanged: (val) {
                    setState(() {
                      widget.isDone = val ?? !widget.isDone;
                    });

                    database.updateTodoIsDone(
                      widget.todoID,
                      widget.isDone,
                    );
                  },
                ),
              )
            ],
          ),
          Consumer<DatabaseViewModel>(
            builder: (context, database, _) {
              return IconButton(
                onPressed: () {
                  database.deleteTodo(widget.todoID);
                },
                icon: const Icon(
                  Icons.delete,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
