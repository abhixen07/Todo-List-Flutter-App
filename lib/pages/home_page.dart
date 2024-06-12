import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/modules/auth/views/login_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.teal,
        title: Text('Home Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Get.offAll(() => LoginView());
            },
          ),
        ],
      ),
      body: Center(
        child: CircleAvatar(
          radius: 80,
          backgroundColor: Colors.green,
          child: Icon(
            Icons.check,
            size: 100,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
