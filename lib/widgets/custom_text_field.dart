import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final bool obscureText;
  final String? prefixText;
  final int maxLines;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({
    super.key,
    this.labelText = '',
    required this.controller,
    this.obscureText = false,
    this.prefixText,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style:
          TextStyle(fontFamily: 'Inter', fontSize: 14, color: Colors.grey[600]),
      obscureText: obscureText,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(12.5),
        filled: true,
        fillColor: Colors.grey[100],
        hintText: labelText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintStyle: TextStyle(
            fontFamily: 'Inter', fontSize: 14, color: Colors.grey[600]),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide:
              BorderSide(color: Colors.grey[300] ?? Colors.grey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide:
              BorderSide(color: Colors.grey[300] ?? Colors.grey, width: 1),
        ),
        prefixText: prefixText,
        prefixStyle: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
