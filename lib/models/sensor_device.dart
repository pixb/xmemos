import 'package:flutter/material.dart';

enum SensorChartType {
  line,
  horizontal,
}

class SensorDevice {
  final String id;
  final String title;
  final String value;
  final String unit;
  final Color statusColor;
  final SensorChartType chartType;
  final List<double> chartData;

  SensorDevice({
    required this.id,
    required this.title,
    required this.value,
    required this.unit,
    required this.statusColor,
    required this.chartType,
    required this.chartData,
  });
}
