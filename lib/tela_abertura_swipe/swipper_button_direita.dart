import 'package:flutter/material.dart';

class SwiperButton extends StatefulWidget {
  final VoidCallback onSwipeRight;
  const SwiperButton({super.key, required this.onSwipeRight});

  @override
  State<SwiperButton> createState() => _SwiperButtonState();
}

class _SwiperButtonState extends State<SwiperButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutBack,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSwipeRight() {
    _controller.forward();
    widget.onSwipeRight(); // Call the provided callback
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx > 0) {
          _controller.value = details.globalPosition.dx / context.size!.width;
        } else {
          _controller.value = 0.0;
        }
      },
      onHorizontalDragEnd: (_) {
        if (_controller.value >= 0.7) {
          _onSwipeRight();
        } else {
          _controller.reset();
        }
      },
      child: Stack(
        children: [
          // Background arc (upward curve)
          SizedBox(
            width: double.infinity, // Occupy full width
            height: 10.0,
            child: CustomPaint(
              painter: ArcPainter(
                progress: _animation.value,
                isUpwardCurve: true, // Specify upward curve
              ),
            ),
          ),

          // Animated sliding progress bar
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) => Transform.translate(
              offset: Offset(_animation.value * context.size!.width, 0),
              child: Container(
                width: context.size!.width, // Full width
                height: 5.0,
                color: Colors.blue,
              ),
            ),
          ),

          // Button with icon (always at the end)
          Positioned(
            right: 0.0, // Pin to the right edge
            child: Container(
              width: 50.0,
              height: 50.0,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: const Icon(Icons.arrow_forward_ios),
            ),
          ),
        ],
      ),
    );
  }
}

class ArcPainter extends CustomPainter {
  final double progress;
  final bool isUpwardCurve;

  ArcPainter({required this.progress, required this.isUpwardCurve});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    Path path = Path();
    path.moveTo(0, size.height / 2);

    double controlPointY = isUpwardCurve ? size.height * 1.5 : size.height / 3;
    path.quadraticBezierTo(size.width / 2, controlPointY, size.width, size.height / 2);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
