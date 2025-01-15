import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomTextButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed, // Add this to handle the tap event
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 12,
            fontFamily: 'Inter',
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}
