import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:techstax_task_manager/dashboard/task_controller.dart';
import 'package:techstax_task_manager/dashboard/task_model.dart';
import '../utils/priority_selector.dart';

class EditTaskScreen extends StatefulWidget {
  const EditTaskScreen({super.key, this.tasks});
  final Task? tasks;

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final TaskController _taskController = Get.find<TaskController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(_taskController.currentTask == null ? 'Add Task' : 'Edit Task'),
        centerTitle: true,
      ),
      body: Obx(()=>Form(
        key: _taskController.formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              initialValue: _taskController.title.value,
              onChanged: _taskController.setTitle,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Enter task title',
              ),
              validator: (value) =>
              (value == null || value.isEmpty) ? 'Please enter a title' : null,
            ),
            const SizedBox(height: 16),
            // Description Field
            TextFormField(
              initialValue: _taskController.description.value,
              onChanged: _taskController.setDescription,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Enter task description',
              ),
              minLines: 5,
              maxLines: null,
            ),
            const SizedBox(height: 16),
            // Due Date & Time
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _taskController.selectDate(context),
                    child: InputDecorator(
                      decoration: const InputDecoration(labelText: 'Due Date'),
                      child: Text(
                        DateFormat('MMM d, yyyy').format(_taskController.dueDate.value),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Priority Selector
            const Text('Priority', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            PrioritySelector(
              selectedPriority: _taskController.priority.value,
              onPrioritySelected: _taskController.setPriority,

            ),
            const SizedBox(height: 32),
            // Save Task Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:_taskController.isLoading.value? null : () => _taskController.addTask(context,),
                  child: _taskController.isLoading.value
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : Text(_taskController.currentTask == null ? 'Add Task' : 'Update Task'),
              ),
            ),
          ],
        ),
      ),)
    );
  }
}
