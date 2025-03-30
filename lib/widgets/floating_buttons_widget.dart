import 'package:flutter/material.dart';
import 'dart:async'; // For Timer

class FloatingButtonsWidget extends StatefulWidget {
  final Widget
      child; // The main content for the screen (like Calendar, Stopwatch, etc.)
  final void Function(int)? onButtonPressed; // Callback to parent

  FloatingButtonsWidget({required this.child, this.onButtonPressed});

  @override
  _FloatingButtonsWidgetState createState() => _FloatingButtonsWidgetState();
}

class _FloatingButtonsWidgetState extends State<FloatingButtonsWidget> {
  bool _showButtons = false;
  bool _isGestureArea = false; // Flag for excluding gesture area
  late Timer _hideButtonsTimer;

  // Toggle buttons when tapping outside red area
  void _toggleButtons() {
    setState(() {
      _showButtons = !_showButtons;
    });
    if (_showButtons) {
      _startHideTimer();
    } else {
      _hideButtonsTimer.cancel();
    }
  }

  // Reset timer if user interacts with an overlay button
  void _resetHideTimer() {
    if (_hideButtonsTimer.isActive) {
      _hideButtonsTimer.cancel();
    }
    _startHideTimer();
  }

  // Start a 5-second timer to auto-hide buttons
  void _startHideTimer() {
    _hideButtonsTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        // _activeButtonIndex = -1;
        _showButtons = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen width for responsive spacing
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    // Calculate responsive spacing based on screen width
    double horizontalSpacing = (screenWidth / 812) * 41;
    double vertiaclSpacing = (screenHeight / 375) * 71;
    double spaceBetween =
        isLandscape ? (screenHeight / 375) * 40 : (screenHeight / 812) * 40;
    double buttonSize = isLandscape ? 50.0 : 40.0;

    return GestureDetector(
      onTap: () {
        if (!_isGestureArea) {
          _toggleButtons();
        }
      },
      child: Stack(children: [
        widget
            .child, // The main content for the screen (passed as widget.child)

        // Floating Action Buttons (FABs)
        Visibility(
          visible: _showButtons,
          child: Positioned(
            right: horizontalSpacing,
            top: vertiaclSpacing,
            bottom: vertiaclSpacing,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildFAB(Icons.menu, 0, "Mode button pressed", buttonSize),
                SizedBox(height: spaceBetween), // Space between buttons
                _buildFAB(Icons.widgets, 1, "Wow button pressed", buttonSize),
                SizedBox(height: spaceBetween),
                _buildFAB(Icons.settings_outlined, 2, "Settings button pressed",
                    buttonSize),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  // Helper function to build FABs with custom size and background color
  Widget _buildFAB(
      IconData icon, int buttonIndex, String logMessage, double buttonSize) {
    return SizedBox(
      width: buttonSize, // Smaller width
      height: buttonSize, // Smaller height
      child: FloatingActionButton.small(
        backgroundColor: const Color(0x80FFFFFF), // Default color
        elevation: 0, // Remove shadow
        highlightElevation: 0,
        hoverElevation: 0,
        child: Icon(icon, color: Color(0xFF2F2F2F)),
        onPressed: () {
          setState(() {
            _showButtons = !_showButtons; // Hide floating action buttons
          });
          _resetHideTimer();
          widget.onButtonPressed?.call(buttonIndex); // Callback to parent
          print(logMessage);
        },
      ),
    );
  }
}
