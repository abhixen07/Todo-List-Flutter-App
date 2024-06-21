import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_list/utils/utils.dart';
import 'package:todo_list/widgets/round_button.dart';


class AddFirestoreDataScreen extends StatefulWidget {
  const AddFirestoreDataScreen({Key? key}) : super(key: key);

  @override
  State<AddFirestoreDataScreen> createState() => _AddFirestoreDataScreenState();
}

class _AddFirestoreDataScreenState extends State<AddFirestoreDataScreen> {
  final taskController = TextEditingController();
  final locationController = TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection('TODO');
  final _formKey = GlobalKey<FormState>(); // Add GlobalKey<FormState>
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffffcc00), // Set your desired color here
        title: const Text('Add New Task'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          // Wrap your form with Form widget
          key: _formKey, // Set key to the GlobalKey<FormState>
          child: Column(
            children: [
              const SizedBox(height: 30,),
              TextFormField(
                maxLines: 1,
                controller: taskController,
                decoration: InputDecoration(
                  labelText: 'Task Name',
                  prefixIcon: Icon(Icons.storefront_outlined),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z\s]*$')), // Allow only alphabets and spaces
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Task name cannot be empty';
                  }

                  return null; // Return null if the validation passes
                },
              ) ,

              const SizedBox(height: 30,),


              RoundButton(
                title: 'ADD',
                loading: loading,

                onTap: () async {
                  if (_formKey.currentState!.validate()) {

                    setState(() {
                      loading = true;
                    });
                    String id = DateTime.now().millisecondsSinceEpoch.toString();
                    String taskName = taskController.text.trim().toUpperCase();

                    // Query Firestore to check if a document with the same taskName already exists
                    fireStore.where('taskName', isEqualTo: taskName)
                        .get()
                        .then((QuerySnapshot querySnapshot) {
                      if (querySnapshot.docs.isNotEmpty) {
                        Utils().toastMessage('Task with the same name already exists');
                        setState(() {
                          loading = false;
                        });
                      } else {
                        // No document with the same taskName and location, proceed to add new data
                        fireStore.doc(id).set({
                          'taskName': taskName,
                          'id': id,
                        }).then((value) {
                          Utils().toastMessage('Added Successfully');
                          setState(() {
                            loading = false;
                          });
                          Navigator.pop(context); // Navigate back to the previous screen
                        }).onError((error, stackTrace) {
                          Utils().toastMessage(error.toString());
                          setState(() {
                            loading = false;
                          });
                        });
                      }
                    }).catchError((error) {
                      Utils().toastMessage('Error: $error');
                      setState(() {
                        loading = false;
                      });
                    });
                  }
                },


                buttonColor: Color(0xFFFFCC00), // Set your desired color here
              ),
            ],
          ),
        ),
      ),
    );
  }



}




