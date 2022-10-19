import 'package:flutter/material.dart';

IconData rentabilityIcon(double rentability) {
  if (rentability < 0) {
    return Icons.arrow_downward;
  }
  return Icons.arrow_upward;
}

Color rentabilityColor(double rentability) {
  if (rentability < 0) {
    return Colors.redAccent;
  }
  return Colors.greenAccent;
}
