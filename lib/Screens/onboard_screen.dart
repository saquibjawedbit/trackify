import 'package:bit_book/Misc/Paints/circle_painter.dart';
import 'package:bit_book/Screens/authentication_screen.dart';
import 'package:bit_book/Widgets/buttons/white_input_field.dart';
import 'package:flutter/material.dart';

class OnboardScreen extends StatelessWidget {
  const OnboardScreen({super.key});

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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: "Enter ",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 52,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: "Credential",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _signUpPage(context),
          ),
        ),
      ],
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
          _nameInput("First Name"),
          const SizedBox(
            width: 120,
          ),
          _nameInput("Last Name"),
        ],
      ),
      const SizedBox(
        height: 40,
      ),
      _labelText("Roll Number"),
      const SizedBox(
        height: 20,
      ),
      const WhiteInputField(),
      const SizedBox(
        height: 40,
      ),
      CustomRedButton(onTap: () {}, text: "Login"),
    ];
  }

  Expanded _nameInput(String label) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _labelText(label),
          const SizedBox(
            height: 20,
          ),
          const WhiteInputField(),
        ],
      ),
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
}
