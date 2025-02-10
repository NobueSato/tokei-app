import 'package:flutter/material.dart';
import '../widgets/custom_button.dart'; // Import your CustomButton file here
import '../widgets/global_button_overlay.dart'; // Import your GlobalButtonOverlay file here

class FlipWidget extends StatelessWidget {
  final Widget child;

  FlipWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRect(
          child: Align(
            alignment: Alignment.topCenter,
            heightFactor: 0.5,
            child: child,
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 2.0),
        ),
        ClipRect(
          child: Align(
            alignment: Alignment.bottomCenter,
            heightFactor: 0.5,
            child: child,
          ),
        ),
      ],
    );
  }
}

class FlipScreen extends StatelessWidget {
  const FlipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2F2F2F), // Set background color to black
      body: Stack(
        children: [
          // Centered "Flip Mode" text wrapped with FlipWidget
          Center(
            child: FlipWidget(
              child: Text(
                'Flip Mode',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Global Button Overlay
          GlobalButtonOverlay(
            buttons: [
              CustomButton(
                text: 'CALENDAR',
                onPressed: () {
                  Navigator.pushNamed(context, '/calendar');
                },
                isSelected: false,
              ),
              CustomButton(
                text: 'WORLD CLOCK',
                onPressed: () {},
                isSelected: false,
              ),
              CustomButton(
                text: 'STOPWATCH',
                onPressed: () {},
                isSelected: false,
              ),
              CustomButton(
                text: 'TIMER',
                onPressed: () {},
                isSelected: false,
              ),
              CustomButton(
                text: 'D',
                onPressed: () {},
                isSelected: false,
              ),
              CustomButton(
                text: 'A',
                onPressed: () {},
                isSelected: false,
              ),
              CustomButton(
                text: '12H',
                onPressed: () {},
                isSelected: false,
              ),
              CustomButton(
                text: '24H',
                onPressed: () {},
                isSelected: false,
              ),
              CustomButton(
                text: '',
                onPressed: () {},
                isSelected: false,
              ),
              CustomButton(
                text: 'DATE',
                onPressed: () {},
                isSelected: false,
              ),
              CustomButton(
                text: 'NORMAL',
                onPressed: () {
                  Navigator.pop(context);
                },
                isSelected: true,
              ),
              CustomButton(
                text: 'FLIP',
                onPressed: () {
                  Navigator.pushNamed(context, '/flip');
                  print("flip is pressed");
                },
                isSelected: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
