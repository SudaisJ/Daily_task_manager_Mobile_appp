import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/task_controller.dart';
import '../models/task_model.dart';
import 'add_task_screen.dart';
import 'task_detail_screen.dart';

import '../controllers/auth_controller.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = Provider.of<AuthController>(context, listen: false);
      if (auth.currentUser != null) {
        Provider.of<TaskController>(context, listen: false).fetchTasks(auth.currentUser!.id!);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskController = Provider.of<TaskController>(context);

    List<Task> pendingTasks = taskController.tasks.where((t) => t.isCompleted == 0).toList();
    List<Task> completedTasks = taskController.tasks.where((t) => t.isCompleted == 1).toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('My Tasks'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 4,
          labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: 'Pending (${pendingTasks.length})'),
            Tab(text: 'Completed (${completedTasks.length})'),
          ],
        ),
      ),
      drawer: _buildDrawer(context),
      body: taskController.isLoading
          ? Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildTaskList(pendingTasks, taskController, 'No pending tasks. Great job!'),
                _buildTaskList(completedTasks, taskController, 'No completed tasks yet.'),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskScreen()),
          );
        },
        icon: Icon(Icons.add),
        label: Text('New Task', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final auth = Provider.of<AuthController>(context);
    final user = auth.currentUser;

    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.purpleAccent],
              ),
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Colors.deepPurple),
                  ),
                  SizedBox(height: 15),
                  Text(user?.name ?? 'User', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  Text(user?.email ?? 'Stay organized!', style: TextStyle(color: Colors.white70, fontSize: 14)),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: Colors.deepPurple),
            title: Text('Home', style: TextStyle(fontSize: 16)),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text('Logout', style: TextStyle(fontSize: 16, color: Colors.red)),
            onTap: () {
              auth.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
          Spacer(),
          ListTile(
            leading: Icon(Icons.info, color: Colors.deepPurple),
            title: Text('About', style: TextStyle(fontSize: 16)),
            onTap: () {
              Navigator.pop(context);
              showAboutDialog(
                context: context,
                applicationName: 'Task Manager App',
                applicationVersion: '1.0.0',
                applicationIcon: Icon(Icons.check_circle, color: Colors.deepPurple, size: 40),
                children: [Text('A beautiful daily routine organizer built with Flutter.')]
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList(List<Task> tasks, TaskController controller, String emptyMessage) {
    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.task_alt, size: 80, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(emptyMessage, style: TextStyle(fontSize: 18, color: Colors.grey[600], fontWeight: FontWeight.w500)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.only(top: 10, bottom: 80, left: 10, right: 10),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        Task task = tasks[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TaskDetailScreen(task: task)),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                leading: Transform.scale(
                  scale: 1.2,
                  child: Checkbox(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    activeColor: Colors.deepPurple,
                    value: task.isCompleted == 1,
                    onChanged: (val) {
                      controller.toggleTaskCompletion(task);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(task.isCompleted == 1 ? 'Marked as pending' : 'Marked as completed'),
                          duration: Duration(seconds: 1),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      );
                    },
                  ),
                ),
                title: Text(
                  task.title,
                  style: TextStyle(
                    decoration: task.isCompleted == 1 ? TextDecoration.lineThrough : null,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getPriorityColor(task.priority).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: _getPriorityColor(task.priority).withOpacity(0.5))
                        ),
                        child: Text(
                          task.priority,
                          style: TextStyle(color: _getPriorityColor(task.priority), fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(task.dueDate ?? "No date", style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete_outline, color: Colors.red[300]),
                  onPressed: () {
                    _showDeleteDialog(context, task, controller);
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High': return Colors.red;
      case 'Medium': return Colors.orange;
      case 'Low': return Colors.green;
      default: return Colors.blue;
    }
  }

  void _showDeleteDialog(BuildContext context, Task task, TaskController controller) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 10),
            Text('Delete Task'),
          ],
        ),
        content: Text('Are you sure you want to delete "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              controller.deleteTask(task.id!, task.userId!);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}
