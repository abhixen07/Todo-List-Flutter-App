
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_list/modules/auth/views/login_view.dart';
import 'package:todo_list/todo_management/add_firestore_data.dart';
import 'package:todo_list/utils/utils.dart';

class FireStoreScreen extends StatefulWidget {
  const FireStoreScreen({Key? key});

  @override
  State<FireStoreScreen> createState() => _FireStoreScreenState();
}

class _FireStoreScreenState extends State<FireStoreScreen> {
  final auth = FirebaseAuth.instance;
  final editController = TextEditingController();
  final locationController = TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection('TODO').snapshots();
  CollectionReference ref = FirebaseFirestore.instance.collection('TODO');
  bool isSelecting = false;

  List<String> selectedIds = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffffcc00),
        title: Text(isSelecting ? 'Select TODO' : 'TODO Management'),
        actions: [
          if (!isSelecting) // Conditionally render select icon based on state
            IconButton(
              onPressed: () {
                setState(() {
                  isSelecting = true;
                });
              },
              icon: Icon(Icons.select_all),
            ),
          if (isSelecting) // Conditionally render close icon based on state
            IconButton(
              onPressed: () {
                setState(() {
                  isSelecting = false;
                  selectedIds.clear();
                });
              },
              icon: Icon(Icons.close),
            ),
          IconButton(
            onPressed: () {
              auth.signOut().then((value) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginView()),
                );
              }).onError((error, stackTrace) {
                Utils().toastMessage(error.toString());
              });
            },
            icon: Icon(Icons.logout_outlined),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          StreamBuilder<QuerySnapshot>(
            stream: fireStore,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Text('Error');
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No data found'));
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    String taskName = snapshot.data!.docs[index]['taskName'].toString();
                    return ListTile(
                      onTap: () {
                        if (isSelecting) {
                          setState(() {
                            String id = snapshot.data!.docs[index].id;
                            if (selectedIds.contains(id)) {
                              selectedIds.remove(id);
                            } else {
                              selectedIds.add(id);
                            }
                          });
                        }
                      },
                      title: Text(taskName),

                      trailing: isSelecting
                          ? Checkbox(
                        value: selectedIds.contains(snapshot.data!.docs[index].id),
                        onChanged: (_) {
                          setState(() {
                            String id = snapshot.data!.docs[index].id;
                            if (selectedIds.contains(id)) {
                              selectedIds.remove(id);
                            } else {
                              selectedIds.add(id);
                            }
                          });
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
                                // showMyDialog(taskName, snapshot.data!.docs[index].id);
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
                                await deleteDocumentAndSubcollection(snapshot.data!.docs[index].id);
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
            },
          ),
        ],
      ),
      bottomNavigationBar: !isSelecting
          ? BottomAppBar(
        elevation: 0, // Decrease the elevation to remove shadow
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: 56,
              height: 56,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddFirestoreDataScreen()));
                },
                backgroundColor: Color(0xFFFFCC00),
                child: Icon(Icons.add),
                elevation: 0,
                mini: true,
              ),
            ),
          ],
        ),
      )
          : BottomAppBar(
            elevation: 0, // Decrease the elevation to remove shadow
            color: Colors.transparent,
              child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
               IconButton(
              onPressed: () {
                deleteSelectedItems();
              },
                icon: Icon(Icons.delete),
                iconSize: 24,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showMyDialog(String title, String id) async {
    editController.text = title;
    String newTitle = title;
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update'),
          content: Container(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: editController,
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
                  // Query Firestore to check if any document with the same taskName already exists
                  ref
                      .where('taskName', isEqualTo: newTitle)
                      .get()
                      .then((QuerySnapshot querySnapshot) {
                    if (querySnapshot.docs.isNotEmpty) {
                      // Document with the same taskName and location already exists
                      Utils().toastMessage('Task with the same name already exists');
                    } else {
                      // No document with the same taskName and location, proceed to update data
                      Navigator.pop(context);
                      ref.doc(id).update({
                        'taskName': newTitle.trim().toUpperCase(),
                      }).then((value) {
                        Utils().toastMessage('Updated Successfully');
                      }).onError((error, stackTrace) {
                        Utils().toastMessage(error.toString());
                      });
                    }
                  }).catchError((error) {
                    Utils().toastMessage('Error: $error');
                  });
                }
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  // Function to delete selected items
  Future<void> deleteSelectedItems() async {
    // Iterate over selectedIds and delete each document and its subcollection
    for (String id in selectedIds) {
      await deleteDocumentAndSubcollection(id);
    }
    setState(() {
      selectedIds.clear(); // Clear selectedIds after deletion
      isSelecting = false; // Exit selection mode after deletion
    });
  }

  // Function to delete document and its subcollection
  Future<void> deleteDocumentAndSubcollection(String documentId) async {
    // Delete subcollection documents
    await FirebaseFirestore.instance
        .collection('TODO')
        .doc(documentId)
        .collection('tasks')
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) async {
        await doc.reference.delete();
      });
    });

    // Delete parent document
    await FirebaseFirestore.instance.collection('TODO').doc(documentId).delete().then((value) {
      Utils().toastMessage('Deleted Successfully');
    }).onError((error, stackTrace) {
      Utils().toastMessage(error.toString());
    });
  }
}
