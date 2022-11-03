// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_todo_firebase/core/color_schema.dart';
import 'package:provider/provider.dart';

import '/viewmodel/db_viewmodel.dart';

class EditTodoScreen extends StatefulWidget {
  final String todoID;
  const EditTodoScreen({
    Key? key,
    required this.todoID,
  }) : super(key: key);

  @override
  State<EditTodoScreen> createState() => _EditTodoScreenState();
}

class _EditTodoScreenState extends State<EditTodoScreen> {
  String newTodoName = "";
  GlobalKey<FormState> formStateKey = GlobalKey<FormState>();
  final todoNameController = TextEditingController();

  @override
  void dispose() {
    todoNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    bool isNewDataSubmitted = newTodoName != "";
    bool isSubmissionDisabled =
        isNewDataSubmitted || (formStateKey.currentState!.validate() == true)
            ? false
            : true;

    return SafeArea(
      child: Scaffold(
        body: Consumer<DatabaseViewModel>(
          builder: (context, database, _) => ListView(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.045,
            ),
            children: [
              TextFormField(
                key: formStateKey,
                controller: todoNameController,
                validator: (value) {
                  if (value!.isEmpty || value == null) {
                    return "Value can't be left empty";
                  }

                  if (value == "") {
                    return "Empty spaces not allowed";
                  }

                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    newTodoName = value;
                  });
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
                height: size.height * 0.020,
              ),
              IgnorePointer(
                ignoring: isSubmissionDisabled,
                child: ElevatedButton.icon(
                  onPressed: () {
                    database.updateTodoName(
                      widget.todoID,
                      newTodoName,
                    );

                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.done),
                  label: const Text("Update"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSubmissionDisabled
                        ? kDisabledColor
                        : kElevatedButtonColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
