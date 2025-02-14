import 'package:flutter/material.dart';

class ClockTheme {
  final String name;
  final BoxDecoration backgroundColor; // Change from Color to BoxDecoration
  final Color secondaryBackgroundColor;
  final Color textColor;
  final Color secondaryTextColor;
  final Color borderColor;
  final Color hourHandColor;
  final Color minuteHandColor;

  const ClockTheme({
    required this.name,
    required this.backgroundColor,
    required this.secondaryBackgroundColor,
    required this.textColor,
    required this.secondaryTextColor,
    required this.borderColor,
    required this.hourHandColor,
    required this.minuteHandColor,
  });

  static final List<ClockTheme> themes = [
    const ClockTheme(
      name: "Light",
      backgroundColor: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFD3D5E0), Color(0xFFD7D9E5)],
          stops: [0.045, 0.949],
          transform:
              GradientRotation(11 * 3.14159 / 180), // Apply 11-degree rotation
        ),
      ),
      secondaryBackgroundColor: Color(0xFFFFFFFF),
      textColor: Color(0xFF2C3E50),
      secondaryTextColor: Color(0xFFE0E6ED),
      borderColor: Colors.black,
      hourHandColor: Color(0xFF2C3E50),
      minuteHandColor: Color(0xFF2C3E50),
    ),
  ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClockTheme &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}
