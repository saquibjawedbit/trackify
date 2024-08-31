import 'package:bit_book/Widgets/buttons/controllers/authentication/user_controller.dart';
import 'package:bit_book/Widgets/buttons/custom_red_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final UserController _userController = Get.find();

  BorderSide border(BuildContext context) =>
      BorderSide(color: Theme.of(context).colorScheme.secondary);
  String _email = '';
  String _password = '';

  bool _login = false;

  // Method to validate email
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  // Method to validate password
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  // Method to handle form submission
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_login) {
        _userController.login(_email, _password);
      } else {
        _userController.createAccount(_email, _password);
      }
    }
  }

  void changeMode() {
    setState(() {
      _login = !_login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _login ? "Login" : "Sign Up",
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 44,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 28,
          ),
          _labelText("Email"),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            decoration: _inputDecor(context),
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
            onSaved: (value) => _email = value!,
          ),
          const SizedBox(
            height: 20,
          ),
          _labelText("Password"),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            decoration: _inputDecor(context),
            obscureText: true,
            validator: _validatePassword,
            onSaved: (value) => _password = value!,
          ),
          Obx(() => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  _userController.loginMessage.value,
                  style: const TextStyle(color: Colors.white),
                ),
              )),
          _signupBtn(context),
          const SizedBox(
            height: 10,
          ),
          _loginMethod(context),
          const SizedBox(
            height: 40,
          ),
          _divider(),
          const SizedBox(
            height: 40,
          ),
          Center(
            child: GestureDetector(
              onTap: _userController.signInWithGoogle,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: Theme.of(context).colorScheme.secondary),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "chrome.png",
                        scale: 1.5,
                      ),
                      const SizedBox(
                        width: 36,
                      ),
                      Text(
                        _login ? "Login using " : "Sign In using ",
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Google",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      const SizedBox(
                        width: 40,
                      ),
                    ],
                  ),
                ),
              ),
            ),
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

  Row _divider() {
    return const Row(
      children: [
        Expanded(
          child: Divider(
            color: Colors.grey, // Set the color of the divider
            thickness: 1, // Set the thickness of the divider
            endIndent: 10, // Space between the divider and the text
          ),
        ),
        Text(
          "or",
          style: TextStyle(
            color: Colors.white, // Set the color of the text
            fontSize: 16,
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.grey, // Set the color of the divider
            thickness: 1, // Set the thickness of the divider
            indent: 10, // Space between the divider and the text
          ),
        ),
      ],
    );
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

  Row _loginMethod(BuildContext context) {
    return Row(
      children: [
        Text(
          _login ? "Don't have an account?" : "Already have an account?",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w100,
          ),
        ),
        const SizedBox(
          width: 6,
        ),
        GestureDetector(
          onTap: changeMode,
          child: Text(
            _login ? "Create One" : "Login",
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
      ],
    );
  }

  _signupBtn(BuildContext context) {
    return CustomRedButton(
        onTap: _submitForm, text: _login ? "Login" : "Create Account");
  }
}
