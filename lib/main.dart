import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bit Book',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 255, 52, 86),
          primary: const Color.fromARGB(255, 17, 17, 17),
          secondary: const Color.fromARGB(255, 255, 52, 86),
        ),
        useMaterial3: true,
      ),
      home: const LandingPage(),
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: CustomPaint(
                  painter: CirclePainter(),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 200, left: 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Personalized",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            const SizedBox(
                              width: 40,
                            ),
                            const Text(
                              "Notebook.",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              "BitBook.",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                        Align(
                          alignment: const Alignment(-0.5, 0),
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 60,
                                vertical: 20,
                              ),
                            ),
                            child: const Text(
                              "Get Started",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: const Color.fromARGB(255, 35, 35, 35),
                ),
              ),
            ],
          ),
          const Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 28, vertical: 28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "BITBOOK",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "About Us",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Services & Support",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 28),
              child: Icon(
                Icons.menu,
                size: 36,
                color: Colors.white,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary,
                    // spreadRadius: 42.0,
                    blurRadius: 40.0,
                    blurStyle: BlurStyle.solid,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Create a black paint for the background
    final blackPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    // Draw the black background
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), blackPaint);

    // Define the circle's center and radius
    final center = Offset(0, size.height);
    final radius = size.width * 0.8; // Example radius (40% of the width)

    // Create a radial gradient paint for the circle with fading effect
    final gradientPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color.fromARGB(255, 255, 52, 86).withOpacity(1.0),
          const Color.fromARGB(255, 255, 52, 86).withOpacity(0.0)
        ],
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.fill;

    // Draw the circle with the gradient paint
    canvas.drawCircle(center, radius, gradientPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false; // No need to repaint
  }
}
