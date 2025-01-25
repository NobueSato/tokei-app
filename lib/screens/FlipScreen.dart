import 'package:flutter/material.dart';
import '../widgets/custom_button.dart'; // Import your CustomButton file here
import '../widgets/global_button_overlay.dart'; // Import your GlobalButtonOverlay file here

class FlipScreen extends StatelessWidget {
  const FlipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background color to black
      body: Stack(
        children: [
          // Centered "Flip Mode" text
          Center(
            child: Text(
              'Flip Mode',
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Global Button Overlay
          GlobalButtonOverlay(
            buttons: [
              CustomButton(
                text: 'Calendar',
                onPressed: () {
                  // Add logic for 12h button
                },
                isSelected: false, // Adjust selected state based on your logic
              ),
              CustomButton(
                text: 'D',
                onPressed: () {
                  // Add logic for 12h button
                },
                isSelected: false, // Adjust selected state based on your logic
              ),
              CustomButton(
                text: 'A',
                onPressed: () {
                  // Add logic for 12h button
                },
                isSelected: false, // Adjust selected state based on your logic
              ),
              CustomButton(
                text: '12h',
                onPressed: () {
                  // Add logic for 12h button
                },
                isSelected: false, // Adjust selected state based on your logic
              ),
              CustomButton(
                text: '', // Empty text for an empty button
                onPressed: () {},
                isSelected: false,
              ),
              CustomButton(
                text: 'Date',
                onPressed: () {
                  // Add logic for Date button
                },
                isSelected: false, // Adjust selected state based on your logic
              ),
              CustomButton(
                text: '24h',
                onPressed: () {
                  // Add logic for 24h button
                },
                isSelected: false,
              ),
              CustomButton(
                text: 'Normal',
                onPressed: () {
                  // Navigate back to the ClockScreen when the 'Normal' button is pressed
                  Navigator.pop(context);
                },
                isSelected: false,
              ),
              CustomButton(
                text: 'Flip',
                onPressed: () {
                  // Add logic for Flip button
                },
                isSelected: true, // Mark the Flip button as selected
              ),
            ],
          ),
        ],
      ),
    );
  }
}
