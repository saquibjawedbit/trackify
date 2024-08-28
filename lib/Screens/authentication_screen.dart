import 'package:bit_book/Misc/Paints/circle_painter.dart';
import 'package:flutter/material.dart';

import '../Widgets/buttons/white_input_field.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({super.key});

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
                  color: Theme.of(context).colorScheme.primary,
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
                    left: 130,
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _signUpPage(context),
    );
  }

  List<Widget> _signUpPage(BuildContext context) {
    return [
      Text(
        "Sign Up",
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
      _inputField(context),
      const SizedBox(
        height: 20,
      ),
      _labelText("Password"),
      const SizedBox(
        height: 10,
      ),
      _inputField(context),
      const SizedBox(
        height: 40,
      ),
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
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Theme.of(context).colorScheme.secondary),
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
                const Text(
                  "Sign In using ",
                  style: TextStyle(
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
    ];
  }

  Widget _signupBtn(BuildContext context) {
    return CustomRedButton(
      onTap: () {
        Navigator.pushReplacementNamed(context, '/onboard');
      },
      text: "Create Account",
    );
  }

  Row _loginMethod(BuildContext context) {
    return Row(
      children: [
        const Text(
          "Already have an account?",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w100,
          ),
        ),
        const SizedBox(
          width: 6,
        ),
        SelectableText(
          "Login",
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ],
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

  Widget _inputField(BuildContext context) {
    return const WhiteInputField();
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
}

class CustomRedButton extends StatelessWidget {
  const CustomRedButton({
    super.key,
    required this.onTap,
    required this.text,
  });

  final void Function() onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 10),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 60,
          vertical: 20,
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
      ),
    );
  }
}
