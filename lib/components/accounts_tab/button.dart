import 'package:flutter/material.dart';

class PillButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;

  const PillButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = Colors.grey,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Material(
         type: MaterialType.transparency, // Enables ripple effect
        borderRadius: BorderRadius.circular(30), // Match container border radius
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30), // Adjust the radius as needed
            color: color, // Button background color
          ),
          child: Text(
            text,
            style: TextStyle(
              color: textColor, // Button text color
              fontSize: 13.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
