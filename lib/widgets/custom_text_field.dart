import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String? labelText;
  final TextEditingController controller;
  final bool obscureText;
  final String? prefixText;
  final int maxLines;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Function()? onEyeTap;
  final int? maxLength;

  const CustomTextField({
    super.key,
    this.labelText,
    required this.controller,
    this.obscureText = false,
    this.prefixText,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.onEyeTap,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style:
          TextStyle(fontFamily: 'Inter', fontSize: 13, color: Colors.grey[800]),
      obscureText: obscureText,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        filled: true,
        fillColor: Colors.white,
        hintText: labelText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintStyle: TextStyle(
            fontFamily: 'Inter', fontSize: 13, color: Colors.grey[500]),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(7.5)),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(color: Colors.grey.shade500, width: 1),
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
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              )
            : null,
        counterText: "",
      ),
    );
  }
}
