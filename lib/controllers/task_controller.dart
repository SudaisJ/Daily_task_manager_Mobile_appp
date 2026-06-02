import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../repositories/task_repository.dart';

class TaskController with ChangeNotifier {
  final TaskRepository _repository = TaskRepository();
  List<Task> _tasks = [];
  bool _isLoading = false;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;

  Future<void> fetchTasks(int userId) async {
    _isLoading = true;
    notifyListeners();

    _tasks = await _repository.getTasks(userId);
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    await _repository.insertTask(task);
    if (task.userId != null) {
      await fetchTasks(task.userId!);
    }
  }

  Future<void> updateTask(Task task) async {
    await _repository.updateTask(task);
    if (task.userId != null) {
      await fetchTasks(task.userId!);
    }
  }

  Future<void> deleteTask(int id, int userId) async {
    await _repository.deleteTask(id, userId);
    await fetchTasks(userId);
  }

  Future<void> toggleTaskCompletion(Task task) async {
    task.isCompleted = task.isCompleted == 1 ? 0 : 1;
    await _repository.updateTask(task);
    if (task.userId != null) {
      await fetchTasks(task.userId!);
    }
  }
}
