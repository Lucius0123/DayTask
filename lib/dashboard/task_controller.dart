import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:techstax_task_manager/dashboard/task_model.dart';


class TaskController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final SupabaseClient _supabase = Supabase.instance.client;
  final RxList<Task> tasks = <Task>[].obs;
  final RxBool isLoading = false.obs;
  RxString title = ''.obs;
  RxString description = ''.obs;
  Rx<DateTime> dueDate = DateTime.now().obs;
  RxString priority = 'medium'.obs;
  Task? currentTask;
  TaskController({this.currentTask}) {
    if (currentTask != null) {
      title.value = currentTask!.title;
      description.value = currentTask!.description;
      priority.value = currentTask!.priority;
      dueDate.value = currentTask!.dueDate;
    }
  }
  void setTitle(String value) {
    title.value = value;
  }
  void resetForm() {
    currentTask = null;
    title.value = '';
    description.value = '';
    priority.value = 'medium';
    dueDate.value = DateTime.now();
  }
  void loadTask(Task task) {
    currentTask = task;
    title.value = task.title;
    description.value = task.description;
    priority.value = task.priority;
    dueDate.value = task.dueDate;
  }

  void setDescription(String value) {
    description.value = value;

  }

  void setPriority(String value) {
    priority.value= value;
  }
  Future<void> selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: dueDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != dueDate.value) {
      dueDate.value = picked;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    isLoading.value = true;
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      final response = await _supabase
          .from('tasks')
          .select()
          .eq('user_id', userId)
          .order('due_date', ascending: true);

      final List<Task> taskList = response.map<Task>((json) => Task.fromJson(json)).toList();
      tasks.value = taskList;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch tasks: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addTask(BuildContext context,) async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      final userId = _supabase.auth.currentUser!.id;

      if (currentTask == null) {
        // 🔹 Insert new task
        final response = await _supabase.from('tasks').insert({
          'title': title.value,
          'is_completed': false,
          'user_id': userId,
          'due_date': dueDate.value.toIso8601String(),
          'description': description.value,
          'priority': priority.value,
        }).select();

        if (response.isNotEmpty) {
          final newTask = Task.fromJson(response.first);
          tasks.add(newTask);
        }
      } else {
        // 🔹 Update existing task
        final response = await _supabase.from('tasks')
            .update({
          'title': title.value,
          'is_completed': currentTask!.isCompleted,
          'due_date': dueDate.value.toIso8601String(),
          'description':description.value,
          'priority': priority.value,
        }).eq('id', currentTask!.id).select();

        if (response.isNotEmpty) {
          final updatedTask = Task.fromJson(response.first);

          // 🔄 Replace the task in the local list
          final index = tasks.indexWhere((t) => t.id == currentTask!.id);
          if (index != -1) {
            tasks[index] = updatedTask;
          }
        }
      }
      if(context.mounted){
        Get.back();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add task: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> toggleTaskStatus(String id, bool isCompleted) async {
    try {
      await _supabase
          .from('tasks')
          .update({'is_completed': isCompleted})
          .eq('id', id);

      final index = tasks.indexWhere((task) => task.id == id);
      if (index != -1) {
        final updatedTask = tasks[index].copyWith(isCompleted: isCompleted);
        tasks[index] = updatedTask;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update task: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await _supabase.from('tasks').delete().eq('id', id);
      tasks.removeWhere((task) => task.id == id);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete task: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }
}
