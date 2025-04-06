import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

enum TickMode {
  none, // No ticks, no numbers
  onlyTicks, // Only ticks, no numbers
  onlyNumbers_4, // Only 12, 3, 6, 9
  onlyNumbers_12, // All numbers from 1-12
  twoBetweenNumbers, // Two ticks between numbers (when 12, 3, 6, 9 are visible)
  fourBetweenNumbers, // Four ticks between numbers (when all the numbers are visible)
}

class CustomAnalogClockWidget extends StatefulWidget {
  final double clockSize;
  final double hourHandLength;
  final double minuteHandLength;
  final double secondHandLength;
  final Color hourHandColor;
  final Color minuteHandColor;
  final Color secondHandColor;
  final Color tickColor;
  final Color numberColor;
  final TickMode tickMode;
  final bool showTime;
  final bool showDate;
  final bool isDebugging;

  const CustomAnalogClockWidget({
    Key? key,
    required this.clockSize,
    required this.hourHandLength,
    required this.minuteHandLength,
    required this.secondHandLength,
    required this.hourHandColor,
    required this.minuteHandColor,
    required this.secondHandColor,
    required this.tickColor,
    required this.numberColor,
    required this.tickMode,
    this.showTime = true,
    this.showDate = true,
    this.isDebugging = false,
  }) : super(key: key);

  @override
  _CustomAnalogClockWidgetState createState() =>
      _CustomAnalogClockWidgetState();
}

