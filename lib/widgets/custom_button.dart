import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isSelected;

  const CustomButton({
    required this.text,
    required this.onPressed,
    required this.isSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
