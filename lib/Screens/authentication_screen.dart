import 'package:bit_book/Misc/Paints/circle_painter.dart';
import 'package:flutter/material.dart';
import 'login_form.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox.expand(
        child: Stack(
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

  Widget _pageBuilder(BuildContext context) {
    return const LoginForm();
  }
}
