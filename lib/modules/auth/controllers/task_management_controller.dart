import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:todo_list/model/task_management_model.dart';
import 'package:todo_list/utils/Utils.dart';

class TaskManagementController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;

  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final tasks = <Task>[].obs;
  final selectedIds = <String>[].obs;
  final isSelecting = false.obs;
  final loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  void loadTasks() {
    fireStore.collection('TODO').snapshots().listen((querySnapshot) {
      tasks.value = querySnapshot.docs
          .map((doc) => Task.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Future<void> addTask(Task task) async {
    loading.value = true;
    await fireStore.collection('TODO').doc(task.id).set(task.toMap()).then((value) {
      Utils().toastMessage('Added Successfully');
      loading.value = false;
    }).catchError((error) {
      Utils().toastMessage('Error: $error');
      loading.value = false;
    });
  }

  Future<void> updateTask(Task task) async {
    loading.value = true;
    await fireStore.collection('TODO').doc(task.id).update(task.toMap()).then((value) {
      Utils().toastMessage('Updated Successfully');
      loading.value = false;
    }).catchError((error) {
      Utils().toastMessage('Error: $error');
      loading.value = false;
    });
  }

  Future<void> deleteTask(String taskId) async {
    loading.value = true;
    await fireStore.collection('TODO').doc(taskId).delete().then((value) {
      Utils().toastMessage('Deleted Successfully');
      loading.value = false;
    }).catchError((error) {
      Utils().toastMessage('Error: $error');
      loading.value = false;
    });
  }

  Future<void> deleteSelectedTasks() async {
    loading.value = true;
    for (String id in selectedIds) {
      await deleteTask(id);
    }
    selectedIds.clear();
    isSelecting.value = false;
    loading.value = false;
  }

  Future<void> signOut() async {
    await auth.signOut();
  }
}