import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/model/task_management_model.dart';
import 'package:todo_list/modules/auth/controllers/task_management_controller.dart';
import 'package:todo_list/modules/auth/views/add_task_view.dart';
import 'package:todo_list/modules/auth/views/login_view.dart';
import 'package:todo_list/utils/utils.dart';

class FireStoreScreen extends StatelessWidget {
  FireStoreScreen({Key? key}) : super(key: key);

  final TaskManagementController viewModel = Get.put(TaskManagementController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFF075E59),
        title: Obx(() => Text(
          viewModel.isSelecting.value ? 'Select TODO' : 'TODO List',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        )),
        actions: [
          Obx(() => !viewModel.isSelecting.value
              ? IconButton(
            onPressed: () {
              viewModel.isSelecting.value = true;
            },
            icon: Icon(Icons.select_all, color: Colors.white),
          )
              : IconButton(
            onPressed: () {
              viewModel.isSelecting.value = false;
              viewModel.selectedIds.clear();
            },
            icon: Icon(Icons.close, color: Colors.white),
          )),
          IconButton(
            onPressed: () {
              viewModel.signOut().then((value) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginView()),
                );
              }).onError((error, stackTrace) {
                Utils().toastMessage(error.toString());
              });
            },
            icon: Icon(Icons.logout_outlined, color: Colors.white),
          ),
          SizedBox(width: 10),
        ],
      ),

      body: Column(
        children: [
          const SizedBox(height: 10),
          Obx(() {
            if (viewModel.loading.value) {
              return Center(child: CircularProgressIndicator());
            }
            if (viewModel.tasks.isEmpty) {
              return Center(child: Text('No data found'));
            }
            return Expanded(
              child: ListView.builder(
                itemCount: viewModel.tasks.length,
                itemBuilder: (context, index) {
                  Task task = viewModel.tasks[index];
                  return ListTile(
                    onTap: () {
                      if (viewModel.isSelecting.value) {
                        String id = task.id;
                        if (viewModel.selectedIds.contains(id)) {
                          viewModel.selectedIds.remove(id);
                        } else {
                          viewModel.selectedIds.add(id);
                        }
                      }
                    },
                    title: Text(task.taskName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(task.description),
                        Text(task.dateTime),
                      ],
                    ),
                    trailing: viewModel.isSelecting.value
                        ? Checkbox(
                      value: viewModel.selectedIds.contains(task.id),
                      onChanged: (_) {
                        String id = task.id;
                        if (viewModel.selectedIds.contains(id)) {
                          viewModel.selectedIds.remove(id);
                        } else {
                          viewModel.selectedIds.add(id);
                        }
                      },
                    )
                        : PopupMenuButton(
                      icon: Icon(Icons.more_vert),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 1,
                          child: ListTile(
                            onTap: () {
                              Navigator.pop(context);
                              showMyDialog(context, task);
                            },
                            leading: Icon(Icons.edit),
                            title: Text('Update'),
                          ),
                        ),
                        PopupMenuItem(
                          value: 2,
                          child: ListTile(
                            onTap: () async {
                              Navigator.pop(context);
                              viewModel.deleteTask(task.id);
                            },
                            leading: Icon(Icons.delete),
                            title: Text('Delete'),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
      bottomNavigationBar: Obx(() => !viewModel.isSelecting.value
          ? BottomAppBar(
        elevation: 0,
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: 56,
              height: 56,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddTaskScreen()));
                },
                backgroundColor: Color(0xFF075E59),
                child: Icon(Icons.add, color: Colors.white),
                elevation: 0,
                mini: true,
              ),
            ),
          ],
        ),
      )
          : BottomAppBar(
        elevation: 0,
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {
                viewModel.deleteSelectedTasks();
              },
              icon: Icon(Icons.delete),
              iconSize: 24,
            ),
          ],
        ),
      )),
    );
  }

  Future<void> showMyDialog(BuildContext context, Task task) async {
    final editNameController = TextEditingController(text: task.taskName);
    final editDescriptionController = TextEditingController(text: task.description);
    final editDateTimeController = TextEditingController(text: task.dateTime);

    String newTitle = task.taskName;
    String newDescription = task.description;
    String newDateTime = task.dateTime;

    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Task'),
          content: Container(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: editNameController,
                    decoration: InputDecoration(hintText: 'Edit Task Name'),
                    onChanged: (value) {
                      newTitle = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Task name cannot be empty';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: editDescriptionController,
                    decoration: InputDecoration(hintText: 'Edit Description'),
                    onChanged: (value) {
                      newDescription = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Description cannot be empty';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: editDateTimeController,
                    decoration: InputDecoration(hintText: 'Edit Date and Time'),
                    onChanged: (value) {
                      newDateTime = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Date and Time cannot be empty';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  task.taskName = newTitle.trim();
                  task.description = newDescription.trim();
                  task.dateTime = newDateTime.trim();
                  viewModel.updateTask(task);
                  Navigator.pop(context);
                }
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }
}