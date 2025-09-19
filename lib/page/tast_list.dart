import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:i_do/models/task_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:i_do/page/add_edit_task.dart';

class TaskList extends StatefulWidget {
  final List<Task> tasks;
  final Function(int, Task) onUpdateTask;
  final Function(int) onDeleteTask;

  const TaskList({
    super.key,
    required this.tasks,
    required this.onUpdateTask,
    required this.onDeleteTask,
  });

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  String selectedPriorityType = 'Toutes';
  final currentUser = FirebaseAuth.instance.currentUser;

  Stream<List<Task>> getTasksStream() {
    Query query = FirebaseFirestore.instance
        .collection('tasks')
        .where("userId", isEqualTo: currentUser?.uid)
        .orderBy("createdAt", descending: true);

    if (selectedPriorityType != "Toutes") {
      query = query.where("priority", isEqualTo: selectedPriorityType);
    }

    return query.snapshots().map(
          (snapshot) => snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Task.fromMap(data, id: doc.id);
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Task>>(
      stream: getTasksStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text("Erreur : ${snapshot.error}"),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.event_note,
                  size: 80,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text("Aucune tâche pour le moment"),
              ],
            ),
          );
        }

        final tasks = snapshot.data!;

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];

            return TaskCard(
              task: task,
              onEdit: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddEditTaskScreen(task: task),
                  ),
                );
              },
              onDelete: () async {
                await FirebaseFirestore.instance
                    .collection('tasks')
                    .doc(task.id)
                    .delete();
              },
            );
          },
        );
      },
    );
  }
}
