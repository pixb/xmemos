import 'package:flutter/material.dart';

enum HomeItemType {
  watch,
  alarm,
}

enum StatusIndicatorType {
  notification,
  flag,
  error,
  volumeOff,
}

class HomeItem {
  final String id;
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color iconColor;
  final HomeItemType type;
  final List<StatusIndicator> indicators;
  final String? additionalText;

  HomeItem({
    required this.id,
    required this.title,
    this.subtitle,
    required this.icon,
    this.iconColor = Colors.blue,
    required this.type,
    this.indicators = const [],
    this.additionalText,
  });
}

class StatusIndicator {
  final IconData icon;
  final int count;
  final Color color;
  final StatusIndicatorType type;

  StatusIndicator({
    required this.icon,
    required this.count,
    this.color = Colors.blue,
    required this.type,
  });
}
