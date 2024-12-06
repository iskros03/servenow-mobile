import 'package:flutter/material.dart';

class CustomEleButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? bgColor;
  final Color? fgColor;
  final double borderRadius;
  final Color borderColor;
  final double borderWidth;
  final double fontSize;

  const CustomEleButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.bgColor,
    required this.fgColor,
    this.borderRadius = 8.0,
    this.borderColor = const Color.fromRGBO(24, 52, 92, 1),
    this.borderWidth = 1.0,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 17.5, vertical: 12.5),
        backgroundColor: bgColor,
        foregroundColor: fgColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(borderRadius), // Apply borderRadius
        ),
        side: BorderSide(
          color: borderColor,
          width: borderWidth,
        ),
      ),
      child: Text(text,
          style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              fontSize: fontSize)),
    );
  }
}
