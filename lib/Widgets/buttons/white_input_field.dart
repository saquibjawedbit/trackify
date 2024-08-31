import 'package:flutter/material.dart';

class WhiteInputField extends StatelessWidget {
  const WhiteInputField({
    super.key,
    required this.controller,
    this.obscureText = false,
  });

  final TextEditingController controller;
  final bool obscureText;

  BorderSide border(BuildContext context) =>
      BorderSide(color: Theme.of(context).colorScheme.secondary);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        filled: true, // Enables the filled background color
        fillColor: Colors.white, // Sets the fill color to white
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0), // Rounded corners
          borderSide: border(context),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            12.0,
          ), // Rounded corners when enabled
          borderSide: border(context),
        ), // Grey border when enabled

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            12.0,
          ), // Rounded corners when focused
          borderSide: border(context), // Border color when focused
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15.0,
          horizontal: 20.0,
        ), // Padding inside the TextField
      ),
      cursorColor: Colors.black,
    );
  }
}
