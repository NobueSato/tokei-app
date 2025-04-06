import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/clock_service.dart';
import 'flip_panel_plus.dart';

class FlipClockWidget extends StatefulWidget {
  final double dateFontSize;
  final double amPmFontSize;
  const FlipClockWidget({
    super.key,
    required this.dateFontSize,
    required this.amPmFontSize,
  });

  @override
  State<FlipClockWidget> createState() => _FlipClockWidgetState();
}

class _FlipClockWidgetState extends State<FlipClockWidget>
    with TickerProviderStateMixin {
  late StreamController<int> _hoursController;
  late StreamController<int> _minutesController;
  String _hours = '';
  String _minutes = '';
  late Timer _timer;
  late ClockService clockService;
  bool isDebugging = false;

  @override
  void initState() {
    super.initState();
    clockService = Provider.of<ClockService>(context, listen: false);
    _hoursController = StreamController<int>.broadcast();
    _minutesController = StreamController<int>.broadcast();
    _hours = clockService.hours;
    _minutes = clockService.minutes;
    _updateTime();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _updateTime();
      });
    });
  }

  void _updateTime() {
    final hourChanged = clockService.hours != _hours;
    final minuteChanged = clockService.minutes != _minutes;

    // Add new values to the streams if there was a change
    if (hourChanged) {
      _hoursController.add(int.parse(clockService.hours));
    }
    if (minuteChanged) {
      _minutesController.add(int.parse(clockService.minutes));
    }

    _hours = clockService.hours;
    _minutes = clockService.minutes;
  }

  @override
  void dispose() {
    _timer.cancel();
    _hoursController.close();
    _minutesController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double spaceInBetween = MediaQuery.of(context).size.width * 0.05;
    final clockService = Provider.of<ClockService>(context);
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isPortrait = constraints.maxHeight > constraints.maxWidth;
          final baseSize = _calculateBaseSize(constraints, isPortrait);

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFD3D5E0), Color(0xFFD7D9E5)],
                stops: [0.045, 0.949],
                transform: GradientRotation(
                    11 * 3.14159 / 180), // Apply 11-degree rotation
              ),
            ),
            child: isPortrait
                ? _buildPortraitLayout(clockService, baseSize, constraints)
                : _buildLandscapeLayout(
                    clockService, baseSize, constraints, spaceInBetween),
          );
        },
      ),
    );
  }

  double _calculateBaseSize(BoxConstraints constraints, bool isPortrait) {
    final maxWidth = constraints.maxWidth;
    final maxHeight = constraints.maxHeight;

    if (isPortrait) {
      return math.min(maxWidth / 3, maxHeight / 10);
    } else {
      return math.min(maxWidth / 8, maxHeight / 2.5);
    }
  }

  Widget _buildPortraitLayout(
      ClockService clockService, double baseSize, BoxConstraints constraints) {
    final spacing = baseSize * 0.45;
    return Container(
      color: isDebugging ? Colors.pink : Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            color: isDebugging ? Colors.blue : Colors.transparent,
            height: baseSize * 4.6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Container(
                    color: isDebugging ? Colors.green : Colors.transparent,
                    width: double.infinity, // ✅ Expands up to maxWidth
                    height: constraints.maxHeight,
                    child: FittedBox(
                      fit: BoxFit.scaleDown, // ✅ Shrinks when screen is narrow
                      child: Row(
                        children: [
                          // AM/PM Container
                          Container(
                            color: isDebugging
                                ? Colors.orange
                                : Colors.transparent,
                            width: widget.amPmFontSize * 1.8,
                            //alignment: Alignment.centerRight,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // AM Text
                                Container(
                                  color: isDebugging
                                      ? Colors.green
                                      : Colors.transparent,
                                  child: Text(
                                    clockService.is12hSelected ? 'AM' : '',
                                    style: TextStyle(
                                      fontSize: widget.amPmFontSize,
                                      fontWeight: FontWeight.w600,
                                      backgroundColor: isDebugging
                                          ? Colors.yellow
                                          : Colors.transparent,
                                      color: clockService.amPm == 'PM'
                                          ? Color(0xFF8F8F8F)
                                          : Color(0xFF2F2F2F),
                                    ),
                                  ),
                                ),
                                // Space between AM/PM
                                SizedBox(
                                    height: baseSize *
                                        0.7), // Adjust this space as needed
                                // PM Text
                                Container(
                                  color: isDebugging
                                      ? Colors.amber
                                      : Colors.transparent,
                                  child: Text(
                                    clockService.is12hSelected ? 'PM' : '',
                                    style: TextStyle(
                                      fontSize: widget.amPmFontSize,
                                      fontWeight: FontWeight.w600,
                                      backgroundColor: isDebugging
                                          ? Colors.yellow
                                          : Colors.transparent,
                                      color: clockService.amPm == 'AM'
                                          ? Color(0xFF8F8F8F)
                                          : Color(0xFF2F2F2F),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                              width: spacing * 0.5), // Adjust proportionally
                          Column(
                            children: [
                              _buildFlipUnit(_hoursController.stream, baseSize,
                                  int.parse(_hours)),
                              SizedBox(height: 5),
                              _buildFlipUnit(_minutesController.stream,
                                  baseSize, int.parse(_minutes)),
                            ],
                          ),
                          SizedBox(
                              width: spacing * 1.5), // Adjust proportionally
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: baseSize * 0.5, // Reserve a fixed height for the date space
            color: isDebugging ? Colors.orange : Colors.transparent,
            child: clockService.isDateSelected
                ? Center(
                    child: Text(
                      clockService.date, // Display the date from clockService
                      style: TextStyle(
                        fontSize:
                            widget.dateFontSize, // Adjust font size as needed
                        fontWeight: FontWeight.w400,
                        color: Colors.black, // Adjust color as needed
                      ),
                    ),
                  )
                : null, // Keep the space reserved even when there's no date
          ),
        ],
      ),
    );
  }

  Widget _buildLandscapeLayout(ClockService clockService, double baseSize,
      BoxConstraints constraints, double spaceInBetween) {
    final availableWidth = constraints.maxWidth * 0.80;
    final unitWidth = availableWidth / 3.5;

    return Container(
      color: isDebugging ? Colors.purple : Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: SizedBox(
                  width: baseSize * 0.38, // Ensure consistent width
                  child: Container(
                    color: isDebugging ? Colors.green : Colors.transparent,
                    child: clockService.is12hSelected
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // AM Text
                              Text(
                                clockService.amPm == '' ? '' : 'AM',
                                style: TextStyle(
                                  fontSize: widget.amPmFontSize,
                                  fontWeight: FontWeight.w600,
                                  backgroundColor: isDebugging
                                      ? Colors.yellow
                                      : Colors.transparent,
                                  color: clockService.amPm == 'PM'
                                      ? Color(0xFF8F8F8F)
                                      : Color(0xFF2F2F2F),
                                ),
                              ),
                              SizedBox(
                                  height:
                                      baseSize * 0.5), // Adjust proportionally
                              // PM Text
                              Text(
                                clockService.amPm == '' ? '' : 'PM',
                                style: TextStyle(
                                  fontSize: widget.amPmFontSize,
                                  fontWeight: FontWeight.w600,
                                  backgroundColor: isDebugging
                                      ? Colors.yellow
                                      : Colors.transparent,
                                  color: clockService.amPm == 'AM'
                                      ? Color(0xFF8F8F8F)
                                      : Color(0xFF2F2F2F),
                                ),
                              ),
                            ],
                          )
                        : SizedBox.shrink(), // Keep width consistent
                  ),
                ),
              ),

              // Responsive Space
              SizedBox(width: baseSize * 0.2), // Adjust proportionally
              _buildFlipUnit(_hoursController.stream, baseSize,
                  int.parse(_hours), unitWidth),
              _buildSeparator(spaceInBetween),
              _buildFlipUnit(_minutesController.stream, baseSize,
                  int.parse(_minutes), unitWidth),
              SizedBox(width: baseSize * 0.54), // Adjust proportionally
            ],
          ),
          Container(
            height: baseSize * 0.5, // Reserve a fixed height for the date space
            color: isDebugging ? Colors.orange : Colors.transparent,
            child: clockService.isDateSelected
                ? Center(
                    child: Text(
                      clockService.date, // Display the date from clockService
                      style: TextStyle(
                        fontSize:
                            widget.dateFontSize, // Adjust font size as needed
                        fontWeight: FontWeight.w400,
                        color: Colors.black, // Adjust color as needed
                      ),
                    ),
                  )
                : null, // Keep the space reserved even when there's no date
          ),
        ],
      ),
    );
  }

  Widget _buildFlipUnit(Stream<int> stream, double baseSize, int initialValue,
      [double? width]) {
    double panelWidth = baseSize * 2.2;
    double panelHeight = baseSize * 2;
    return SizedBox(
      width: panelWidth,
      height: panelHeight,
      child: FlipPanelPlus<int>.stream(
        itemStream: stream,
        itemBuilder: (context, value) => _buildPairCard(value, baseSize),
        initValue: initialValue,
        duration: const Duration(milliseconds: 450),
        spacing: baseSize * 0.02,
        direction: FlipDirection.down,
      ),
    );
  }

  Widget _buildPairCard(int value, double baseSize) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(baseSize * 0.1)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(baseSize * 0.1),
        child: CustomPaint(
          painter: CardPainter(baseSize: baseSize),
          child: Center(
            child: FittedBox(
              fit: BoxFit.contain,
              child: Padding(
                padding: EdgeInsets.all(baseSize * 0.1),
                child: Text(
                  value.toString().padLeft(2, '0'),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: baseSize * 1.2,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 2.0,
                        color: Color.fromRGBO(0, 0, 0, 0.5),
                        offset: const Offset(1.0, 1.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSeparator(double baseSize) {
    return SizedBox(
      width: baseSize * 0.5,
      height: baseSize * 1.8,
    );
  }
}

class CardPainter extends CustomPainter {
  final double baseSize;

  CardPainter({
    required this.baseSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    // Draw main background
    paint.color = Colors.white;
    canvas.drawRect(rect, paint);

    // Draw horizontal line
    paint.color = Color.fromRGBO(0, 0, 0, 0.5);

    paint.strokeWidth = 1;
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
