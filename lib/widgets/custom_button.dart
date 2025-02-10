import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isSelected;

  const CustomButton({
    required this.text,
    required this.onPressed,
    required this.isSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    double buttonFontSize = isLandscape ? 18.0 : 14.0;
    // If text is empty, return an empty SizedBox
    if (text.isEmpty) {
      return SizedBox.shrink(); // No button rendered
    }

    // Otherwise, return the ElevatedButton
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor:
            isSelected ? const Color(0xFFB9BCCD) : const Color(0x80FFFFFF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        // padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
      ),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Text(
          text,
          style: TextStyle(
            color: Color(0xFF2F2F2F),
            fontSize: buttonFontSize,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
