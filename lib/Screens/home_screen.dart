import 'package:bit_book/Misc/consts/main_btns_data.dart';
import 'package:bit_book/Widgets/buttons/controllers/authentication/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Widgets/header_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _hover = -1;
  final UserController _userController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeaderText(text1: "Home ", text2: "Page"),
            const SizedBox(
              height: 20,
            ),
            RichText(
              text: TextSpan(
                text: "Welcome, ",
                style: const TextStyle(color: Colors.white, fontSize: 16),
                children: [
                  TextSpan(
                    text: _userController.user!.name.capitalize,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (int i = 0; i < 4; i++)
                  _mainButton(context, btnsData[i], btnsImagePath[i], i),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _mainButton(
      BuildContext context, String label, String image, int index) {
    return Column(
      children: [
        InkWell(
          onTap: () {},
          onHover: (hovering) {
            setState(() {
              _hover = hovering ? index : -1;
            });
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: (_hover == index)
                  ? Colors.black
                  : const Color.fromARGB(255, 48, 48, 48),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            width: 280,
            height: 240,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
              child: Image.asset(
                image,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          overflow: TextOverflow.visible,
          maxLines: 2,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}
