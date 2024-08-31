import 'package:bit_book/Misc/Paints/circle_painter.dart';
import 'package:bit_book/Widgets/buttons/controllers/authentication/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Widgets/buttons/custom_red_button.dart';
import '../Widgets/header_text.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  //final controller = PageController();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox.expand(
        child: Stack(
          //mainAxisSize: MainAxisSize.max,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: CustomPaint(
                painter: CirclePainter(),
                child: SizedBox(
                  height: double.infinity,
                  width: 0.5 * width,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(80),
                    bottomLeft: Radius.circular(80),
                  ),
                ),
                height: double.infinity,
                width: 0.7 * width,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 80,
                    left: 100,
                    right: 130,
                  ),
                  child: _pageBuilder(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column _pageBuilder(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeaderText(
          text1: "Enter ",
          text2: "Credential",
        ),
        Padding(
          padding: EdgeInsets.only(left: 60),
          child: OnboardForm(),
        ),
      ],
    );
  }
}

class OnboardForm extends StatefulWidget {
  const OnboardForm({super.key});

  @override
  State<OnboardForm> createState() => _OnboardFormState();
}

class _OnboardFormState extends State<OnboardForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = "";
  String _lastName = "";
  String _rollNo = "";
  BorderSide border(BuildContext context) =>
      BorderSide(color: Theme.of(context).colorScheme.secondary);

  final UserController _userController = Get.find();

  String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return "Please Enter..";
    }
    return null;
  }

  // Method to handle form submission
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _userController.saveDetails(_name, _lastName, _rollNo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _signUpPage(context),
      ),
    );
  }

  List<Widget> _signUpPage(BuildContext context) {
    return [
      const SizedBox(
        height: 60,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _nameInput("First Name", validate, _name),
          const SizedBox(
            width: 120,
          ),
          _nameInput("Last Name", validate, _lastName),
        ],
      ),
      const SizedBox(
        height: 40,
      ),
      _labelText("Roll Number"),
      const SizedBox(
        height: 20,
      ),
      TextFormField(
        decoration: _inputDecor(context),
        keyboardType: TextInputType.emailAddress,
        validator: validate,
        onSaved: (value) => _rollNo = value!,
      ),
      //WhiteInputField(
      // ),
      const SizedBox(
        height: 40,
      ),
      CustomRedButton(
        onTap: _submitForm,
        text: "Login",
      ),
    ];
  }

  Text _labelText(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Expanded _nameInput(
      String label, String? Function(String?) valid, String val) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _labelText(label),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            decoration: _inputDecor(context),
            keyboardType: TextInputType.emailAddress,
            validator: valid,
            onSaved: (value) => val = value!,
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecor(BuildContext context) {
    return InputDecoration(
      filled: true, // Enables the filled background color
      fillColor: Colors.white, // Sets the fill color to white
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0), // Rounded corners
        borderSide: border(context),
      ),
      errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
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
    );
  }
}
