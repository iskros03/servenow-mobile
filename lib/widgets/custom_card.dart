import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final Color cardColor;
  final double elevation;
  final EdgeInsetsGeometry padding;

  const CustomCard(
      {super.key,
      required this.child,
      required this.cardColor,
      this.elevation = 0,
      this.padding = const EdgeInsets.all(15)}); // Default padding value

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardColor,
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7.5),
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
