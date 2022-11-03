import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_firebase/core/color_schema.dart';
import 'package:flutter_todo_firebase/viewmodel/auth_viewmodel.dart';
import 'package:provider/provider.dart';

import '/core/greetings.dart';
import '/model/todo_model.dart';
import '/screens/widget/todo_widget.dart';
import '/viewmodel/db_viewmodel.dart';

class TodosScreen extends StatefulWidget {
  const TodosScreen({Key? key}) : super(key: key);

  @override
  State<TodosScreen> createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen> {
  GlobalKey<FormState> formStateKey = GlobalKey<FormState>();
  final _newTodoNameController = TextEditingController();

  String newTodoName = "";

  @override
  void dispose() {
    _newTodoNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    bool isNameSupplied = newTodoName == "";
    bool isDisabled =
        isNameSupplied && formStateKey.currentState!.validate() == true
            ? false
            : true;

    return SafeArea(
      child: Consumer<AuthViewModel>(
        builder: (context, authVM, _) {
          return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  onPressed: authVM.signOut,
                  icon: const Icon(
                    Icons.logout,
                  ),
                ),
              ],
            ),
            body: ListView(
              children: [
                SizedBox(
                  height: size.height * 0.010,
                ),
                Text(
                  "\t\t${greeting()}, ${authVM.getUserName()}",
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.020,
                ),
                Consumer<DatabaseViewModel>(
                  builder: (context, database, _) =>
                      FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    future: database.getTodos(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: Text("No todos"),
                        );
                      }
                      return ListView(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.0225,
                        ),
                        children: snapshot.data!.docs.map(
                          (queryDocumentSnapshot) {
                            var todo =
                                Todo.fromDocSnapshot(queryDocumentSnapshot);
                            return TodoWidget(
                              todoID: queryDocumentSnapshot.id,
                              todoName: todo.todoName,
                              isDone: todo.isDone,
                            );
                          },
                        ).toList(),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: size.height * 0.045,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.045,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => Consumer<DatabaseViewModel>(
                          builder: (context, database, _) => Form(
                            key: formStateKey,
                            child: ListView(
                              padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.0225,
                              ),
                              children: [
                                TextFormField(
                                  controller: _newTodoNameController,
                                  onChanged: (value) {
                                    setState(() {
                                      newTodoName = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == "" || value!.isEmpty) {
                                      return "Todo name required";
                                    }

                                    if (value.length < 20) {
                                      return "The name should be meaningful";
                                    }

                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Todo name",
                                    filled: true,
                                    fillColor: kFillingColor,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: size.height * 0.018,
                                ),
                                IgnorePointer(
                                  ignoring: isDisabled,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      var newTodo = Todo(
                                        todoName: newTodoName,
                                        isDone: false,
                                      );
                                      database.addData(newTodo);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isDisabled
                                          ? kDisabledColor
                                          : kElevatedButtonColor,
                                    ),
                                    child: const Text(
                                      "Create todo",
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    child: const Text("Add a todo"),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
