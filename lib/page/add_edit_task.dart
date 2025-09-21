// Page d'ajout de nouvelle taches

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:i_do/models/task_card.dart';

class AddEditTaskScreen extends StatefulWidget {
  final Task? task;
  const AddEditTaskScreen({super.key, required this.task});

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _formkey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  String _priority = "Haute";
  String _time = "10:00";
  String _date = "Aujourd'hui ou le 26/01/2025";

  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? "");
    _descriptionController = TextEditingController(
      text: widget.task?.description ?? "",
    );
    _priority = widget.task?.priority ?? "Haute";
    _date = widget.task?.date ?? "10:00";
    _time = widget.task?.time ?? "Aujourd'hui ou le 26/01/2025";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.task == null ? "Ajouter une tache" : "Modifier la tache",
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  label: Text("Titre"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veillez entrer un titre";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  label: Text("Description"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veillez entrer une description";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField(
                value: _priority,
                decoration: InputDecoration(
                  label: Text("Priorité"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                items: [
                  DropdownMenuItem(
                    value: "Haute",
                    child: Text("Haute priorité"),
                  ),
                  DropdownMenuItem(
                    value: "Moyenne",
                    child: Text("Moyenne priorité"),
                  ),
                  DropdownMenuItem(
                    value: "Basse",
                    child: Text("Basse priorité"),
                  ),
                ],
                onChanged: (value) => setState(() => _priority = value!),
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _date,
                decoration: InputDecoration(
                  label: Text("Heure (ex: 10:15)"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onChanged: (value) => _date = value,
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _time,
                decoration: InputDecoration(
                  label: Text("date (ex: Aujourd'hui ou le 26/01/2025)"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onChanged: (value) => _time = value,
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formkey.currentState!.validate()) {
                      final newTask = Task(
                        id: widget.task?.id,
                        title: _titleController.text,
                        description: _descriptionController.text,
                        priority: _priority,
                        date: _date,
                        time: _time,

                      );
                      if (widget.task == null) {
                        await FirebaseFirestore.instance.collection('tasks').add({
                          ...newTask.toMap(),
                          'createdAt': FieldValue.serverTimestamp(),
                          'userId': user?.uid,

                        });
                      } else {
                        if (newTask.id == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Impossible de mettre à jour"),
                            ),
                          );
                          return;
                        }
                        await FirebaseFirestore.instance
                            .collection('tasks')
                            .doc(widget.task!.id)
                            .update(newTask.toMap());
                      }
                      Navigator.pop(context);
                      FocusScope.of(context).unfocus();
                    }
                  },
                  child: Text(
                    widget.task == null ? "Enregistrer" : "Mettre à jour",
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
