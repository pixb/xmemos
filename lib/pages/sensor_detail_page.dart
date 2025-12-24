import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/sensor_detail.dart';

class SensorDetailPage extends StatefulWidget {
  final String sensorId;
  final String title;

  const SensorDetailPage({Key? key, required this.sensorId, required this.title}) : super(key: key);

  @override
  State<SensorDetailPage> createState() => _SensorDetailPageState();
}

class _SensorDetailPageState extends State<SensorDetailPage> {
  TimeRange _selectedTimeRange = TimeRange.oneHour;
  late SensorDetail _sensorDetail;

  @override
  void initState() {
    super.initState();
    // Mock data for sensor detail
    _sensorDetail = SensorDetail(
      id: widget.sensorId,
      title: widget.title,
      description: 'Header Master Description',
      deltaVSystem: 'BOILER_AREA',
      casAuto: 'CAS/AUTO',
      parameters: [
        SensorParameter(
          name: 'PV',
          value: 101.0,
          color: Colors.blue,
          type: SensorParameterType.pv,
        ),
        SensorParameter(
          name: 'SP',
          value: 114.0,
          color: Colors.green,
          type: SensorParameterType.sp,
        ),
        SensorParameter(
          name: 'OUT',
          value: 71.0,
          color: Colors.black,
          type: SensorParameterType.out,
        ),
      ],
      pvScale: '0 - 200 psig',
      chartData: {
        SensorParameterType.pv: [105.0, 102.0, 104.0, 101.0, 103.0, 100.0, 102.0, 101.0, 104.0, 102.0, 103.0, 101.0],
        SensorParameterType.sp: [110.0, 112.0, 114.0, 113.0, 115.0, 114.0, 113.0, 114.0, 115.0, 113.0, 114.0, 114.0],
        SensorParameterType.out: [70.0, 72.0, 73.0, 71.0, 72.0, 70.0, 71.0, 71.0, 73.0, 72.0, 71.0, 71.0],
      },
      conditions: ['Abnormal Mode'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Device Information
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _sensorDetail.description,
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.sensorId,
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'DeltaV System : ${_sensorDetail.deltaVSystem}',
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      _sensorDetail.casAuto,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            // Parameters Section
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.white,
              margin: const EdgeInsets.only(top: 8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (var param in _sensorDetail.parameters)
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.circle,
                                    color: param.color,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(param.name, style: const TextStyle(fontSize: 14)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                param.value.toString(),
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      // PV Scale
                      Column(
                        children: [
                          const Text('PV Scale', style: TextStyle(fontSize: 12, color: Colors.black54)),
                          Text(_sensorDetail.pvScale, style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Progress Bars
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (var param in _sensorDetail.parameters)
                        Expanded(
                          child: Container(
                            height: 4,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: FractionallySizedBox(
                              widthFactor: param.type == SensorParameterType.out ? param.value / 100 : param.value / 200,
                              child: Container(
                                color: param.color,
                                height: 4,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Time Range Selector
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.white,
              margin: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (var range in TimeRange.values)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTimeRange = range;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _selectedTimeRange == range ? Colors.blue : Colors.grey[200],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          range.label,
                          style: TextStyle(
                            color: _selectedTimeRange == range ? Colors.white : Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  // Settings Icon
                  const Icon(Icons.settings, color: Colors.grey),
                ],
              ),
            ),

            // Chart Section
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.white,
              margin: const EdgeInsets.only(top: 8.0),
              child: _buildChart(),
            ),

            // Conditions Section
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.white,
              margin: const EdgeInsets.only(top: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Conditions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  for (var condition in _sensorDetail.conditions)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red[200]!, width: 1),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red, size: 20),
                          const SizedBox(width: 8),
                          Text(condition, style: const TextStyle(fontSize: 14, color: Colors.red)),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Bottom Navigation
      bottomNavigationBar: Container(
        height: 60,
        color: Colors.grey[200],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.save, size: 24),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.refresh, size: 24),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart() {
    final List<LineChartBarData> lines = [];

    // Create line for each parameter type
    for (var entry in _sensorDetail.chartData.entries) {
      final color = entry.key == SensorParameterType.pv 
          ? Colors.blue 
          : entry.key == SensorParameterType.sp 
              ? Colors.green 
              : Colors.black;

      lines.add(LineChartBarData(
        spots: entry.value.asMap().entries.map((e) {
          return FlSpot(e.key.toDouble(), e.value);
        }).toList(),
        isCurved: true,
        color: color,
        barWidth: 2,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
      ));
    }

    return SizedBox(
      height: 300,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: true, drawVerticalLine: false),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 20,
                getTitlesWidget: (value, meta) {
                  // Generate time labels
                  final hour = 10 + (value.toInt() / 6).floor();
                  final minute = (value.toInt() % 6) * 10;
                  return Text('$hour:$minute'.padLeft(5, '0'));
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 40),
            ),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey[300]!)),
          lineBarsData: lines,
          minX: 0,
          maxX: (lines.first.spots.length - 1).toDouble(),
          minY: 60,
          maxY: 180,
        ),
      ),
    );
  }
}
