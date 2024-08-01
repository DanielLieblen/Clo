
import 'package:flutter/material.dart';
import '../onboarding/onboarding_screen1.dart'; // Import the onboarding screen
import 'package:clo/tela_abertura_swipe/swipper_button_direita.dart';
import 'package:animated_widgets/animated_widgets.dart';
import 'dart:math' as math; // Import the math library

class TelaAbertura extends StatefulWidget {
  const TelaAbertura({super.key});

  @override
  State<TelaAbertura> createState() => _TelaAberturaState();
}

class _TelaAberturaState extends State<TelaAbertura> with SingleTickerProviderStateMixin {
  late final AnimationController animationController;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync:
      this,
    );
  }
  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Define the custom blue color
    const Color customBlue = Color(0xFF17153B);

    return Scaffold(
      backgroundColor: customBlue, // Set the background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png'), // Coloque seu logo aqui
            const SizedBox(height: 20),
            const Text(
              'Leilões',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: CustomPaint(
                size: const Size(100, 10),
                painter: ProgressPainter(),
              ),
            ),

            // Add the SwiperButton here
            MyCustomAnimation(animationController: animationController), // Pass animationController

            SwiperButton(
              onSwipeRight: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OnboardingScreen1()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ProgressPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.orange // Change color as desired
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5;

    canvas.drawLine(Offset(0, size.height / 2), Offset(size.width, size.height / 2), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MyCustomAnimation extends AnimatedWidget {
  final AnimationController animationController;

  const MyCustomAnimation({super.key, required this.animationController})
      : super(listenable: animationController);

  @override
  Widget build(BuildContext context) {
    final animation = animationController.value;

    return CustomPaint(
      size: const Size(200, 200), // Adjust size as needed
      painter: SwapPainter(animation),
    );
  }

}

class SwapPainter extends CustomPainter {
  final double animation;

  SwapPainter(this.animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white // Change color as desired
      ..strokeWidth = 5.0;

    // Calculate center point for the arc and arrow
    final center = Offset(size.width / 2, size.height / 2);

    // Calculate radius based on size
    final radius = size.width / 2 - paint.strokeWidth / 2;

    // Calculate arc sweep angle based on animation progress
    final sweepAngle = math.pi * animation;

    // Draw the arc
    final arcRect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(arcRect, -math.pi / 2, sweepAngle, false, paint);

    // Calculate arrowhead base and tip positions based on animation progress
    final double arrowheadLength = radius * 0.3; // Adjust arrowhead length
    final double arrowBaseAngle = math.pi - (sweepAngle / 2);
    final double arrowTipAngle = arrowBaseAngle + (math.pi / 4); // Adjust arrow angle

    final arrowBaseX = center.dx + math.cos(arrowBaseAngle) * radius;
    final arrowBaseY = center.dy + math.sin(arrowBaseAngle) * radius;

    final arrowTipX = center.dx + math.cos(arrowTipAngle) * (radius - arrowheadLength);
    final arrowTipY = center.dy + math.sin(arrowTipAngle) * (radius - arrowheadLength);

    // Draw the arrow line
    canvas.drawLine(Offset(arrowBaseX, arrowBaseY), Offset(arrowTipX, arrowTipY), paint);

    // Draw the arrowhead triangle
    final path = Path();
    path.moveTo(arrowTipX, arrowTipY);
    path.lineTo(
      arrowTipX + arrowheadLength * math.cos(arrowTipAngle - math.pi / 6),
      arrowTipY + arrowheadLength * math.sin(arrowTipAngle - math.pi / 6),
    );
    path.lineTo(
      arrowTipX + arrowheadLength * math.cos(arrowTipAngle + math.pi / 6),
      arrowTipY + arrowheadLength * math.sin(arrowTipAngle + math.pi / 6),
    );
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

