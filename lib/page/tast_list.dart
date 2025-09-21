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

  Stream<List<Task>> tasksStreamForUser(User user) {
    Query query = FirebaseFirestore.instance
        .collection('tasks')
        //.where('userId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true);

    if (selectedPriorityType != 'Toutes') {
      query = query.where('priority', isEqualTo: selectedPriorityType);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Task.fromMap(data, id: doc.id);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Écoute l'état d'authentification
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = authSnapshot.data;
        if (user == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Vous devez vous connecter pour voir vos tâches."),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    // navigation vers écran de connexion
                  },
                  child: const Text("Se connecter"),
                ),
              ],
            ),
          );
        }

        return StreamBuilder<List<Task>>(
          stream: tasksStreamForUser(user),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              // Affichage détaillé de l'erreur pour debug
              final err = snapshot.error;
              String message = 'Erreur inconnue';
              // Si c'est une FirebaseException, on peut afficher son code
              if (err is FirebaseException) {
                message = 'Erreur Firebase (${err.code}) : ${err.message}';
              } else {
                message = err.toString();
              }

              // Log pour debug
              // ignore: avoid_print
              print('DEBUG: erreur tasksStream: $err (${err.runtimeType})');

              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Permission refusée ou erreur réseau.\n$message',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            final tasks = snapshot.data ?? [];
            if (tasks.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.event_note, size: 80, color: Colors.grey),
                    SizedBox(height: 16),
                    Text("Aucune tâche pour le moment"),
                  ],
                ),
              );
            }

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
      },
    );
  }
}
