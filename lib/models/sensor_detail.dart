import 'package:flutter/material.dart';

enum SensorParameterType {
  pv,
  sp,
  out,
}

class SensorParameter {
  final String name;
  final double value;
  final Color color;
  final SensorParameterType type;

  SensorParameter({
    required this.name,
    required this.value,
    required this.color,
    required this.type,
  });
}

enum TimeRange {
  oneHour,
  twoHours,
  sixHours,
  twelveHours,
  twentyFourHours,
}

extension TimeRangeExtension on TimeRange {
  String get label {
    switch (this) {
      case TimeRange.oneHour:
        return '1 hr';
      case TimeRange.twoHours:
        return '2 hr';
      case TimeRange.sixHours:
        return '6 hr';
      case TimeRange.twelveHours:
        return '12 hr';
      case TimeRange.twentyFourHours:
        return '24 hr';
    }
  }
}

class SensorDetail {
  final String id;
  final String title;
  final String description;
  final String deltaVSystem;
  final String casAuto;
  final List<SensorParameter> parameters;
  final String pvScale;
  final Map<SensorParameterType, List<double>> chartData;
  final List<String> conditions;

  SensorDetail({
    required this.id,
    required this.title,
    required this.description,
    required this.deltaVSystem,
    required this.casAuto,
    required this.parameters,
    required this.pvScale,
    required this.chartData,
    required this.conditions,
  });
}
