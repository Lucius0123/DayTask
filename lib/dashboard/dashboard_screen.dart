import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:techstax_task_manager/dashboard/task_controller.dart';
import '../auth/auth_service.dart';
import '../utils/task_tile.dart';
import 'edit_task_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final AuthService _authService = Get.find<AuthService>();
  final TaskController _taskController = Get.find<TaskController>();
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _taskController.fetchTasks();
    _isDarkMode = Get.isDarkMode;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text('MyTasks'),
            Text(
              'Today, ${DateFormat('d MMM').format(DateTime.now())}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
          onPressed: () {
            setState(() {
              _isDarkMode = !_isDarkMode;
              Get.changeThemeMode(_isDarkMode ? ThemeMode.dark : ThemeMode.light);
            });
          },
        ),
        actions: [
          // Logout
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _authService.signOut();
            },
          ),
        ],
      ),
      body: Obx(() {
        if (_taskController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (_taskController.tasks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.task_alt,
                  size: 80,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'No tasks yet',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: (){
                    _taskController.resetForm();
                    Get.to(()=>EditTaskScreen());
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Your First Task'),
                ),
              ],
            ),
          );
        }
        
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _taskController.tasks.length,
                itemBuilder: (context, index) {
                  final task = _taskController.tasks[index];
                  return TaskTile(
                    onEdit: (){
                      _taskController.loadTask(task);
                      Get.to(()=>EditTaskScreen(tasks: task));
                    },
                    task: task,
                    onToggle: (value) {
                      _taskController.toggleTaskStatus(task.id, value);
                    },
                    onDelete: () {
                      _taskController.deleteTask(task.id);
                    },
                  );
                },
              ),
            ),
            Padding(
              padding:  EdgeInsets.only(bottom: 70),
              child: Text('For remove the task swipe left'),
            )
          ],
        );
      }),
      floatingActionButton: Padding(
        padding:  EdgeInsets.only(bottom: 16),
        child: FloatingActionButton(
          onPressed: (){
            _taskController.resetForm();
            Get.to(()=>EditTaskScreen());
          },
          child: const Icon(Icons.add),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
