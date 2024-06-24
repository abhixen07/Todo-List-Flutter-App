import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:todo_list/model/task_management_model.dart';
import 'package:todo_list/utils/utils.dart';

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
    fetchTasks();
  }

  void fetchTasks() async {
    loading(true);  // Indicate loading state in UI
    try {
      User? user = auth.currentUser;
      if (user != null) {
        print('Fetching tasks for user: ${user.uid}');
        fireStore.collection('TODO')
            .where('userId', isEqualTo: user.uid)
            .snapshots()
            .listen((QuerySnapshot snapshot) {
          print('Tasks fetched: ${snapshot.docs.length}');
          tasks.value = snapshot.docs.map((doc) {
            return Task.fromMap(doc.data() as Map<String, dynamic>, id: doc.id);
          }).toList();
        });
      } else {
        print('No user currently signed in');
        Utils().toastMessage('No user currently signed in');
      }
    } catch (e) {
      print('Error fetching tasks: $e');  // Print error to console for debugging
      Utils().toastMessage('Error fetching tasks: $e');
    } finally {
      loading(false);  // Indicate end of loading state in UI
    }
  }

  Future<void> addTask(Task task) async {
    loading.value = true;
    try {
      print('Adding task: ${task.toMap()}');
      await fireStore.collection('TODO').add(task.toMap());
      Utils().toastMessage('Added Successfully');
    } catch (error) {
      Utils().toastMessage('Error: $error');
    } finally {
      loading.value = false;
    }
  }

  Future<void> updateTask(Task task) async {
    loading.value = true;
    try {
      await fireStore.collection('TODO').doc(task.id).update(task.toMap());
      Utils().toastMessage('Updated Successfully');
    } catch (error) {
      Utils().toastMessage('Error: $error');
    } finally {
      loading.value = false;
    }
  }

  Future<void> deleteTask(String taskId) async {
    loading.value = true;
    try {
      await fireStore.collection('TODO').doc(taskId).delete();
      Utils().toastMessage('Deleted Successfully');
    } catch (error) {
      Utils().toastMessage('Error: $error');
    } finally {
      loading.value = false;
    }
  }

  Future<void> deleteSelectedTasks() async {
    loading.value = true;
    try {
      for (String id in selectedIds) {
        await deleteTask(id);
      }
      selectedIds.clear();
      isSelecting.value = false;
    } catch (error) {
      Utils().toastMessage('Error: $error');
    } finally {
      loading.value = false;
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
  }
}
