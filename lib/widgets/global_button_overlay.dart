import 'dart:async';
import 'package:flutter/material.dart';
import 'custom_button.dart'; // Import your CustomButton file here

class GlobalButtonOverlay extends StatefulWidget {
  final List<CustomButton> buttons;

  const GlobalButtonOverlay({required this.buttons, Key? key})
      : super(key: key);

  @override
  State<GlobalButtonOverlay> createState() => _GlobalButtonOverlayState();
}

class _GlobalButtonOverlayState extends State<GlobalButtonOverlay> {
  bool _isVisible = false; // Controls the visibility of the buttons
  Timer? _hideTimer;

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  // Function to toggle the visibility of the buttons
  void _toggleButtons() {
    setState(() {
      if (_isVisible) {
        _isVisible = false;
        _hideTimer?.cancel(); // Cancel the timer if hiding buttons
      } else {
        _isVisible = true;
        // Start the timer to hide buttons automatically
        _hideTimer?.cancel();
        _hideTimer = Timer(const Duration(seconds: 3), () {
          setState(() {
            _isVisible = false;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Detect orientation
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _toggleButtons, // Toggle buttons on tap
      child: Align(
        alignment: Alignment.bottomCenter, // Align buttons at the bottom
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Visibility(
            visible: _isVisible, // Control visibility without animation
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), // Border radius
              ),
              child: Column(
                children: [
                  // 1st Row (Horizontal, 4 buttons)
                  Container(
                    height: MediaQuery.of(context).size.height *
                        0.21, // Fixed height for the row
                    width: MediaQuery.of(context).size.width *
                        0.83, // Fixed width for the row
                    child: Row(
                      children: widget.buttons
                          .take(4) // Limit to the first 4 buttons
                          .map((button) =>
                              Expanded(child: button)) // Ensure equal space
                          .expand((widget) => [
                                widget,
                                SizedBox(width: 6)
                              ]) // Add space between buttons
                          .toList()
                        ..removeLast(), // Remove the last SizedBox
                    ),
                  ),

                  // 2nd Row (Vertical, 2 buttons)
                  Container(
                    height: MediaQuery.of(context).size.height *
                        0.608, // Fixed height for second row
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.51,
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.21,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (widget.buttons.length >
                                  4) // Check if there are more than 4 buttons
                                SizedBox(
                                  width: 50, // Set the desired width
                                  height: 40, // Set the desired height
                                  child: widget.buttons[4],
                                ), // D button
                              if (widget.buttons.length > 5) ...[
                                const SizedBox(height: 30),
                                SizedBox(
                                  width: 50, // Set the desired width
                                  height: 40, // Set the desired height
                                  child: widget.buttons[5],
                                ), // A button
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 3rd Row (Horizontal, 5 buttons)
                  Flexible(
                    flex: 2,
                    child: Container(
                      height: MediaQuery.of(context).size.height *
                          0.1573, // Fixed height for third row
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: !isPortrait
                          ? Container(
                              width: MediaQuery.of(context).size.width * 0.83,
                              child: Column(children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(6, (index) {
                                    int buttonIndex = index +
                                        6; // Start from the 7th button (index 6)
                                    if (buttonIndex != 8) {
                                      // Button exists at this index
                                      return Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            _toggleButtons(); // Reset timer on button tap
                                            widget.buttons[buttonIndex]
                                                .onPressed(); // Call the button's onPressed
                                          },
                                          child: widget.buttons[
                                              buttonIndex], // Remove Expanded here
                                        ),
                                      );
                                    } else {
                                      return Offstage(
                                        offstage: true,
                                        child: Container(
                                            // Widget content
                                            ),
                                      );
                                    }
                                  })
                                      .expand((widget) => [
                                            widget,
                                            const SizedBox(
                                                width:
                                                    6), // Add space between buttons
                                          ]) // Add spacing
                                      .toList()
                                    ..removeLast(), // Remove the last SizedBox
                                )
                              ]),
                            )
                          : GridView.count(
                              crossAxisCount: 3,
                              mainAxisSpacing: 8.0,
                              crossAxisSpacing: 8.0,
                              physics: const NeverScrollableScrollPhysics(),
                              childAspectRatio: 2.0,
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(8.0),
                              children: List.generate(6, (index) {
                                int buttonIndex = index + 6; // Start from [6]
                                return widget.buttons.length > buttonIndex
                                    ? GestureDetector(
                                        onTap: () {
                                          _toggleButtons(); // Reset timer on button tap
                                          widget.buttons[buttonIndex]
                                              .onPressed(); // Call original onPressed
                                        },
                                        child: widget.buttons[buttonIndex],
                                      )
                                    : Container();
                              }),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
