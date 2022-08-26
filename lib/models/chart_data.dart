import 'package:flutter/material.dart';

class ChartData {
  ChartData({this.color, required this.description, required this.totalValue, this.shares});

  final Color? color;
  final String description;
  final double totalValue;
  final double? shares;
}
