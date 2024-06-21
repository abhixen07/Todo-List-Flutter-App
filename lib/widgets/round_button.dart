import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool loading;
  final Color buttonColor;
  final GlobalKey<FormState>? formKey; // Accept formKey as an optional parameter

  const RoundButton({
    Key? key,
    required this.title,
    required this.onTap,
    this.loading = false,
    this.buttonColor = Colors.deepPurple,
    this.formKey, // Initialize formKey parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Check if formKey is not null and form is valid
        if (formKey != null && formKey!.currentState != null && formKey!.currentState!.validate()) {
          onTap();
        }
        // If formKey is null or form is not valid, simply call onTap
        else {
          onTap();
        }
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: loading
              ? CircularProgressIndicator(
            strokeWidth: 3,
            color: Colors.white,
          )
              : Text(
            title,
            style: TextStyle(
              color: Colors.white, // Set text color to black
              fontWeight: FontWeight.bold, // Set text to bold
            ),
          ),
        ),
      ),
    );
  }
}
