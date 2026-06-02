import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../controllers/task_controller.dart';
import '../models/task_model.dart';
import '../controllers/auth_controller.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  String _priority = 'Medium';
  DateTime? _selectedDate;

  final List<String> _priorities = ['High', 'Medium', 'Low'];

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.deepPurple,
            ),
          ),
          child: child!,
        );
      },
    ).then((pickedDate) {
      if (pickedDate == null) return;
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final auth = Provider.of<AuthController>(context, listen: false);
      final newTask = Task(
        userId: auth.currentUser!.id,
        title: _title,
        description: _description,
        priority: _priority,
        dueDate: _selectedDate != null ? DateFormat('yyyy-MM-dd').format(_selectedDate!) : null,
      );

      Provider.of<TaskController>(context, listen: false).addTask(newTask);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Task added successfully!'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: Colors.green,
        ),
      );
      
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(title: Text('New Task')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                'What needs to be done?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Task Title',
                  prefixIcon: Icon(Icons.title, color: Colors.deepPurple),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) => _title = value!,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description (Optional)',
                  prefixIcon: Icon(Icons.description, color: Colors.deepPurple),
                ),
                maxLines: 3,
                onSaved: (value) => _description = value ?? '',
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _priority,
                decoration: InputDecoration(
                  labelText: 'Priority',
                  prefixIcon: Icon(Icons.flag, color: Colors.deepPurple),
                ),
                items: _priorities.map((String priority) {
                  return DropdownMenuItem<String>(
                    value: priority,
                    child: Text(priority),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _priority = newValue!;
                  });
                },
              ),
              SizedBox(height: 16),
              InkWell(
                onTap: _presentDatePicker,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.deepPurple),
                      SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          _selectedDate == null
                              ? 'Choose Due Date'
                              : 'Due Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}',
                          style: TextStyle(fontSize: 16, color: _selectedDate == null ? Colors.grey[700] : Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: _saveTask,
                icon: Icon(Icons.check_circle_outline),
                label: Text('Save Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
