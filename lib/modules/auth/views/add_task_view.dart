import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:todo_list/modules/auth/controllers/add_task_controller.dart';
import 'package:todo_list/widgets/custom_input_textfield.dart';
import 'package:todo_list/widgets/round_button.dart';

class AddTaskScreen extends StatelessWidget {
  AddTaskScreen({Key? key}) : super(key: key);

  final TaskViewModel viewModel = Get.put(TaskViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffffcc00), // Set your desired color here
        title: const Text('Add New Task'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: viewModel.formKey, // Set key to the GlobalKey<FormState>
          child: Column(
            children: [
              const SizedBox(height: 30,),
              CustomTextFormField(
                controller: viewModel.taskController,
                hintText: 'Task Name',
                prefixIcon: Icons.storefront_outlined,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Task name cannot be empty';
                  }
                  return null; // Return null if the validation passes
                },
              ),
              const SizedBox(height: 30,),
              CustomTextFormField(
                controller: viewModel.descriptionController,
                hintText: 'Description',
                prefixIcon: Icons.description_outlined,
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Description cannot be empty';
                  }
                  return null; // Return null if the validation passes
                },
              ),
              const SizedBox(height: 30,),
              CustomTextFormField(
                controller: viewModel.dateTimeController,
                hintText: 'Date and Time',
                prefixIcon: Icons.calendar_today_outlined,
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Date and Time cannot be empty';
                  }
                  return null; // Return null if the validation passes
                },
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      final dateTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute);
                      viewModel.dateTimeController.text = dateTime.toString();
                    }
                  }
                },
              ),
              const SizedBox(height: 30,),
              Obx(() => RoundButton(
                title: 'ADD',
                loading: viewModel.loading.value,
                onTap: viewModel.addTask,
                buttonColor: const Color(0xFFFFCC00), // Set your desired color here
              )),
            ],
          ),
        ),
      ),
    );
  }
}
