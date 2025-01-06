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
  final Function()? onEyeTap; // Add onEyeTap callback

  const CustomTextField({
    super.key,
    this.labelText = '',
    required this.controller,
    this.obscureText = false,
    this.prefixText,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.onEyeTap, // Add onEyeTap to the constructor
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style:
          TextStyle(fontFamily: 'Inter', fontSize: 13, color: Colors.grey[600]),
      obscureText: obscureText,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 12,horizontal: 12),
        filled: true,
        fillColor: Colors.white,
        hintText: labelText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintStyle: TextStyle(
            fontFamily: 'Inter', fontSize: 13, color: Colors.grey[400]),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide:
              BorderSide(color: Colors.grey[300] ?? Colors.grey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide:
              BorderSide(color: Colors.grey[500] ?? Colors.grey, width: 1),
        ),
        prefixText: prefixText,
        prefixStyle: TextStyle(
          color: Colors.grey[800],
          fontSize: 13,
          fontWeight: FontWeight.normal,
        ),
        suffixIcon: onEyeTap != null
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey[400],
                  size: 20,
                ),
                onPressed: onEyeTap,
                splashColor: Colors.transparent, // Remove splash effect
                highlightColor: Colors.transparent,
              )
            : null, // Add the eye icon if onEyeTap is provided
      ),
    );
  }
}
