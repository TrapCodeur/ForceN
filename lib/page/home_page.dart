import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:i_do/models/task_card.dart';
import 'package:i_do/page/add_edit_task.dart';
import 'package:i_do/page/profile.dart';
import 'package:i_do/page/tast_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedPriorityType = 'Toutes';
  List<Task> tasks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Image.asset(
                      'assets/images/logo2.png',
                      width: 40,
                      height: 40,
                    ),
                  ),
                  SizedBox(width: 250),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey,
                        ),
                        //padding: EdgeInsets.only(left: 300),
                        child: Builder(
                          builder: (context) => IconButton(
                            icon: const Icon(
                              Icons.person,
                              //color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfilePage(),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: const Color.fromARGB(172, 249, 248, 248),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            "Mes Taches",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Organisez votre journée",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 24.0, left: 40),
              child: Row(
                children: [
                  Text(
                    "Aujourd'hui",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 19, 19, 19),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.0,
                    ),
                  ),
                  SizedBox(width: 100),
                  SizedBox(
                    width: 150,
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        hintText: "Priorité",
                        labelStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 1,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'Haute',
                          child: Text(
                            'Haute',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'Moyenne',
                          child: Text(
                            'Moyenne',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'Basse',
                          child: Text(
                            'Basse',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'Toutes',
                          child: Text(
                            'Toutes',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                      value: selectedPriorityType,
                      onChanged: (value) {
                        setState(() {
                          selectedPriorityType = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: TaskList(
              tasks: tasks,
              onUpdateTask: (index, updatedTask) {
                setState(() {
                  tasks[index] = updatedTask;
                });
              },
              onDeleteTask: (index) {
                setState(() {
                  tasks.removeAt(index);
                });
              },
            ),
          ),
          SizedBox(
            child: Container(
              color: const Color.fromARGB(172, 249, 248, 248),
              margin: EdgeInsets.only(left: 270),
              child: FloatingActionButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(28)),
                ),
                backgroundColor: Colors.blue,
                elevation: 4,
                onPressed: () async {
                  final newTask = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddEditTaskScreen(task: null),
                    ),
                  );
                  if (newTask != null && newTask is Task) {
                    setState(() {
                      tasks.add(newTask);
                    });
                  }
                },
                child: Icon(Icons.add, color: Colors.white, size: 28),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