class _CustomAnalogClockWidgetState extends State<CustomAnalogClockWidget> {
  late Timer _timer;
  DateTime _currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
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
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          color: widget.isDebugging ? Colors.red : Colors.transparent,
          child: SizedBox(
            width: widget.clockSize,
            height: widget.clockSize,
            child: CustomPaint(
              painter: ClockPainter(
                hourHandLength: widget.hourHandLength,
                minuteHandLength: widget.minuteHandLength,
                secondHandLength: widget.secondHandLength,
                hourHandColor: widget.hourHandColor,
                minuteHandColor: widget.minuteHandColor,
                secondHandColor: widget.secondHandColor,
                tickColor: widget.tickColor,
                numberColor: widget.numberColor,
                tickMode: widget.tickMode,
                currentTime: _currentTime,
              ),
            ),
          ),
        ),
        if (widget.showTime || widget.showDate)
          Positioned(
            bottom: widget.clockSize *
                0.33, // Adjust position relative to clock size
            child: Column(
              children: [
                if (widget.showTime)
                  Text(
                    _formatTime(_currentTime), // Digital Time
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: widget.numberColor),
                  ),
                if (widget.showTime) SizedBox(height: 5),
                if (widget.showDate)
                  Text(
                    _formatDate(_currentTime), // Date
                    style: TextStyle(fontSize: 14, color: widget.numberColor),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  String _formatTime(DateTime time) {
    return "${time.hour % 12 == 0 ? 12 : time.hour % 12}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')} ${time.hour < 12 ? 'AM' : 'PM'}";
  }

  String _formatDate(DateTime time) {
    return "${time.year}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')} ${_getWeekday(time.weekday)}";
  }

  String _getWeekday(int weekday) {
    return [
      "MONDAY",
      "TUEDAY",
      "WEDNESDAY",
      "THURSDAY",
      "FRIDAY",
      "SATURDAY",
      "SUNDAY"
    ][weekday - 1];
  }

  String _getMonth(int month) {
    return [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ][month - 1];
  }
}

class ClockPainter extends CustomPainter {
  final double hourHandLength;
  final double minuteHandLength;
  final double secondHandLength;
  final Color hourHandColor;
  final Color minuteHandColor;
  final Color secondHandColor;
  final Color tickColor;
  final Color numberColor;
  final TickMode tickMode;
  final DateTime currentTime;

  ClockPainter({
    required this.hourHandLength,
    required this.minuteHandLength,
    required this.secondHandLength,
    required this.hourHandColor,
    required this.minuteHandColor,
    required this.secondHandColor,
    required this.tickColor,
    required this.numberColor,
    required this.tickMode,
    required this.currentTime,
  });

  void drawTick(
      Canvas canvas, Offset center, double length, double angle, Paint paint) {
    final p1 = Offset(
        center.dx + length * cos(angle), center.dy + length * sin(angle));
    final p2 = Offset(center.dx + (length - 10) * cos(angle),
        center.dy + (length - 10) * sin(angle));
    canvas.drawLine(p1, p2, paint);
  }

  void drawNumber(Canvas canvas, Offset center, double radius, String number,
      double angle, TextPainter textPainter) {
    final textSpan = TextSpan(
      text: number,
      style: TextStyle(
          fontSize: 18, fontWeight: FontWeight.bold, color: numberColor),
    );

    textPainter.text = textSpan;
    textPainter.layout();

    final x = center.dx + radius * cos(angle) - textPainter.width / 2;
    final y = center.dy + radius * sin(angle) - textPainter.height / 2;
    textPainter.paint(canvas, Offset(x, y));
  }

  void drawHand(Canvas canvas, Offset center, double length, double angle,
      Color color, double strokeWidth) {
    final handPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    final handEnd = Offset(center.dx + length * cos(angle - pi / 2),
        center.dy + length * sin(angle - pi / 2));
    canvas.drawLine(center, handEnd, handPaint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final tickPaint = Paint()
      ..color = tickColor
      ..strokeWidth = 2;
    final textPainter = TextPainter(
        textAlign: TextAlign.center, textDirection: TextDirection.ltr);

    List<double> tickPositions;
    List<int> numbersToShow;

    switch (tickMode) {
      case TickMode.onlyTicks:
        tickPositions = List.generate(12, (i) => i + 1);
        numbersToShow = [];
        break;
      case TickMode.onlyNumbers_4:
        tickPositions = [];
        numbersToShow = [12, 3, 6, 9];
        break;
      case TickMode.onlyNumbers_12:
        tickPositions = [];
        numbersToShow = List.generate(12, (i) => i + 1);
        break;
      case TickMode.twoBetweenNumbers:
        tickPositions = [
          1,
          2,
          4,
          5,
          7,
          8,
          10,
          11
        ]; // Minor ticks between major numbers
        numbersToShow = [12, 3, 6, 9]; // Major numbers without ticks
        break;
      case TickMode.fourBetweenNumbers:
        tickPositions = []; // All numbers 1 to 12, with 4 ticks in between each
        numbersToShow = [
          12,
          1,
          2,
          3,
          4,
          5,
          6,
          7,
          8,
          9,
          10,
          11
        ]; // No separate numbers, all will be drawn
        // Generate minor tick positions (4 ticks between each number)
        for (int number = 1; number <= 12; number++) {
          for (double i = 0.2; i < 1.0; i += 0.2) {
            tickPositions.add(number + i); // Example: 1.2, 1.4, ..., 11.8
          }
        }
        break;

      case TickMode.none:
        tickPositions = [];
        numbersToShow = [];
        break;
    }

    // Draw the minor ticks (for TickMode.twoBetweenNumbers and TickMode.fourBetweenNumbers)
    for (double tick in tickPositions) {
      double angle =
          ((tick - 3) * 30) * pi / 180; // Adjusted angle for correct rotation
      drawTick(canvas, center, radius - 20, angle, tickPaint);
    }

    // Draw the major numbers (12, 3, 6, 9) or all numbers for TickMode.onlyNumbers_12
    for (int number in numbersToShow) {
      double angle =
          ((number - 3) * 30) * pi / 180; // Adjusted angle for correct rotation
      drawNumber(
          canvas, center, radius - 30, number.toString(), angle, textPainter);
    }

    // Draw hour, minute, and second hands
    double hourAngle =
        ((currentTime.hour % 12) + currentTime.minute / 60) * 30 * pi / 180;
    double minuteAngle =
        (currentTime.minute + currentTime.second / 60) * 6 * pi / 180;
    double secondAngle = currentTime.second * 6 * pi / 180;

    drawHand(canvas, center, hourHandLength, hourAngle, hourHandColor, 6);
    drawHand(canvas, center, minuteHandLength, minuteAngle, minuteHandColor, 4);
    drawHand(canvas, center, secondHandLength, secondAngle, secondHandColor, 2);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
