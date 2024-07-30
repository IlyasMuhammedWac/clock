import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class ClockWidget extends StatefulWidget {
  final double borderWidth;
  final double width;
  final double height;
  final BoxDecoration decoration;

  const ClockWidget({
    super.key,
    required this.borderWidth,
    this.width = double.infinity,
    this.height = double.infinity,
    this.decoration = const BoxDecoration(),
  });

  @override
  State<ClockWidget> createState() => ClockWidgetState();
}

class ClockWidgetState extends State<ClockWidget> {
  late DateTime _dateTime;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _dateTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _dateTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ClockPainter(_dateTime, borderWidth: widget.borderWidth),
      child: SizedBox(
        height: widget.height,
        width: widget.width,
      ),
    );
  }
}

class ClockPainter extends CustomPainter {
  final DateTime _dateTime;
  final double _borderWidth;

  ClockPainter(
    this._dateTime, {
    required double borderWidth,
  }) : _borderWidth = borderWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = min(size.width, size.height) / 2;
    final double borderWidth = _borderWidth;

    canvas.translate(size.width / 2, size.height / 2);
    var paint = Paint()
      ..color = const Color(0xff003366)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(0, 0), radius, paint);

    // Border style
    if (borderWidth > 0) {
      Paint borderPaint = Paint()
        ..color = Colors.blueAccent
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderWidth
        ..isAntiAlias = true;
      canvas.drawCircle(
          const Offset(0, 0), radius - borderWidth / 2, borderPaint);
    }

    double L = 150;
    double S = 6;
    _paintHourHand(canvas, L / 2.0, S);
    _paintMinuteHand(canvas, L / 1.4, S / 1.4);
    _paintSecondHand(canvas, L / 1.2, S / 3);
  }

  void _paintHourHand(Canvas canvas, double radius, double strokeWidth) {
    double angle = (_dateTime.hour % 12 + _dateTime.minute / 60) * 30 - 90;
    Offset handOffset = Offset(
      cos(_getRadians(angle)) * radius,
      sin(_getRadians(angle)) * radius,
    );
    final hourHandPaint = Paint()
      ..color = const Color(0xffC0C0C0)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    canvas.drawLine(const Offset(0, 0), handOffset, hourHandPaint);
  }


  void _paintMinuteHand(Canvas canvas, double radius, double strokeWidth) {
    double angle = (_dateTime.minute + _dateTime.second / 60) * 6 - 90;
    Offset handOffset = Offset(
      cos(_getRadians(angle)) * radius,
      sin(_getRadians(angle)) * radius,
    );
    final minuteHandPaint = Paint()
      ..color = const Color(0xffFFD700)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    canvas.drawLine(const Offset(0, 0), handOffset, minuteHandPaint);
  }

  void _paintSecondHand(Canvas canvas, double radius, double strokeWidth) {
    double angle = _dateTime.second * 6 - 90;
    Offset handOffset = Offset(
      cos(_getRadians(angle)) * radius,
      sin(_getRadians(angle)) * radius,
    );
    final secondHandPaint = Paint()
      ..color = const Color(0xffFF0000)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    canvas.drawLine(const Offset(0, 0), handOffset, secondHandPaint);
  }

  @override
  bool shouldRepaint(covariant ClockPainter oldDelegate) {
    return _dateTime != oldDelegate._dateTime ||
        _borderWidth != oldDelegate._borderWidth;
  }

  static double _getRadians(double angle) {
    return angle * pi / 180;
  }
}
