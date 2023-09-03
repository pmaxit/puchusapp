import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:oneui/bloc/auth_provider.dart';

import '../../models/todo.dart';
import 'widget/task_modal.dart';

class TodoPage extends HookConsumerWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double maxHeight = 220;
    double minHeight = 80;
    final ScrollController scrollController = useScrollController();

    return Scaffold(
        body: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: scrollController,
            slivers: [
          SliverAppBar(
            pinned: true,
            floating: false,
            automaticallyImplyLeading: true,
            primary: true,
            collapsedHeight: minHeight,
            title: titleWidget(),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            backgroundColor: Colors.deepOrange,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
          ),
          body(context, ref)
        ]));
  }

  Widget body(BuildContext context, WidgetRef ref) {
    final todosIncomplete = ref.watch(firebaseDBProvider).todoStreamIncomplete();
    final todosComplete = ref.watch(firebaseDBProvider).todoStreamComplete();
    final tabController = useTabController(initialLength: 2);

    return SliverList(
        delegate: SliverChildListDelegate([
      const SizedBox(
        height: 20,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   const Text(
                    // get todays date
                    "Today\'s Tasks",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                   Text(
                      DateFormat("MMMM d yyy").format(DateTime.now()),

                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () =>
                    // show modal sheet
                    showModalBottomSheet(
                      isScrollControlled: true,
                        context: context,
                        builder: (context) => const AddTaskModal()),
                child: const Text(
                  'Add Task',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ]),
      ),
      const SizedBox(
        height: 20,
      ),
      
       Column(
         children: [
           TabBar(
            controller: tabController,
            tabs: [
               Tab(
            text: 'Urgent',
               ),
               Tab(
            text: 'Completed',
               ),
             ],
             indicatorColor: Colors.deepOrange,
             labelColor: Colors.deepOrange,
             unselectedLabelColor: Colors.grey,
                padding: EdgeInsets.zero,
   indicatorPadding: EdgeInsets.zero,
   labelPadding: EdgeInsets.zero,
             ),

    // TabbarView
    SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: TabBarView(
        controller: tabController,
        children: [todosIncomplete, todosComplete].map((todos) => StreamBuilder(
              stream: todos,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return todoListWidget(snapshot);
                } else {
                  return const SizedBox();
                }
              },
        )).toList()
        
      ),
    ),
         ],
       )]));
        
    
  }

  Widget todoListWidget(snapshot){
    return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return FutureBuilder(
                    future: snapshot.data![index],
                    builder: (context, snapshot) {
                      if(snapshot.hasError) {
                        return  SizedBox(
                          child: Center(
                            child: Text(snapshot.error.toString()),
                          ),
                        );
                      }
                      if (snapshot.hasData) {
                        return TodoCard(todo: snapshot.data as Todo);
                      } else {
                        return const SizedBox();
                      }
                    });
              });
  }

  Widget titleWidget() {
    return const Text(
      'Todos',
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
    );
  }
}

class TodoCard extends HookConsumerWidget {
  final Todo todo;
  const TodoCard({
    super.key,
    required this.todo,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 20, vertical: 0),
      child: Container(
        
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(10),
            ),
        child: ListTile(
          tileColor: Colors.white,
          // no border
          
          leading: Checkbox(
            value: todo.isDone,
            onChanged: (value) {
              // update todo
              Todo newTodo = todo.copyWith(
                  isDone: value!,
                  documentId: todo.documentId);
              ref
                  .read(firebaseDBProvider)
                  .addTodo(
                       newTodo,);
            },
          ),
          title: Text(
            todo.title,
            style:  TextStyle(
                decoration: todo.isDone
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            todo.description,
            
            style:  TextStyle(
                decoration: todo.isDone
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.normal),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // delete todo
              ref
                  .read(firebaseDBProvider)
                  .deleteTodo(
                      todo.documentId!);
            },
          ),
        ),
      ),
    );
  }
}
