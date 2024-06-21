import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/model/add_task_model.dart';
import 'package:todo_list/utils/utils.dart';

class TaskViewModel extends GetxController {
  final taskController = TextEditingController();
  final descriptionController = TextEditingController();
  final dateTimeController = TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection('TODO');
  final formKey = GlobalKey<FormState>();
  var loading = false.obs;

  void addTask() async {
    if (formKey.currentState!.validate()) {
      loading.value = true;
      String id = DateTime.now().millisecondsSinceEpoch.toString();
      String taskName = taskController.text.trim().toUpperCase();
      String description = descriptionController.text.trim();
      String dateTime = dateTimeController.text.trim();

      fireStore.where('taskName', isEqualTo: taskName).get().then((QuerySnapshot querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          Utils().toastMessage('Task with the same name already exists');
          loading.value = false;
        } else {
          Task task = Task(
            id: id,
            taskName: taskName,
            description: description,
            dateTime: dateTime,
          );
          fireStore.doc(id).set(task.toMap()).then((value) {
            Utils().toastMessage('Added Successfully');
            loading.value = false;
            Get.back();
          }).onError((error, stackTrace) {
            Utils().toastMessage(error.toString());
            loading.value = false;
          });
        }
      }).catchError((error) {
        Utils().toastMessage('Error: $error');
        loading.value = false;
      });
    }
  }
}