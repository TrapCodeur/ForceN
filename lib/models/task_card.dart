// Page qui comporte les classes qui representent les taches
// ajout de l'API firebase Firestore pour la base de donnée

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Task {
  Map<String, dynamic> toMap() {
    return {
      'priority': priority,
      'title': title,
      'description': description,
      'date': date,
      'time': time,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map, {String? id}) {
    return Task(
      id: id,
      priority: map['priority'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      date: map['date'] ?? '',
      time: map['time'] ?? '',
    );
  }

  final String? id;
  final String priority;
  final String title;
  final String description;
  final String time;
  final String date;

  Task({
    required this.id,
    required this.priority,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
  });

  Task copyWith({
    String? id,
    String? priority,
    String? title,
    String? description,
    String? time,
    String? date,
  }) {
    return Task(
      id: id ?? this.id,
      priority: priority ?? this.priority,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      time: time ?? this.time,
    );
  }
}

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    required this.onEdit,
    required this.onDelete,
  });

  final Task task;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final priorityColor = task.priority == "Haute"
        ? Colors.red
        : task.priority == "Moyenne"
        ? Colors.orange
        : Colors.green;
        
    return Container(
      padding: EdgeInsets.all(20),
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: priorityColor, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.circle, size: 10, color: priorityColor),
                  const SizedBox(width: 8),
                  Text(
                    "${task.priority.toUpperCase()} PRIORITÉ",
                    style: GoogleFonts.inter(
                      color: priorityColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 175),
                  Container(
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: priorityColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: PopupMenuButton(
                      icon: Icon(Icons.more_vert, color: priorityColor),
                      onSelected: (value) {
                        if (value == "edit") {
                          onEdit();
                        } else if (value == "delete") {
                          onDelete();
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: "edit",
                          child: Text("Modifier"),
                        ),
                        const PopupMenuItem(
                          value: "delete",
                          child: Text("Supprimer"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Text(
                task.title,
                style: GoogleFonts.interTight(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 4),
              Text(
                task.description,
                style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[700]),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(
                    task.time,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  SizedBox(width: 16),
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(
                    task.date,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
