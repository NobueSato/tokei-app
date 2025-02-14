import 'package:flutter/material.dart';
import '../services/clock_service.dart';

class ClockWidget extends StatefulWidget {
  final double fontSize;
  final double dateFontSize;
  final bool is12hSelected;
  final bool isDateSelected;

  const ClockWidget({
    super.key,
    required this.fontSize,
    required this.dateFontSize,
    required this.is12hSelected,
    required this.isDateSelected,
  });

  @override
  State<ClockWidget> createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget> {
  late ClockService _clockService;

  @override
  void initState() {
    super.initState();
    _clockService = ClockService(widget.is12hSelected);
    _clockService.onTimeUpdated = () {
      setState(() {}); // Redraw UI when time updates
    };
  }

  @override
  void dispose() {
    _clockService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    int row1height = isLandscape
        ? 2346 // 23.46% when it's landscape
        : 4310; // 43.10% when it's portrait
    int row2height = isLandscape
        ? 5334 // 5334% when it's landscape
        : 2986; // 13.8% when it's portrait
    int row3Height = isLandscape
        ? 1546 // 15.46% when it's landscape
        : 4310; // 43.1% when it's portrait
    int row2column1width = isLandscape
        ? 1318 // 13.18% when it's landscape
        : 2133; // 21.33% when it's portrait
    int row2column2width = isLandscape
        ? 7512 // 75.12% when it's landscape
        : 5707; // 57.07% when it's portrait
    int row2column3width = isLandscape
        ? 1170 // 11.70% when it's landscape
        : 2106; // 21.06% when it's portrait
    int dateHeight = isLandscape
        ? 0774 // 12.67% when it's landscape
        : 1516; // 15.16% when it's portrait

    return Column(
      children: [
        // Row 1: Space above the clock
        Expanded(
          flex: row1height,
          child: Container(),
        ),

        // Row 2: Clock
        Expanded(
          flex: row2height,
          child: Row(
            children: [
              // Space between AM/PM and clock
              Expanded(
                flex: row2column1width, // 14.04% of the row's width
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: row2column1width * 0.5,
                      height: row2height * 0.017,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween, // Space in between
                            children: [
                              // AM Text
                              Text(
                                'AM',
                                style: TextStyle(
                                  fontSize: widget.fontSize * 0.1,
                                  fontWeight: FontWeight.w600,
                                  color: _clockService.amPm == 'PM'
                                      ? Colors.grey
                                      : Colors.black,
                                ),
                              ),
                              // SizedBox(height: widget.fontSize * 0.2),
                              // PM Text
                              Text(
                                'PM',
                                style: TextStyle(
                                  fontSize: widget.fontSize * 0.1,
                                  fontWeight: FontWeight.w600,
                                  color: _clockService.amPm == 'AM'
                                      ? Colors.grey
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Time Text
              Expanded(
                flex: row2column2width,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double availableWidth =
                        constraints.maxWidth; // Get the parent width
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Hours
                        Container(
                          width: availableWidth * 0.41,
                          alignment: Alignment.centerRight,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              // _clockService.hours,
                              "02",
                              style: TextStyle(
                                fontSize: widget.fontSize,
                                fontWeight: FontWeight.w700,
                                height: 1.0,
                                letterSpacing: -1,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ),
                        // Colon
                        Container(
                          width: availableWidth * 0.12,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              FittedBox(
                                fit: BoxFit.contain,
                                child: Opacity(
                                  opacity:
                                      _clockService.isColonVisible ? 1.0 : 0.0,
                                  child: Center(
                                    child: Text(
                                      ':',
                                      style: TextStyle(
                                        fontSize: widget.fontSize,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                        height: 0.8,
                                      ),
                                      textHeightBehavior:
                                          const TextHeightBehavior(
                                        applyHeightToFirstAscent: true,
                                        applyHeightToLastDescent: false,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Minutes
                        Container(
                          width: availableWidth * 0.41,
                          alignment: Alignment.centerLeft,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              // _clockService.minutes,
                              "36",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: widget.fontSize,
                                fontWeight: FontWeight.w700,
                                height: 1.0,
                                letterSpacing: -1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Expanded(
                flex: row2column3width,
                child: Container(color: Colors.transparent),
              ),
            ],
          ),
        ),
        // Date Text
        Expanded(
          flex: dateHeight,
          child: Container(
            alignment: Alignment.center,
            child: widget.isDateSelected
                ? Text(
                    _clockService.date,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: widget.dateFontSize * 0.90,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                : null,
          ),
        ),
        Expanded(
          flex: row3Height, // 15.47% of the parent's height
          child: Container(),
        ),
      ],
    );
  }
}
