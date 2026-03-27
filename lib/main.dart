// lib/main.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('tasksBox');

  runApp(TaskManagerApp());
}

class TaskManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: TaskHomePage(),
    );
  }
}

class TaskHomePage extends StatefulWidget {
  @override
  _TaskHomePageState createState() => _TaskHomePageState();
}

class _TaskHomePageState extends State<TaskHomePage> {
  var taskBox = Hive.box('tasksBox');
  List<Map<String, dynamic>> tasks = [];

  @override
void initState() {
  super.initState();
  loadTasks();
}

void loadTasks() {
  final data = taskBox.get('tasks', defaultValue: []);
  tasks = List<Map<String, dynamic>>.from(data);
}

void saveTasks() {
  taskBox.put('tasks', tasks);
}

  String searchQuery = '';
  String selectedFilter = 'All';

  List<String> filterOptions = ['All', 'To-Do', 'In Progress', 'Done'];

  @override
  Widget build(BuildContext context) {
    final filteredTasks = tasks.where((task) {
      final matchesSearch = task['title']
          .toLowerCase()
          .contains(searchQuery.toLowerCase());

      final matchesFilter =
          selectedFilter == 'All' || task['status'] == selectedFilter;

      return matchesSearch && matchesFilter;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Task Manager"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // SEARCH
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search tasks...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (val) {
                setState(() => searchQuery = val);
              },
            ),
          ),

          // FILTER
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: DropdownButton<String>(
              value: selectedFilter,
              isExpanded: true,
              items: filterOptions.map((f) {
                return DropdownMenuItem(value: f, child: Text(f));
              }).toList(),
              onChanged: (val) {
                setState(() => selectedFilter = val!);
              },
            ),
          ),

          // TASK LIST
          Expanded(
            child: filteredTasks.isEmpty
                ? Center(child: Text("No tasks yet"))
                : ListView.builder(
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];

                      bool isBlocked = false;

                      if (task['blockedBy'] != null) {
                        final blockedTask = tasks.firstWhere(
                          (t) => t['title'] == task['blockedBy'],
                          orElse: () => {},
                        );

                        if (blockedTask.isNotEmpty &&
                            blockedTask['status'] != 'Done') {
                          isBlocked = true;
                        }
                      }

                      return Card(
                        color:
                            isBlocked ? Colors.grey[300] : Colors.white,
                        margin: EdgeInsets.all(8),
                        child: ListTile(
                          onTap: () => _showEditDialog(task),
                          title: Text(task['title']),
                          subtitle: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(task['description']),
                              Text(
                                "Due: ${DateTime.parse(task['dueDate']).toString().split(' ')[0]}",
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                 task['status'],
                                 style: TextStyle(
                                    color: task['status'] == 'Done'
                                    ? Colors.green
                                    : task['status'] == 'In Progress'
                                      ? Colors.orange
                                      : Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                   ),
                              IconButton(
                                icon: Icon(Icons.delete,
                                    color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    tasks.remove(task);
                                    saveTasks();
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: Icon(Icons.add),
      ),
    );
  }

  // ADD TASK
  void _showAddDialog() {
  String title = ''; 
  String description = '';
   String status = 'To-Do';
    DateTime? selectedDate; String? 
    blockedBy; bool
     isLoading = false;
  


    List<String> statuses = ['To-Do', 'In Progress', 'Done'];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text("Add Task"),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(hintText: 'Title'),
                      onChanged: (val) => title = val,
                    ),
                    TextField(
                      decoration:
                          InputDecoration(hintText: 'Description'),
                      onChanged: (val) => description = val,
                    ),

                    DropdownButton<String>(
                      value: status,
                      isExpanded: true,
                      items: statuses.map((s) {
                        return DropdownMenuItem(
                            value: s, child: Text(s));
                      }).toList(),
                      onChanged: (val) {
                        setStateDialog(() => status = val!);
                      },
                    ),

                    ElevatedButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setStateDialog(() => selectedDate = picked);
                        }
                      },
                      child: Text(selectedDate == null
                          ? "Select Due Date"
                          : selectedDate
                              .toString()
                              .split(' ')[0]),
                    ),

                    DropdownButton<String>(
                      value: blockedBy,
                      hint: Text("Blocked By"),
                      isExpanded: true,
                      items: tasks.map<DropdownMenuItem<String>>((t) {
                        return DropdownMenuItem<String>(
                          value: t['title'].toString(),
                          child: Text(t['title'].toString()),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setStateDialog(() => blockedBy = val);
                      },
                    ),
                  ],
                ),
              ),

              actions: [
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (title.isEmpty) return;

                          setStateDialog(() => isLoading = true);

                          await Future.delayed(Duration(seconds: 2));

                          setState(() {
                            tasks.add({
                              
                              "title": title,
                              "description": description,
                              "status": status,
                               "dueDate": (selectedDate ?? DateTime.now()).toIso8601String(),
                              "blockedBy": blockedBy,
                            });
                            saveTasks();

                          });

                          Navigator.pop(context);
                        },
                  child: isLoading
                      ? CircularProgressIndicator(
                          color: Colors.white)
                      : Text("Add"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // EDIT TASK
  void _showEditDialog(Map<String, dynamic> task) {
    String title = task['title'];
    String description = task['description'];
    String status = task['status'];
    DateTime selectedDate = DateTime.parse(task['dueDate']);
    String? blockedBy = task['blockedBy'];

    List<String> statuses = ['To-Do', 'In Progress', 'Done'];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text("Edit Task"),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller:
                          TextEditingController(text: title),
                      onChanged: (val) => title = val,
                    ),
                    TextField(
                      controller:
                          TextEditingController(text: description),
                      onChanged: (val) => description = val,
                    ),

                    DropdownButton<String>(
                      value: status,
                      isExpanded: true,
                      items: statuses.map((s) {
                        return DropdownMenuItem(
                            value: s, child: Text(s));
                      }).toList(),
                      onChanged: (val) {
                        setStateDialog(() => status = val!);
                      },
                    ),

                    ElevatedButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setStateDialog(() => selectedDate = picked);
                        }
                      },
                      child: Text(selectedDate
                          .toString()
                          .split(' ')[0]),
                    ),

                    DropdownButton<String>(
                      value: blockedBy,
                      hint: Text("Blocked By"),
                      isExpanded: true,
                      items: tasks.map<DropdownMenuItem<String>>((t) {
                        return DropdownMenuItem<String>(
                          value: t['title'].toString(),
                          child: Text(t['title'].toString()),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setStateDialog(() => blockedBy = val);
                      },
                    ),
                  ],
                ),
              ),

              actions: [
                ElevatedButton(
                  onPressed: () async {
                    await Future.delayed(Duration(seconds: 2));

                    setState(() {
                      task['title'] = title;
                      task['description'] = description;
                      task['status'] = status;
                      task['dueDate'] = selectedDate;
                      task['blockedBy'] = blockedBy;
                      saveTasks();

                    });

                    Navigator.pop(context);
                  },
                  child: Text("Update"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}