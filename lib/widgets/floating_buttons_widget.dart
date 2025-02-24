import 'package:flutter/material.dart';

class FloatingButtonsWidget extends StatefulWidget {
  final Widget
      child; // The main content for the screen (like Calendar, Stopwatch, etc.)

  FloatingButtonsWidget({required this.child});

  @override
  _FloatingButtonsWidgetState createState() => _FloatingButtonsWidgetState();
}

class _FloatingButtonsWidgetState extends State<FloatingButtonsWidget> {
  bool _showButtons = false;
  bool _isGestureArea = false; // Flag for excluding gesture area

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!_isGestureArea) {
          setState(() {
            _showButtons = false;
          });
        }
      },
      child: Stack(
        children: [
          widget
              .child, // The main content for the screen (passed as widget.child)

          // Gesture area (e.g., calendar or stopwatch view) that ignores taps
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isGestureArea = true;
                });
              },
              child: Container(color: Colors.transparent),
            ),
          ),

          // Buttons that appear when _showButtons is true
          if (_showButtons)
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => showModeScreen(context),
                    child: Text('Mode'),
                  ),
                  ElevatedButton(
                    onPressed: () => showWowScreen(context),
                    child: Text('Wow'),
                  ),
                  ElevatedButton(
                    onPressed: () => showSettingsScreen(context),
                    child: Text('Settings'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // Function to show Mode screen (blurred background, 11 buttons)
  void showModeScreen(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.black54,
          child: Column(
            children: List.generate(11, (index) {
              return ElevatedButton(
                onPressed: () {},
                child: Text('Mode $index'),
              );
            }),
          ),
        );
      },
    );
  }

  // Function to show Wow screen (blurred background, 3 buttons)
  void showWowScreen(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.black54,
          child: Column(
            children: List.generate(3, (index) {
              return ElevatedButton(
                onPressed: () {},
                child: Text('Wow $index'),
              );
            }),
          ),
        );
      },
    );
  }

  // Function to show Settings screen (blurred background, 3 buttons)
  void showSettingsScreen(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.black54,
          child: Column(
            children: List.generate(3, (index) {
              return ElevatedButton(
                onPressed: () {},
                child: Text('Settings $index'),
              );
            }),
          ),
        );
      },
    );
  }
}
