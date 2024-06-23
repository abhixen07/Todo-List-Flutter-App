import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_list/model/add_task_model.dart';
import 'package:todo_list/utils/utils.dart';

class TaskViewModel extends GetxController {
  final Rx<FocusNode> taskFocusNode = FocusNode().obs;
  final Rx<FocusNode> descriptionFocusNode = FocusNode().obs;
  final Rx<FocusNode> dateTimeFocusNode = FocusNode().obs;
  final TextEditingController taskController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateTimeController = TextEditingController();
  final CollectionReference<Map<String, dynamic>> fireStore =
  FirebaseFirestore.instance.collection('TODO');
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final RxBool loading = false.obs;

  @override
  void onClose() {
    taskFocusNode.value.dispose();
    descriptionFocusNode.value.dispose();
    dateTimeFocusNode.value.dispose();
    taskController.dispose();
    descriptionController.dispose();
    dateTimeController.dispose();
    super.onClose();
  }

  void addTask() async {
    if (formKey.currentState!.validate()) {
      loading.value = true;
      String id = DateTime.now().millisecondsSinceEpoch.toString();
      String taskName = taskController.text.trim().toUpperCase();
      String description = descriptionController.text.trim();
      String dateTime = dateTimeController.text.trim();

      fireStore.where('taskName', isEqualTo: taskName).get().then(
            (QuerySnapshot<Map<String, dynamic>> querySnapshot) {
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
            fireStore.doc(id).set(task.toMap()).then(
                  (value) {
                Utils().toastMessage('Added Successfully');
                loading.value = false;
                Get.back();
              },
            ).onError(
                  (error, stackTrace) {
                Utils().toastMessage(error.toString());
                loading.value = false;
              },
            );
          }
        },
      ).catchError(
            (error) {
          Utils().toastMessage('Error: $error');
          loading.value = false;
        },
      );
    }
  }

  String formatDate(DateTime dateTime) {
    String formattedDate =
        '${dateTime.year}-${_twoDigits(dateTime.month)}-${_twoDigits(dateTime.day)} '
        '${_twoDigits(dateTime.hour)}:${_twoDigits(dateTime.minute)}';
    return formattedDate;
  }

  String _twoDigits(int n) {
    if (n >= 10) return '$n';
    return '0$n';
  }
}
