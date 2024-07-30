import 'package:analog_clock/clock_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: ClockWidget(
          borderWidth: 5,
          height: 300,
          width: 300,
        ),
      ),
    );
  }
}
