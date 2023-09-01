import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oneui/bloc/auth_provider.dart';
import 'package:oneui/pages/todo/widget/radio_widget.dart';

import '../../../models/todo.dart';

class AddTaskModal extends HookConsumerWidget {
  const AddTaskModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(firebaseDBProvider);
    final titleEditingController = useTextEditingController();
    final descriptionEditingController = useTextEditingController();
    final categoryEditingController = useTextEditingController();

    final selectedValue = useState("");

    final onSubmit = useCallback((){

      Todo todo = Todo(
        title: titleEditingController.text,
        description: descriptionEditingController.text,
        category: selectedValue.value,
        isDone: false,
        createdAt: Timestamp.now(),
      );
      db.addTodo(todo).then((value) => Navigator.pop(context));

    }, [db, titleEditingController, descriptionEditingController, categoryEditingController]);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: ListView(
                children: [
                const SizedBox(
                    width: double.infinity,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "New Task",
                        style:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    )),
                const Divider(),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Title task",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 8,
                ),
    
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200],
                    ),
                    child: TextField(
                      controller: titleEditingController,
                      minLines: 1,
                      maxLines: 2,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter title task",
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          contentPadding: const EdgeInsets.all(10)),
                    )),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Description",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 8,
                ),
    
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200],
                    ),
                    child: TextField(
                      controller: descriptionEditingController,
                      maxLines: 5,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Task Details",
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          contentPadding: const EdgeInsets.all(10)),
                    )),
                const SizedBox(
                  height: 20,
                ),
    
                const Text(
                  "Category",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
    
                Row(children: [
                  Expanded(
                    child: RadioWidget(
                        titleRadio: "Home",
                        categColor: Colors.green,
                        groupValue: selectedValue.value,
                        onChanged: (val) {
                          selectedValue.value = val!;
                        }),
                  ),
                  Expanded(
                      child: RadioWidget(
                          titleRadio: "Office",
                          categColor: Colors.pink,
                          groupValue: selectedValue.value,
                          onChanged: (val) {
                            selectedValue.value = val!;
                          }))
                ]),
    
                // create button
                // cancel button
    
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.grey,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onSubmit,
                        child: const Text("Create Task"),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.deepOrange,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ),
                  ],
                )
              ]))),
    );
  }
}
