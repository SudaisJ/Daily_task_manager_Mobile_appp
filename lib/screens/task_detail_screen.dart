import 'package:flutter/material.dart';
import '../models/task_model.dart';
import 'edit_task_screen.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  TaskDetailScreen({required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Task Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit_note, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditTaskScreen(task: task),
                ),
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: Offset(0, 4))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.deepPurple[800]),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        _buildBadge(Icons.flag, task.priority, _getPriorityColor(task.priority)),
                        SizedBox(width: 12),
                        _buildBadge(
                          task.isCompleted == 1 ? Icons.check_circle : Icons.pending,
                          task.isCompleted == 1 ? 'Completed' : 'Pending',
                          task.isCompleted == 1 ? Colors.green : Colors.orange,
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Icon(Icons.event_note, color: Colors.grey[600]),
                        SizedBox(width: 8),
                        Text(
                          'Due: ${task.dueDate ?? "Not set"}',
                          style: TextStyle(fontSize: 16, color: Colors.grey[700], fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Description',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple[800]),
              ),
              SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Text(
                  task.description.isEmpty ? 'No description provided.' : task.description,
                  style: TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(IconData icon, String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          SizedBox(width: 6),
          Text(text, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
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
}
